import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../clients_suppliers/domain/entities/client_supplier_entity.dart';
import '../../../domain/entities/invoice_entity.dart';
import '../../manager/sales_cubit.dart';
import 'pos_utils.dart';

class PosClientSection extends StatefulWidget {
  final InvoiceType invoiceType;
  final List<ClientSupplierEntity> clients;
  final ClientSupplierEntity? selectedClient;
  final String? invoiceNumber;
  final DateTime invoiceDate;
  final Function(ClientSupplierEntity) onClientSelected;
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
  late TextEditingController _invoiceSearchCtrl;

  @override
  void initState() {
    super.initState();
    _invoiceSearchCtrl = widget.searchController ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.searchController == null) {
      _invoiceSearchCtrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = PosUtils.getThemeColor(widget.invoiceType);
    final isReturn = widget.invoiceType == InvoiceType.salesReturn ||
                     widget.invoiceType == InvoiceType.purchaseReturn;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          // الصف العلوي: التاريخ ورقم المرجع
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoChip(
                icon: Icons.receipt_long_rounded,
                label: '#${widget.invoiceNumber ?? "AUTO"}',
                color: Colors.grey.shade700,
              ),
              _buildInfoChip(
                icon: Icons.calendar_today_rounded,
                label: DateFormat('yyyy-MM-dd').format(widget.invoiceDate),
                color: themeColor,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // حقل البحث الرئيسي
          Row(
            children: [
              Expanded(
                child: isReturn
                    ? _buildReturnSearchField(context, themeColor)
                    : _buildClientSearchField(themeColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReturnSearchField(BuildContext context, Color color) {
    final hasClient = widget.selectedClient != null;

    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: hasClient ? Colors.grey.shade50 : Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: hasClient ? [] : [
                BoxShadow(
                  color: color.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _invoiceSearchCtrl,
              enabled: !hasClient,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: 'أدخل رقم الفاتورة الأصلية...',
                prefixIcon: Icon(Icons.youtube_searched_for, color: color),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                filled: true,
                fillColor: Colors.transparent,
              ),
              onSubmitted: (_) => _performSearch(context),
            ),
          ),
        ),
        const SizedBox(width: 12),
        if (!hasClient)
          InkWell(
            onTap: () => _performSearch(context),
            borderRadius: BorderRadius.circular(15),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.search_rounded, color: Colors.white),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.lock_outline_rounded, color: Colors.grey),
          ),
      ],
    );
  }

  void _performSearch(BuildContext context) {
    final invoiceNum = _invoiceSearchCtrl.text.trim();
    if (invoiceNum.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("الرجاء إدخال رقم الفاتورة"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    context.read<SalesCubit>().searchForInvoice(invoiceNum);
  }

  Widget _buildClientSearchField(Color color) {
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
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onEditingComplete: onEditingComplete,
            decoration: InputDecoration(
              hintText: (widget.invoiceType == InvoiceType.sales) 
                  ? 'بحث عن عميل...' 
                  : 'بحث عن مورد...',
              prefixIcon: Icon(Icons.person_search_rounded, color: color),
              suffixIcon: const Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        );
      },
      // تحسين قائمة الخيارات المقترحة
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            child: Container(
              width: MediaQuery.of(context).size.width - 64, // عرض مناسب
              constraints: const BoxConstraints(maxHeight: 250),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (BuildContext context, int index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withValues(alpha: 0.1),
                      child: Text(
                        option.name[0].toUpperCase(),
                        style: TextStyle(color: color, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(option.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(option.phone, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}