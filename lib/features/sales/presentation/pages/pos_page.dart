import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../../clients_suppliers/domain/entities/client_supplier_entity.dart';
import '../../../clients_suppliers/domain/entities/enums/client_type.dart';
import '../manager/sales_cubit.dart';
import '../manager/sales_state.dart';

// --- استيراد الودجات المقسمة ---
import '../widgets/pos/pos_app_bar.dart';
import '../widgets/pos/pos_client_section.dart';
import '../widgets/pos/pos_product_entry.dart';
import '../widgets/pos/pos_items_table.dart';
import '../widgets/pos/pos_financial_footer.dart';

class PosPage extends StatelessWidget {
  final InvoiceEntity? invoiceToEdit;
  final InvoiceEntity? originalInvoiceForReturn;

  const PosPage({super.key, this.invoiceToEdit, this.originalInvoiceForReturn});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = getIt<SalesCubit>();
        if (invoiceToEdit != null) {
          cubit.initialize(invoiceToEdit: invoiceToEdit);
        } else if (originalInvoiceForReturn != null) {
          cubit.initializeForReturn(originalInvoiceForReturn!);
        } else {
          cubit.initialize();
        }
        return cubit;
      },
      child: _InvoiceEntryView(
        invoiceToEdit: invoiceToEdit,
        originalInvoiceForReturn: originalInvoiceForReturn,
      ),
    );
  }
}

class _InvoiceEntryView extends StatefulWidget {
  final InvoiceEntity? invoiceToEdit;
  final InvoiceEntity? originalInvoiceForReturn;

  const _InvoiceEntryView({this.invoiceToEdit, this.originalInvoiceForReturn});

  @override
  State<_InvoiceEntryView> createState() => _InvoiceEntryViewState();
}

class _InvoiceEntryViewState extends State<_InvoiceEntryView> {
  final TextEditingController _discountCtrl = TextEditingController();
  final TextEditingController _paidCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();

  // كنترولر للبحث عن الفاتورة الأصلية
  final TextEditingController _originalInvoiceSearchCtrl =
      TextEditingController();

  ClientSupplierEntity? _selectedClient;

  @override
  void initState() {
    super.initState();
    // Hydration Logic
    if (widget.invoiceToEdit != null) {
      _fillData(widget.invoiceToEdit!);
    } else if (widget.originalInvoiceForReturn != null) {
      _fillData(widget.originalInvoiceForReturn!);
      _paidCtrl.clear();
      _discountCtrl.clear();
      _noteCtrl.text =
          'مرتجع للفاتورة #${widget.originalInvoiceForReturn!.invoiceNumber}';
    }
  }

  void _fillData(InvoiceEntity inv) {
    _discountCtrl.text = inv.discount > 0 ? inv.discount.toString() : '';
    _paidCtrl.text = inv.paidAmount > 0 ? inv.paidAmount.toString() : '';
    _noteCtrl.text = inv.note ?? '';

    if (inv.originalInvoiceNumber != null) {
      _originalInvoiceSearchCtrl.text = inv.originalInvoiceNumber!;
    }

    _selectedClient = ClientSupplierEntity(
      id: inv.clientId,
      name: inv.clientName,
      email: '',
      phone: '',
      address: '',
      type: ClientType.client,
      createdAt: DateTime.now(),
    );
  }

  @override
  void dispose() {
    _discountCtrl.dispose();
    _paidCtrl.dispose();
    _noteCtrl.dispose();
    _originalInvoiceSearchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.invoiceToEdit != null;
    final isReturn = widget.originalInvoiceForReturn != null;

    return BlocConsumer<SalesCubit, SalesState>(
      listenWhen: (previous, current) {
        final msgChanged = previous.errorMessage != current.errorMessage ||
            previous.isSuccess != current.isSuccess;
        final originalInvoiceChanged =
            previous.originalInvoice != current.originalInvoice;
        return msgChanged || originalInvoiceChanged;
      },
      listener: (context, state) {
        // A. البحث الناجح
        if (state.originalInvoice != null &&
            _selectedClient?.id != state.originalInvoice!.clientId) {
          final client = state.clients.firstWhere(
            (c) => c.id == state.originalInvoice!.clientId,
            orElse: () => ClientSupplierEntity(
              id: state.originalInvoice!.clientId,
              name: state.originalInvoice!.clientName,
              email: '',
              phone: '',
              address: '',
              type: ClientType.client,
              createdAt: DateTime.now(),
            ),
          );

          setState(() {
            _selectedClient = client;
            if (_noteCtrl.text.isEmpty) {
              _noteCtrl.text =
                  "مرتجع من الفاتورة #${state.originalInvoice!.invoiceNumber}";
            }
            if (!isEdit) {
              _paidCtrl.text = "0";
              _discountCtrl.text = "0";
            }
          });

          if (!isEdit) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("✅ تم تحميل بيانات الفاتورة والعميل بنجاح"),
                backgroundColor: Colors.blueAccent,
              ),
            );
          }
        }

        // B. النجاح والحفظ
        if (state.isSuccess) {
          String msg = 'تم حفظ الفاتورة بنجاح';
          if (isEdit) msg = 'تم تعديل الفاتورة بنجاح';
          if (state.invoiceType == InvoiceType.salesReturn ||
              state.invoiceType == InvoiceType.purchaseReturn) {
            msg = isEdit ? 'تم تعديل المرتجع بنجاح' : 'تم حفظ المرتجع بنجاح';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg), backgroundColor: Colors.green),
          );

          if (isEdit || isReturn) {
            if (context.canPop()) context.pop();
          } else {
            _resetForm(context);
          }
        }

        // C. الأخطاء
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading && state.products.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          // [FIX] منع تغيير حجم الواجهة عند ظهور الكيبورد لتجنب Overflow
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey[50], // خلفية فاتحة لجمالية التصميم
          appBar: PosAppBar(
            invoiceType: state.invoiceType,
            isEdit: isEdit,
            isReturn: isReturn,
            invoiceNumber: widget.invoiceToEdit?.invoiceNumber,
            onTypeChanged: () {
              _resetForm(context);
            },
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 900;

                return Column(
                  children: [
                    // =========================
                    // 🔹 BODY
                    // =========================
                    Expanded(
                      child: isWide
                          ? Row(
                              children: [
                                // ===== LEFT: Client + Product =====
                                SizedBox(
                                  width: constraints.maxWidth * 0.4,
                                  child: SingleChildScrollView(
                                    keyboardDismissBehavior:
                                        ScrollViewKeyboardDismissBehavior
                                            .onDrag,
                                    child: Column(
                                      children: [
                                        PosClientSection(
                                          invoiceType: state.invoiceType,
                                          clients: state.clients,
                                          selectedClient: _selectedClient,
                                          invoiceNumber: widget
                                              .invoiceToEdit?.invoiceNumber,
                                          invoiceDate:
                                              widget.invoiceToEdit?.date ??
                                                  DateTime.now(),
                                          onClientSelected: (selection) =>
                                              setState(() =>
                                                  _selectedClient = selection),
                                          searchController:
                                              _originalInvoiceSearchCtrl,
                                        ),
                                        PosProductEntry(
                                          invoiceType: state.invoiceType,
                                          products: state.products,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // ===== RIGHT: CART =====
                                Expanded(
                                  child: PosItemsTable(
                                    items: state.cartItems,
                                  ),
                                ),
                              ],
                            )

                          // =========================
                          // 📱 MOBILE LAYOUT
                          // =========================
                          : Column(
                              children: [
                                // =========================
                                // 🔹 القسم العلوي (مرن + Scroll)
                                // =========================
                                Flexible(
                                  flex: 4,
                                  child: SingleChildScrollView(
                                    keyboardDismissBehavior:
                                        ScrollViewKeyboardDismissBehavior
                                            .onDrag,
                                    child: Column(
                                      children: [
                                        PosClientSection(
                                          invoiceType: state.invoiceType,
                                          clients: state.clients,
                                          selectedClient: _selectedClient,
                                          invoiceNumber: widget
                                              .invoiceToEdit?.invoiceNumber,
                                          invoiceDate:
                                              widget.invoiceToEdit?.date ??
                                                  DateTime.now(),
                                          onClientSelected: (selection) =>
                                              setState(() =>
                                                  _selectedClient = selection),
                                          searchController:
                                              _originalInvoiceSearchCtrl,
                                        ),
                                        PosProductEntry(
                                          invoiceType: state.invoiceType,
                                          products: state.products,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // =========================
                                // 🔹 جدول السلة (مرن)
                                // =========================
                                Expanded(
                                  flex: 6,
                                  child: PosItemsTable(
                                    items: state.cartItems,
                                  ),
                                ),
                              ],
                            ),
                    ),

                    // =========================
                    // 🔹 FOOTER (ثابت دائمًا)
                    // =========================
                    PosFinancialFooter(
                      state: state,
                      isEdit: isEdit,
                      isReturn: isReturn,
                      discountCtrl: _discountCtrl,
                      paidCtrl: _paidCtrl,
                      noteCtrl: _noteCtrl,
                      onDiscountChanged: (val) =>
                          context.read<SalesCubit>().setDiscount(val),
                      onPaidChanged: (val) =>
                          context.read<SalesCubit>().setPaidAmount(val),
                      onPaymentTypeChanged: (type) =>
                          context.read<SalesCubit>().setPaymentType(type),
                      onSubmit: (state.cartItems.isNotEmpty &&
                              _selectedClient != null)
                          ? () {
                              context.read<SalesCubit>().submitInvoice(
                                    clientId: _selectedClient!.id,
                                    clientName: _selectedClient!.name,
                                    note: _noteCtrl.text,
                                  );
                            }
                          : null,
                    ),
                  ],
                );
              },
            ),
          ),
        
        );
      },
    );
  }

  void _resetForm(BuildContext context) {
    setState(() {
      _selectedClient = null;
      _discountCtrl.clear();
      _paidCtrl.clear();
      _noteCtrl.clear();
      _originalInvoiceSearchCtrl.clear();
    });
    context.read<SalesCubit>().resetAfterSuccess();
  }
}
