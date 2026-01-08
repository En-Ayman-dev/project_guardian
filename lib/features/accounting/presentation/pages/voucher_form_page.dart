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
  final VoucherEntity? voucherToEdit; // [NEW] للمعالجة في حالة التعديل

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

  const _VoucherView({
    required this.clientSupplier,
    this.voucherToEdit,
  });

  @override
  State<_VoucherView> createState() => _VoucherViewState();
}

class _VoucherViewState extends State<_VoucherView> {
  final _formKey = GlobalKey<FormState>();

  late VoucherType _selectedType;
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  late TextEditingController _linkedInvoiceController;

  // نصوص مقترحة للملاحظات (Smart Chips)
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

    // تهيئة القيم: إما من السند المراد تعديله أو قيم افتراضية
    if (editVoucher != null) {
      _selectedType = editVoucher.type;
      _amountController = TextEditingController(text: editVoucher.amount.toString());
      _noteController = TextEditingController(text: editVoucher.note);
      _linkedInvoiceController = TextEditingController(text: editVoucher.linkedInvoiceId ?? '');
    } else {
      // الافتراضي: سند قبض للعميل، سند صرف للمورد
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
        id: isEditing ? widget.voucherToEdit!.id : const Uuid().v4(), // الحفاظ على الـ ID عند التعديل
        voucherNumber: isEditing 
            ? widget.voucherToEdit!.voucherNumber 
            : '#VO-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        type: _selectedType,
        amount: amount,
        date: isEditing ? widget.voucherToEdit!.date : DateTime.now(), // الحفاظ على التاريخ القديم أو جديد
        clientSupplierId: widget.clientSupplier.id,
        clientSupplierName: widget.clientSupplier.name,
        linkedInvoiceId: _linkedInvoiceController.text.isEmpty ? null : _linkedInvoiceController.text,
        note: _noteController.text,
      );

      if (isEditing) {
        context.read<AccountingCubit>().updateVoucher(voucher);
      } else {
        context.read<AccountingCubit>().createVoucher(voucher);
      }
    }
  }

  // دالة مساعدة لإضافة نص للملاحظات بذكاء
  void _addNote(String text) {
    final currentText = _noteController.text;
    if (currentText.isEmpty) {
      _noteController.text = text;
    } else {
      _noteController.text = '$currentText - $text';
    }
    // تحريك المؤشر للنهاية
    _noteController.selection = TextSelection.fromPosition(
      TextPosition(offset: _noteController.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isReceipt = _selectedType == VoucherType.receipt;
    final color = isReceipt ? Colors.green : Colors.red;
    final isEditing = widget.voucherToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing 
            ? 'تعديل السند (${widget.voucherToEdit!.voucherNumber})' 
            : (isReceipt ? 'سند قبض جديد' : 'سند صرف جديد')),
        backgroundColor: color,
        foregroundColor: Colors.white,
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'حذف السند',
              onPressed: () => _confirmDelete(context),
            ),
        ],
      ),
      body: BlocListener<AccountingCubit, AccountingState>(
        listener: (context, state) {
          state.whenOrNull(
            success: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isEditing ? 'تم تعديل السند بنجاح' : 'تم حفظ السند بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
              context.pop(true); // العودة مع نتيجة لتحديث القائمة
            },
            error: (msg) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg), backgroundColor: Colors.red),
              );
            },
            invoiceLookupSuccess: (remaining, invoiceNum) {
              _amountController.text = remaining.toStringAsFixed(2);
              // [UX] اقتراح نص تلقائي عند العثور على فاتورة
              if (_noteController.text.isEmpty) {
                 _noteController.text = 'سداد متبقي الفاتورة رقم $invoiceNum';
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم جلب المبلغ المتبقي: $remaining'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            invoiceLookupError: (msg) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg), backgroundColor: Colors.orange),
              );
            },
          );
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. بطاقة الطرف الثاني
                Card(
                  surfaceTintColor: Colors.white,
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.1),
                      child: Icon(Icons.person, color: color),
                    ),
                    title: Text(widget.clientSupplier.name),
                    subtitle: Text(
                      widget.clientSupplier.type == ClientType.client ? 'عميل' : 'مورد',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 2. نوع السند (تعطيله في التعديل لتجنب تعقيدات المحاسبة)
                IgnorePointer(
                  ignoring: isEditing, // لا يمكن تغيير النوع أثناء التعديل
                  child: Opacity(
                    opacity: isEditing ? 0.7 : 1.0,
                    child: SegmentedButton<VoucherType>(
                      segments: const [
                        ButtonSegment(
                          value: VoucherType.receipt,
                          label: Text('سند قبض'),
                          icon: Icon(Icons.download),
                        ),
                        ButtonSegment(
                          value: VoucherType.payment,
                          label: Text('سند صرف'),
                          icon: Icon(Icons.upload),
                        ),
                      ],
                      selected: {_selectedType},
                      onSelectionChanged: (Set<VoucherType> newSelection) {
                        setState(() {
                          _selectedType = newSelection.first;
                        });
                      },
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.selected)) return Colors.white;
                          return Colors.black;
                        }),
                        backgroundColor: MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.selected)) return color;
                          return null;
                        }),
                      ),
                    ),
                  ),
                ),
                if (isEditing)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      '* لا يمكن تغيير نوع السند أثناء التعديل لضمان سلامة القيود',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 24),

                // 3. رقم الفاتورة المرجعي
                BlocBuilder<AccountingCubit, AccountingState>(
                  builder: (context, state) {
                    final isLoading = state.maybeWhen(
                        invoiceLookupLoading: () => true, orElse: () => false);
                    
                    return TextFormField(
                      controller: _linkedInvoiceController,
                      decoration: InputDecoration(
                        labelText: 'رقم الفاتورة المرجعي (اختياري)',
                        prefixIcon: const Icon(Icons.receipt_long),
                        hintText: 'أدخل الرقم للبحث...',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  context.read<AccountingCubit>().lookupInvoice(
                                        _linkedInvoiceController.text,
                                        _selectedType,
                                      );
                                },
                          icon: isLoading
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.search, color: Colors.blue),
                        ),
                      ),
                      onFieldSubmitted: (value) {
                        context.read<AccountingCubit>().lookupInvoice(value, _selectedType);
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                // 4. المبلغ
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'المبلغ *',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'يرجى إدخال المبلغ';
                    if (double.tryParse(value) == null || double.parse(value) <= 0) return 'قيمة غير صحيحة';
                    return null;
                  },
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // 5. الملاحظات (مع النصوص الذكية)
                const Text('الملاحظات / البيان:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                // [UX] Smart Chips
                Wrap(
                  spacing: 8.0,
                  children: _quickNotes.map((note) {
                    return ActionChip(
                      label: Text(note),
                      onPressed: () => _addNote(note),
                      backgroundColor: Colors.grey[100],
                      labelStyle: TextStyle(color: Colors.grey[800], fontSize: 12),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    hintText: 'اكتب تفاصيل السند هنا...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                // زر الحفظ
                BlocBuilder<AccountingCubit, AccountingState>(
                  builder: (context, state) {
                    return FilledButton.icon(
                      onPressed: state.maybeWhen(
                        loading: () => null,
                        orElse: () => _submit,
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: color,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: state.maybeWhen(
                        loading: () => const SizedBox(
                          width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                        orElse: () => Icon(isEditing ? Icons.update : Icons.save),
                      ),
                      label: Text(
                        state.maybeWhen(
                          loading: () => ' جاري المعالجة...',
                          orElse: () => isEditing ? 'تعديل السند' : 'حفظ السند',
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // نافذة تأكيد الحذف
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف السند'),
        content: const Text(
          'هل أنت متأكد من حذف هذا السند؟\nسيتم عكس التأثير المالي على رصيد العميل/المورد.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // إغلاق الديالوج
              // تنفيذ الحذف
              context.read<AccountingCubit>().deleteVoucher(widget.voucherToEdit!.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('تأكيد الحذف'),
          ),
        ],
      ),
    );
  }
}