import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/client_supplier_entity.dart';
import '../../domain/entities/enums/client_type.dart';

class ClientSupplierDetailsPage extends StatelessWidget {
  final ClientSupplierEntity entity;

  const ClientSupplierDetailsPage({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    final isClient = entity.type == ClientType.client;
    final typeLabel = isClient ? 'عميل' : 'مورد';
    final primaryColor = isClient ? Colors.blue : Colors.orange;

    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل $typeLabel'),
        actions: [
          // زر إضافة سند (قبض/صرف)
          IconButton(
            onPressed: () async {
              // الانتقال لصفحة السند، وانتظار النتيجة (قد نحتاج لتحديث الصفحة لاحقاً)
              await context.push('/clients-suppliers/voucher', extra: entity);
            },
            icon: const Icon(Icons.receipt_long),
            tooltip: isClient ? 'سند قبض' : 'سند صرف',
          ),
          // زر التعديل
          IconButton(
            onPressed: () {
              context.push('/clients-suppliers/add', extra: entity);
            },
            icon: const Icon(Icons.edit),
            tooltip: 'تعديل البيانات',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Header Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: primaryColor.withValues(alpha: 0.1),
                      child: Icon(
                        isClient ? Icons.person : Icons.local_shipping,
                        size: 40,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      entity.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        typeLabel,
                        style: TextStyle(
                          color: primaryColor.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. بطاقة الرصيد المالي (Financial Balance)
            _buildBalanceCard(context, isClient, entity.balance),
            
            // زر سريع لإضافة السند تحت الرصيد مباشرة
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: FilledButton.icon(
                onPressed: () async {
                  await context.push('/clients-suppliers/voucher', extra: entity);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: isClient ? Colors.green.shade600 : Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: Icon(isClient ? Icons.add_circle_outline : Icons.remove_circle_outline),
                label: Text(
                  isClient ? 'إضافة سند قبض (استلام)' : 'إضافة سند صرف (دفع)',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // 3. Info List
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildDetailTile(
                    context,
                    icon: Icons.phone,
                    title: 'رقم الهاتف',
                    value: entity.phone.isNotEmpty ? entity.phone : 'غير متوفر',
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildDetailTile(
                    context,
                    icon: Icons.email,
                    title: 'البريد الإلكتروني',
                    value: (entity.email?.isNotEmpty ?? false) ? entity.email! : 'غير متوفر',
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildDetailTile(
                    context,
                    icon: Icons.location_on,
                    title: 'العنوان',
                    value: (entity.address?.isNotEmpty ?? false) ? entity.address! : 'غير متوفر',
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildDetailTile(
                    context,
                    icon: Icons.confirmation_number,
                    title: 'الرقم الضريبي',
                    value: (entity.taxNumber?.isNotEmpty ?? false) ? entity.taxNumber! : 'غير متوفر',
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildDetailTile(
                    context,
                    icon: Icons.calendar_today,
                    title: 'تاريخ الإضافة',
                    value: entity.createdAt.toLocal().toString().split(' ')[0],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ودجت عرض الرصيد
  Widget _buildBalanceCard(BuildContext context, bool isClient, double balance) {
    // تحديد النص واللون بناءً على نوع العميل
    final String title = isClient 
        ? 'المديونية (لنا)' 
        : 'المستحقات (للمورد)';
        
    final String subtitle = isClient
        ? 'المبلغ الذي يدين به العميل للنظام'
        : 'المبلغ الذي يدين به النظام للمورد';

    // العميل: إذا كان الرصيد موجب فهذا جيد (مديون لنا). 
    // المورد: إذا كان الرصيد موجب فهذا دين علينا.
    final Color color = isClient ? Colors.green.shade700 : Colors.red.shade700;
    final Color bgColor = isClient ? Colors.green.shade50 : Colors.red.shade50;

    return Card(
      color: bgColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.account_balance_wallet,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: color.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              balance.toStringAsFixed(2),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade600),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}