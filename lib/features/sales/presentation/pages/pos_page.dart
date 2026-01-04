import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/invoice_item_entity.dart';
import '../../../inventory/domain/entities/product_entity.dart';
import '../../../inventory/domain/entities/product_unit_entity.dart';
import '../../../clients_suppliers/domain/entities/client_supplier_entity.dart';
import '../manager/sales_cubit.dart';
import '../manager/sales_state.dart';

class PosPage extends StatelessWidget {
  const PosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SalesCubit>()..loadInitialData(),
      child: const _PosView(),
    );
  }
}

class _PosView extends StatefulWidget {
  const _PosView();

  @override
  State<_PosView> createState() => _PosViewState();
}

class _PosViewState extends State<_PosView> {
  ClientSupplierEntity? _selectedClient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Sale (POS)')),
      body: BlocConsumer<SalesCubit, SalesState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice Saved Successfully!'), backgroundColor: Colors.green));
            context.pop(); // العودة للوحة التحكم
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red));
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // 1. Client Selection
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<ClientSupplierEntity>(
                  value: _selectedClient,
                  decoration: const InputDecoration(labelText: 'Select Client', border: OutlineInputBorder()),
                  items: state.clients.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                  onChanged: (v) => setState(() => _selectedClient = v),
                ),
              ),

              // 2. Main Content (Products List + Cart Preview)
              Expanded(
                child: Row(
                  children: [
                    // Left Side: Products List
                    Expanded(
                      flex: 3,
                      child: _buildProductsList(context, state.products),
                    ),
                    const VerticalDivider(width: 1),
                    // Right Side: Cart Summary
                    Expanded(
                      flex: 2,
                      child: _buildCartSummary(context, state),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductsList(BuildContext context, List<ProductEntity> products) {
    if (products.isEmpty) return const Center(child: Text("No Products"));
    
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.all(4),
          child: ListTile(
            leading: const Icon(Icons.shopping_bag, color: Colors.blue),
            title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Stock: ${product.stock}'),
            trailing: IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.green),
              onPressed: () => _showAddToCartDialog(context, product),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartSummary(BuildContext context, SalesState state) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.grey.shade200,
          width: double.infinity,
          child: const Text("Cart Items", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        Expanded(
          child: state.cartItems.isEmpty
              ? const Center(child: Text("Cart is Empty"))
              : ListView.builder(
                  itemCount: state.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = state.cartItems[index];
                    return ListTile(
                      dense: true,
                      title: Text(item.productName),
                      subtitle: Text('${item.quantity} x ${item.unitName} @ ${item.price}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(item.total.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.close, size: 16, color: Colors.red),
                            onPressed: () => context.read<SalesCubit>().removeFromCart(index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("Total:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(state.totalAmount.toStringAsFixed(2), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
              ]),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  onPressed: state.cartItems.isEmpty || _selectedClient == null
                      ? null
                      : () {
                          context.read<SalesCubit>().submitInvoice(_selectedClient!.id, _selectedClient!.name);
                        },
                  child: state.isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("CHECKOUT"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ديالوج لاختيار الوحدة والكمية
  // ديالوج لاختيار الوحدة والكمية
  void _showAddToCartDialog(BuildContext context, ProductEntity product) {
    // 1. التقاط الكيوبت من السياق الحالي (الصفحة) قبل فتح الديالوج
    // لأن سياق الديالوج لن يرى الكيوبت
    final salesCubit = context.read<SalesCubit>();

    ProductUnitEntity selectedUnit = product.baseUnit;
    final qtyCtrl = TextEditingController(text: '1');
    final priceCtrl = TextEditingController(text: selectedUnit.sellPrice.toString());

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogContext, setState) {
          return AlertDialog(
            title: Text(product.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<ProductUnitEntity>(
                  value: selectedUnit,
                  decoration: const InputDecoration(labelText: 'Unit'),
                  items: product.units.map((u) => DropdownMenuItem(value: u, child: Text(u.unitName))).toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() {
                        selectedUnit = v;
                        priceCtrl.text = v.sellPrice.toString();
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceCtrl,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: qtyCtrl,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  final qty = int.tryParse(qtyCtrl.text) ?? 1;
                  final price = double.tryParse(priceCtrl.text) ?? 0.0;
                  
                  final item = InvoiceItemEntity(
                    productId: product.id,
                    productName: product.name,
                    unitId: selectedUnit.unitId,
                    unitName: selectedUnit.unitName,
                    conversionFactor: selectedUnit.conversionFactor,
                    quantity: qty,
                    price: price,
                    total: qty * price,
                  );
                  
                  // 2. استخدام المتغير الملتقط بدلاً من context.read
                  salesCubit.addToCart(item);
                  
                  Navigator.pop(ctx);
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }
}