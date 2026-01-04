import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../clients_suppliers/domain/entities/client_supplier_entity.dart';
import '../../../domain/entities/invoice_entity.dart';
import 'pos_utils.dart';

class PosClientSection extends StatelessWidget {
  final InvoiceType invoiceType;
  final List<ClientSupplierEntity> clients;
  final ClientSupplierEntity? selectedClient;
  final String? invoiceNumber;
  final DateTime invoiceDate;
  final Function(ClientSupplierEntity) onClientSelected;

  const PosClientSection({
    super.key,
    required this.invoiceType,
    required this.clients,
    required this.selectedClient,
    this.invoiceNumber,
    required this.invoiceDate,
    required this.onClientSelected,
  });

  @override
  Widget build(BuildContext context) {
    final color = PosUtils.getThemeColor(invoiceType);

    return Container(
      padding: const EdgeInsets.all(12),
      color: color.withValues(alpha: 0.05),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Autocomplete<ClientSupplierEntity>(
              initialValue: selectedClient != null
                  ? TextEditingValue(text: selectedClient!.name)
                  : null,
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text.isEmpty) return clients;
                return clients.where(
                  (client) => client.name.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  ),
                );
              },
              displayStringForOption: (option) => option.name,
              onSelected: onClientSelected,
              fieldViewBuilder:
                  (context, controller, focusNode, onEditingComplete) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onEditingComplete: onEditingComplete,
                  decoration: InputDecoration(
                    labelText:
                        (invoiceType == InvoiceType.sales ||
                                invoiceType == InvoiceType.salesReturn)
                            ? 'العميل'
                            : 'المورد',
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
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Date: ${DateFormat('yyyy-MM-dd').format(invoiceDate)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Ref: #${invoiceNumber ?? "AUTO"}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}