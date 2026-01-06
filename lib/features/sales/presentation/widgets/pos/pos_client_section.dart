import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // نحتاج Bloc لاستدعاء البحث
import 'package:intl/intl.dart';
import '../../../../clients_suppliers/domain/entities/client_supplier_entity.dart';
// [FIXED] تصحيح المسار بإضافة ../ للوصول إلى مجلد domain
import '../../../domain/entities/invoice_entity.dart';
import '../../manager/sales_cubit.dart'; // لاستدعاء searchForInvoice
import 'pos_utils.dart';

class PosClientSection extends StatefulWidget {
  final InvoiceType invoiceType;
  final List<ClientSupplierEntity> clients;
  final ClientSupplierEntity? selectedClient;
  final String? invoiceNumber;
  final DateTime invoiceDate;
  final Function(ClientSupplierEntity) onClientSelected;
  
  // نستقبل الكنترولر من الصفحة الأم للتحكم بالنص (تعبئة تلقائية)
  final TextEditingController? searchController; 

  const PosClientSection({
    super.key,
    required this.invoiceType,
    required this.clients,
    required this.selectedClient,
    this.invoiceNumber,
    required this.invoiceDate,
    required this.onClientSelected,
    this.searchController, 
  });

  @override
  State<PosClientSection> createState() => _PosClientSectionState();
}

class _PosClientSectionState extends State<PosClientSection> {
  // استخدام الكنترولر الممرر أو إنشاء واحد جديد
  late TextEditingController _invoiceSearchCtrl;

  @override
  void initState() {
    super.initState();
    _invoiceSearchCtrl = widget.searchController ?? TextEditingController();
  }

  @override
  void dispose() {
    // إذا تم تمرير الكنترولر من الخارج، لا نقوم بحذفه هنا (المسؤولية على الصفحة الأم)
    if (widget.searchController == null) {
      _invoiceSearchCtrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = PosUtils.getThemeColor(widget.invoiceType);
    final isReturn = widget.invoiceType == InvoiceType.salesReturn || 
                     widget.invoiceType == InvoiceType.purchaseReturn;

    return Container(
      padding: const EdgeInsets.all(12),
      // [FIXED] استبدال withOpacity بـ withValues لتجنب التحذير
      color: color.withValues(alpha: 0.05),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: isReturn 
                ? _buildReturnSearchField(context) 
                : _buildClientSearchField(),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Date: ${DateFormat('yyyy-MM-dd').format(widget.invoiceDate)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Ref: #${widget.invoiceNumber ?? "AUTO"}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReturnSearchField(BuildContext context) {
    // في حالة التعديل، قد يكون لدينا عميل بالفعل، لكننا نريد السماح برؤية رقم الفاتورة الأصلية
    // لذا سنعرض حقل البحث دائماً، ولكن إذا تم تحديد العميل، نجعله للقراءة فقط أو نعرض العميل بجانبه
    
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _invoiceSearchCtrl,
            keyboardType: TextInputType.text, // قد يحتوي على حروف
            // إذا كان العميل محدداً، فهذا يعني أننا وجدنا الفاتورة، نغلق الحقل لمنع التغيير العشوائي
            enabled: widget.selectedClient == null, 
            decoration: InputDecoration(
              labelText: 'رقم الفاتورة الأصلية',
              hintText: 'بحث...',
              prefixIcon: const Icon(Icons.receipt_long),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: widget.selectedClient != null ? Colors.grey.shade200 : Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onSubmitted: (val) => _performSearch(context),
          ),
        ),
        const SizedBox(width: 8),
        if (widget.selectedClient == null)
          IconButton.filled(
            onPressed: () => _performSearch(context),
            icon: const Icon(Icons.search),
            tooltip: 'بحث',
            style: IconButton.styleFrom(
              backgroundColor: PosUtils.getThemeColor(widget.invoiceType),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          )
        else
          // أيقونة قفل للدلالة على الارتباط
          IconButton(
             onPressed: () {
               // هنا يمكن إضافة منطق لإلغاء المرتجع والبدء من جديد مستقبلاً
             },
             icon: const Icon(Icons.lock, color: Colors.grey),
             tooltip: 'مرتبط بالفاتورة الأصلية',
          ),
      ],
    );
  }

  void _performSearch(BuildContext context) {
    final invoiceNum = _invoiceSearchCtrl.text.trim();
    if (invoiceNum.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الرجاء إدخال رقم الفاتورة")),
      );
      return;
    }
    context.read<SalesCubit>().searchForInvoice(invoiceNum);
  }

  Widget _buildClientSearchField() {
    return Autocomplete<ClientSupplierEntity>(
      initialValue: widget.selectedClient != null
          ? TextEditingValue(text: widget.selectedClient!.name)
          : null,
      optionsBuilder: (textEditingValue) {
        if (textEditingValue.text.isEmpty) return widget.clients;
        return widget.clients.where(
          (client) => client.name.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          ),
        );
      },
      displayStringForOption: (option) => option.name,
      onSelected: widget.onClientSelected,
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          decoration: InputDecoration(
            labelText: (widget.invoiceType == InvoiceType.sales) ? 'العميل' : 'المورد',
            prefixIcon: const Icon(Icons.person_search),
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
        );
      },
    );
  }
}