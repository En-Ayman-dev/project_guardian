// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:uuid/uuid.dart';
// import '../../../../core/di/injection_container.dart';
// import '../../domain/entities/category_entity.dart';
// import '../../domain/entities/product_entity.dart';
// import '../../domain/entities/unit_entity.dart';
// import '../manager/inventory_settings_cubit.dart';
// import '../manager/inventory_settings_state.dart';
// import '../manager/product_cubit.dart';
// import '../manager/product_state.dart';

// class ProductFormPage extends StatelessWidget {
//   final ProductEntity? productToEdit; // 1. استقبال المنتج المراد تعديله

//   const ProductFormPage({super.key, this.productToEdit});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (context) => getIt<ProductCubit>()),
//         BlocProvider(
//           create: (context) => getIt<InventorySettingsCubit>()
//             ..loadCategories()
//             ..loadUnits(),
//         ),
//       ],
//       child: _ProductFormView(productToEdit: productToEdit),
//     );
//   }
// }

// class _ProductFormView extends StatefulWidget {
//   final ProductEntity? productToEdit;
//   const _ProductFormView({this.productToEdit});

//   @override
//   State<_ProductFormView> createState() => _ProductFormViewState();
// }

// class _ProductFormViewState extends State<_ProductFormView> {
//   final _formKey = GlobalKey<FormState>();

//   late TextEditingController _nameCtrl;
//   late TextEditingController _barcodeCtrl;
//   late TextEditingController _descCtrl;
//   late TextEditingController _buyPriceCtrl;
//   late TextEditingController _sellPriceCtrl;
//   late TextEditingController _stockCtrl;
//   late TextEditingController _minStockCtrl;

//   CategoryEntity? _selectedCategory;
//   UnitEntity? _selectedUnit;

//   @override
//   void initState() {
//     super.initState();
//     final p = widget.productToEdit;

//     // 2. ملء البيانات إذا كنا في وضع التعديل
//     _nameCtrl = TextEditingController(text: p?.name ?? '');
//     _barcodeCtrl = TextEditingController(text: p?.barcode ?? '');
//     _descCtrl = TextEditingController(text: p?.description ?? '');
//     _buyPriceCtrl = TextEditingController(text: p?.purchasePrice.toString() ?? '');
//     _sellPriceCtrl = TextEditingController(text: p?.sellPrice.toString() ?? '');
//     _stockCtrl = TextEditingController(text: p?.stock.toString() ?? '0');
//     _minStockCtrl = TextEditingController(text: p?.minStockAlert.toString() ?? '5');

//     if (p != null) {
//       // إعادة بناء كائنات القسم والوحدة ليتعرف عليها الـ Dropdown (Equality check)
//       _selectedCategory = CategoryEntity(id: p.categoryId, name: p.categoryName);
//       _selectedUnit = UnitEntity(id: p.unitId, name: p.unitName);
//     }
//   }

//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _barcodeCtrl.dispose();
//     _descCtrl.dispose();
//     _buyPriceCtrl.dispose();
//     _sellPriceCtrl.dispose();
//     _stockCtrl.dispose();
//     _minStockCtrl.dispose();
//     super.dispose();
//   }

//   void _submit() {
//     if (_formKey.currentState!.validate()) {
//       if (_selectedCategory == null || _selectedUnit == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please select Category and Unit')),
//         );
//         return;
//       }

//       final isEditing = widget.productToEdit != null;

//       final product = ProductEntity(
//         // 3. الحفاظ على الـ ID القديم عند التعديل، أو إنشاء جديد عند الإضافة
//         id: isEditing ? widget.productToEdit!.id : const Uuid().v4(),
//         name: _nameCtrl.text,
//         barcode: _barcodeCtrl.text.isEmpty ? null : _barcodeCtrl.text,
//         description: _descCtrl.text,
//         categoryId: _selectedCategory!.id,
//         categoryName: _selectedCategory!.name,
//         unitId: _selectedUnit!.id,
//         unitName: _selectedUnit!.name,
//         purchasePrice: double.tryParse(_buyPriceCtrl.text) ?? 0.0,
//         sellPrice: double.tryParse(_sellPriceCtrl.text) ?? 0.0,
//         stock: double.tryParse(_stockCtrl.text) ?? 0.0,
//         minStockAlert: int.tryParse(_minStockCtrl.text) ?? 5,
//         createdAt: isEditing ? widget.productToEdit!.createdAt : DateTime.now(),
//       );

//       // 4. استدعاء الدالة المناسبة
//       if (isEditing) {
//         context.read<ProductCubit>().updateProduct(product);
//       } else {
//         context.read<ProductCubit>().addProduct(product);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isEditing = widget.productToEdit != null;

//     return Scaffold(
//       appBar: AppBar(title: Text(isEditing ? 'Edit Product' : 'New Product')),
//       body: BlocListener<ProductCubit, ProductState>(
//         listener: (context, state) {
//           if (state.isActionSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Saved Successfully'), backgroundColor: Colors.green),
//             );
//             context.pop(true);
//           }
//           if (state.errorMessage != null) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
//             );
//           }
//         },
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: _nameCtrl,
//                   decoration: const InputDecoration(labelText: 'Product Name *', prefixIcon: Icon(Icons.shopping_bag)),
//                   validator: (v) => v!.isEmpty ? 'Required' : null,
//                 ),
//                 const SizedBox(height: 16),

//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         controller: _barcodeCtrl,
//                         decoration: const InputDecoration(labelText: 'Barcode', prefixIcon: Icon(Icons.qr_code)),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.camera_alt),
//                       onPressed: () {},
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),

//                 BlocBuilder<InventorySettingsCubit, InventorySettingsState>(
//                   builder: (context, state) {
//                     if (state.isLoading) return const LinearProgressIndicator();

//                     return Row(
//                       children: [
//                         Expanded(
//                           child: DropdownButtonFormField<CategoryEntity>(
//                             value: _selectedCategory, // سيختار القيمة تلقائياً بفضل Equatable
//                             decoration: const InputDecoration(labelText: 'Category *'),
//                             items: state.categories.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
//                             onChanged: (v) => setState(() => _selectedCategory = v),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: DropdownButtonFormField<UnitEntity>(
//                             value: _selectedUnit,
//                             decoration: const InputDecoration(labelText: 'Unit *'),
//                             items: state.units.map((u) => DropdownMenuItem(value: u, child: Text(u.name))).toList(),
//                             onChanged: (v) => setState(() => _selectedUnit = v),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 16),

//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         controller: _buyPriceCtrl,
//                         keyboardType: TextInputType.number,
//                         decoration: const InputDecoration(labelText: 'Buy Price', prefixIcon: Icon(Icons.attach_money)),
//                         validator: (v) => v!.isEmpty ? 'Required' : null,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: TextFormField(
//                         controller: _sellPriceCtrl,
//                         keyboardType: TextInputType.number,
//                         decoration: const InputDecoration(labelText: 'Sell Price', prefixIcon: Icon(Icons.attach_money)),
//                         validator: (v) => v!.isEmpty ? 'Required' : null,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),

//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         controller: _stockCtrl,
//                         keyboardType: TextInputType.number,
//                         decoration: const InputDecoration(labelText: 'Stock'),
//                         // منع تعديل المخزون يدوياً عند التعديل لضمان الدقة المحاسبية (اختياري)
//                         // enabled: !isEditing,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: TextFormField(
//                         controller: _minStockCtrl,
//                         keyboardType: TextInputType.number,
//                         decoration: const InputDecoration(labelText: 'Min Alert'),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),

//                 SizedBox(
//                   width: double.infinity,
//                   child: BlocBuilder<ProductCubit, ProductState>(
//                     builder: (context, state) {
//                       return ElevatedButton(
//                         onPressed: state.isLoading ? null : _submit,
//                         child: state.isLoading
//                             ? const CircularProgressIndicator(color: Colors.white)
//                             : Text(isEditing ? 'Update Product' : 'Save Product'),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/product_unit_entity.dart';
import '../../domain/entities/unit_entity.dart';
import '../manager/inventory_settings_cubit.dart';
import '../manager/inventory_settings_state.dart';
import '../manager/product_cubit.dart';
import '../manager/product_state.dart';
import '../widgets/product_unit_form_card.dart';

// كلاس مساعد لإدارة الـ Controllers لكل وحدة
class UnitFormController {
  final String id; // معرف فرعي للتمييز
  UnitEntity? selectedUnit;
  final TextEditingController factorCtrl;
  final TextEditingController buyCtrl;
  final TextEditingController sellCtrl;
  final TextEditingController barcodeCtrl;

  UnitFormController({
    required this.id,
    this.selectedUnit,
    String factor = '1',
    String buy = '',
    String sell = '',
    String barcode = '',
  }) : factorCtrl = TextEditingController(text: factor),
       buyCtrl = TextEditingController(text: buy),
       sellCtrl = TextEditingController(text: sell),
       barcodeCtrl = TextEditingController(text: barcode);

  void dispose() {
    factorCtrl.dispose();
    buyCtrl.dispose();
    sellCtrl.dispose();
    barcodeCtrl.dispose();
  }
}

class ProductFormPage extends StatelessWidget {
  final ProductEntity? productToEdit;

  const ProductFormPage({super.key, this.productToEdit});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<ProductCubit>()),
        BlocProvider(
          create: (context) => getIt<InventorySettingsCubit>()
            ..loadCategories()
            ..loadUnits(),
        ),
      ],
      child: _ProductFormView(productToEdit: productToEdit),
    );
  }
}

class _ProductFormView extends StatefulWidget {
  final ProductEntity? productToEdit;
  const _ProductFormView({this.productToEdit});

  @override
  State<_ProductFormView> createState() => _ProductFormViewState();
}

class _ProductFormViewState extends State<_ProductFormView> {
  final _formKey = GlobalKey<FormState>();

  // Main Product Controllers
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _stockCtrl;
  late TextEditingController _minStockCtrl;
  CategoryEntity? _selectedCategory;

  // List of Unit Controllers
  final List<UnitFormController> _unitControllers = [];

  @override
  void initState() {
    super.initState();
    final p = widget.productToEdit;

    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _stockCtrl = TextEditingController(text: p?.stock.toString() ?? '0');
    _minStockCtrl = TextEditingController(
      text: p?.minStockAlert.toString() ?? '5',
    );

    if (p != null) {
      // Edit Mode: Load Category
      _selectedCategory = CategoryEntity(
        id: p.categoryId,
        name: p.categoryName,
      );

      // Edit Mode: Load Units
      for (var u in p.units) {
        // البحث عن الوحدة الأصلية في القائمة (سيتم ربطها لاحقاً عند عرض القوائم)
        // هنا نقوم بإنشاء المتحكمات فقط
        _unitControllers.add(
          UnitFormController(
            id: const Uuid().v4(),
            selectedUnit: UnitEntity(
              id: u.unitId,
              name: u.unitName,
            ), // Temporary
            factor: u.conversionFactor
                .toString(), // يمكن عرضه كـ int إذا كان صحيحاً
            buy: u.buyPrice.toString(),
            sell: u.sellPrice.toString(),
            barcode: u.barcode ?? '',
          ),
        );
      }
    } else {
      // Create Mode: Add at least one Base Unit
      _addUnitRow(isBase: true);
    }
  }

  void _addUnitRow({bool isBase = false}) {
    setState(() {
      _unitControllers.add(
        UnitFormController(id: const Uuid().v4(), factor: isBase ? '1' : ''),
      );
    });
  }

  void _removeUnitRow(int index) {
    if (index == 0) return; // Cannot remove base unit
    setState(() {
      _unitControllers[index].dispose();
      _unitControllers.removeAt(index);
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _stockCtrl.dispose();
    _minStockCtrl.dispose();
    for (var c in _unitControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Select Category')));
        return;
      }

      // بناء قائمة الوحدات من المتحكمات
      final List<ProductUnitEntity> units = [];

      for (var c in _unitControllers) {
        if (c.selectedUnit == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Select Unit for all rows')),
          );
          return;
        }

        units.add(
          ProductUnitEntity(
            unitId: c.selectedUnit!.id,
            unitName: c.selectedUnit!.name,
            conversionFactor: double.tryParse(c.factorCtrl.text) ?? 1.0,
            buyPrice: double.tryParse(c.buyCtrl.text) ?? 0.0,
            sellPrice: double.tryParse(c.sellCtrl.text) ?? 0.0,
            barcode: c.barcodeCtrl.text.isEmpty ? null : c.barcodeCtrl.text,
          ),
        );
      }

      final isEditing = widget.productToEdit != null;

      final product = ProductEntity(
        id: isEditing ? widget.productToEdit!.id : const Uuid().v4(),
        name: _nameCtrl.text,
        description: _descCtrl.text,
        categoryId: _selectedCategory!.id,
        categoryName: _selectedCategory!.name,
        units: units, // القائمة الجديدة
        stock: double.tryParse(_stockCtrl.text) ?? 0.0,
        minStockAlert: int.tryParse(_minStockCtrl.text) ?? 5,
        createdAt: isEditing ? widget.productToEdit!.createdAt : DateTime.now(),
      );

      if (isEditing) {
        context.read<ProductCubit>().updateProduct(product);
      } else {
        context.read<ProductCubit>().addProduct(product);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productToEdit != null ? 'Edit Product' : 'New Product',
        ),
      ),
      body: BlocListener<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state.isActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Saved Successfully'),
                backgroundColor: Colors.green,
              ),
            );
            context.pop(true);
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Basic Info
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Product Name *',
                    prefixIcon: Icon(Icons.shopping_bag),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                BlocBuilder<InventorySettingsCubit, InventorySettingsState>(
                  builder: (context, state) {
                    if (state.isLoading) return const LinearProgressIndicator();
                    return DropdownButtonFormField<CategoryEntity>(
                      initialValue: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category *',
                      ),
                      items: state.categories
                          .map(
                            (c) =>
                                DropdownMenuItem(value: c, child: Text(c.name)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedCategory = v),
                      validator: (v) => v == null ? 'Required' : null,
                    );
                  },
                ),
                const SizedBox(height: 24),

                // 2. Units Section (Dynamic List)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Product Units',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _addUnitRow,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add Unit'),
                      style: ElevatedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        minimumSize: const Size(0, 40),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                BlocBuilder<InventorySettingsCubit, InventorySettingsState>(
                  builder: (context, state) {
                    // نمرر قائمة الوحدات المتاحة لكل ويدجت
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _unitControllers.length,
                      itemBuilder: (context, index) {
                        return ProductUnitFormCard(
                          key: ValueKey(
                            _unitControllers[index].id,
                          ), // مهم جداً للأداء
                          index: index,
                          isBaseUnit: index == 0,
                          availableUnits: state.units,
                          selectedUnit: _unitControllers[index].selectedUnit,
                          factorCtrl: _unitControllers[index].factorCtrl,
                          buyPriceCtrl: _unitControllers[index].buyCtrl,
                          sellPriceCtrl: _unitControllers[index].sellCtrl,
                          barcodeCtrl: _unitControllers[index].barcodeCtrl,
                          onUnitChanged: (u) {
                            setState(() {
                              _unitControllers[index].selectedUnit = u;
                            });
                          },
                          onRemove: () => _removeUnitRow(index),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 24),

                // 3. Stock Info
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _stockCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Current Stock (Base Unit)',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _minStockCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Min Alert',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 4. Save Button
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state.isLoading ? null : _submit,
                        child: state.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Save Product'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
