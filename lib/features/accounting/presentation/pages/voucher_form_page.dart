// [phase_2] modification
// file: lib/features/accounting/presentation/pages/voucher_form_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/voucher_entity.dart';
import '../../../clients_suppliers/domain/entities/client_supplier_entity.dart';
import '../../../clients_suppliers/domain/entities/enums/client_type.dart';
import '../manager/accounting_cubit.dart';
import '../manager/accounting_state.dart';

class VoucherFormPage extends StatelessWidget {
  final ClientSupplierEntity clientSupplier;
  final VoucherEntity? voucherToEdit;

  const VoucherFormPage({
    super.key,
    required this.clientSupplier,
    this.voucherToEdit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AccountingCubit>(),
      child: _VoucherView(
        clientSupplier: clientSupplier,
        voucherToEdit: voucherToEdit,
      ),
    );
  }
}

class _VoucherView extends StatefulWidget {
  final ClientSupplierEntity clientSupplier;
  final VoucherEntity? voucherToEdit;

  const _VoucherView({required this.clientSupplier, this.voucherToEdit});

  @override
  State<_VoucherView> createState() => _VoucherViewState();
}

class _VoucherViewState extends State<_VoucherView> {
  final _formKey = GlobalKey<FormState>();

  late VoucherType _selectedType;
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  late TextEditingController _linkedInvoiceController;

  final List<String> _quickNotes = [
    'دفعة من الحساب',
    'سداد فاتورة رقم ',
    'تسوية رصيد',
    'دفعة مقدمة',
  ];

  @override
  void initState() {
    super.initState();
    final editVoucher = widget.voucherToEdit;

    if (editVoucher != null) {
      _selectedType = editVoucher.type;
      _amountController = TextEditingController(
        text: editVoucher.amount.toString(),
      );
      _noteController = TextEditingController(text: editVoucher.note);
      _linkedInvoiceController = TextEditingController(
        text: editVoucher.linkedInvoiceId ?? '',
      );
    } else {
      _selectedType = widget.clientSupplier.type == ClientType.client
          ? VoucherType.receipt
          : VoucherType.payment;
      _amountController = TextEditingController();
      _noteController = TextEditingController();
      _linkedInvoiceController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _linkedInvoiceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      final isEditing = widget.voucherToEdit != null;

      final voucher = VoucherEntity(
        id: isEditing ? widget.voucherToEdit!.id : const Uuid().v4(),
        voucherNumber: isEditing
            ? widget.voucherToEdit!.voucherNumber
            : '#VO-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        type: _selectedType,
        amount: amount,
        date: isEditing ? widget.voucherToEdit!.date : DateTime.now(),
        clientSupplierId: widget.clientSupplier.id,
        clientSupplierName: widget.clientSupplier.name,
        linkedInvoiceId: _linkedInvoiceController.text.isEmpty
            ? null
            : _linkedInvoiceController.text,
        note: _noteController.text,
      );

      if (isEditing) {
        context.read<AccountingCubit>().updateVoucher(voucher);
      } else {
        context.read<AccountingCubit>().createVoucher(voucher);
      }
    }
  }

  void _addNote(String text) {
    final currentText = _noteController.text;
    if (currentText.isEmpty) {
      _noteController.text = text;
    } else {
      _noteController.text = '$currentText - $text';
    }
    _noteController.selection = TextSelection.fromPosition(
      TextPosition(offset: _noteController.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isReceipt = _selectedType == VoucherType.receipt;
    final themeColor = isReceipt ? Colors.green.shade700 : Colors.red.shade700;
    final isEditing = widget.voucherToEdit != null;
    final title = isEditing
        ? 'تعديل السند (${widget.voucherToEdit!.voucherNumber})'
        : (isReceipt ? 'إنشاء سند قبض' : 'إنشاء سند صرف');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.white,
              ),
              onPressed: () => _confirmDelete(context),
            ),
        ],
      ),
      body: Stack(
        children: [
          // 1. Curved Background
          Container(
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [themeColor, themeColor.withOpacity(0.8)],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          // 2. Floating Form
          SafeArea(
            child: BlocListener<AccountingCubit, AccountingState>(
              listener: (context, state) {
                state.whenOrNull(
                  success: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isEditing ? 'تم الحفظ بنجاح' : 'تم إنشاء السند بنجاح',
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    context.pop(true);
                  },
                  error: (msg) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(msg), backgroundColor: Colors.red),
                    );
                  },
                  invoiceLookupSuccess: (remaining, invoiceNum) {
                    _amountController.text = remaining.toStringAsFixed(2);
                    if (_noteController.text.isEmpty) {
                      _noteController.text =
                          'سداد متبقي الفاتورة رقم $invoiceNum';
                    }
                  },
                );
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // Form Container
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Client Header
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: themeColor.withOpacity(0.1),
                                  child: Icon(Icons.person, color: themeColor),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.clientSupplier.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        widget.clientSupplier.type ==
                                                ClientType.client
                                            ? 'الطرف: عميل'
                                            : 'الطرف: مورد',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 32),

                            // Voucher Type Selector (Disabled if editing)
                            if (!isEditing) ...[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _buildTypeOption(
                                        'سند قبض',
                                        VoucherType.receipt,
                                        Icons.download_rounded,
                                        Colors.green,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildTypeOption(
                                        'سند صرف',
                                        VoucherType.payment,
                                        Icons.upload_rounded,
                                        Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Invoice Link
                            _buildSectionLabel('ربط بفاتورة (اختياري)'),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _linkedInvoiceController,
                              decoration: InputDecoration(
                                hintText: 'رقم الفاتورة...',
                                prefixIcon: const Icon(Icons.link),
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.search,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<AccountingCubit>()
                                        .lookupInvoice(
                                          _linkedInvoiceController.text,
                                          _selectedType,
                                        );
                                  },
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Amount Field (Highlighted)
                            _buildSectionLabel('المبلغ'),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _amountController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: themeColor,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.attach_money,
                                  color: themeColor,
                                ),
                                filled: true,
                                fillColor: themeColor.withOpacity(0.05),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: themeColor.withOpacity(0.3),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: themeColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'المبلغ مطلوب';
                                if (double.tryParse(value) == null ||
                                    double.parse(value) <= 0)
                                  return 'قيمة غير صحيحة';
                                return null;
                              },
                            ),

                            const SizedBox(height: 24),

                            // Notes
                            _buildSectionLabel('البيان / الملاحظات'),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: _quickNotes
                                  .map(
                                    (note) => ActionChip(
                                      label: Text(note),
                                      backgroundColor: Colors.white,
                                      side: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                      onPressed: () => _addNote(note),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _noteController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'اكتب تفاصيل العملية...',
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Submit Button
                            BlocBuilder<AccountingCubit, AccountingState>(
                              builder: (context, state) {
                                final isLoading = state.maybeWhen(
                                  loading: () => true,
                                  orElse: () => false,
                                );
                                return SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: themeColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 4,
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            isEditing
                                                ? 'حفظ التعديلات'
                                                : 'إتمام العملية',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade700,
      ),
    );
  }

  Widget _buildTypeOption(
    String title,
    VoucherType type,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تأكيد الحذف'),
        content: const Text(
          'هل أنت متأكد من حذف هذا السند؟ لا يمكن التراجع عن هذه العملية.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AccountingCubit>().deleteVoucher(
                widget.voucherToEdit!.id,
              );
            },
            child: const Text(
              'حذف',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
