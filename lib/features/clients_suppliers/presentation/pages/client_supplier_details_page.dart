// [phase_2] modification
// file: lib/features/clients_suppliers/presentation/pages/client_supplier_details_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // لتنسيق التاريخ
import '../../domain/entities/client_supplier_entity.dart';
import '../../domain/entities/enums/client_type.dart';

class ClientSupplierDetailsPage extends StatelessWidget {
  final ClientSupplierEntity entity;

  const ClientSupplierDetailsPage({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    final isClient = entity.type == ClientType.client;
    // تحديد الألوان بناءً على النوع (أزرق للعملاء، برتقالي للموردين)
    final themeColor = isClient
        ? const Color(0xFF1A73E8)
        : const Color(0xFFE65100);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          isClient ? 'ملف العميل' : 'ملف المورد',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/clients-suppliers/add', extra: entity);
            },
            icon: const Icon(Icons.edit_rounded, color: Colors.white),
            tooltip: 'تعديل البيانات',
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. الخلفية الملونة (Curved Header)
          Container(
            height: 240,
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

          // 2. المحتوى الرئيسي
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // --- الكرت الرئيسي العائم (معلومات الشخص) ---
                  _buildProfileCard(context, themeColor),

                  const SizedBox(height: 20),

                  // --- كرت الرصيد المالي ---
                  _buildFinancialCard(context, isClient),

                  const SizedBox(height: 24),

                  // --- قائمة المعلومات التفصيلية ---
                  _buildInfoSection(context, themeColor),

                  const SizedBox(height: 100), // مساحة للزر العائم
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/clients-suppliers/voucher', extra: entity);
        },
        backgroundColor: themeColor,
        icon: const Icon(Icons.receipt_long_rounded, color: Colors.white),
        label: Text(
          isClient ? 'سند قبض جديد' : 'سند صرف جديد',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 4,
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, Color themeColor) {
    return Container(
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: themeColor.withOpacity(0.2), width: 3),
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: themeColor.withOpacity(0.1),
              child: Text(
                entity.name.isNotEmpty ? entity.name[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: themeColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            entity.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              entity.type == ClientType.client ? 'عميل' : 'مورد',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialCard(BuildContext context, bool isClient) {
    // منطق الألوان والنصوص:
    // العميل: رصيد موجب (لنا) = أخضر، رصيد سالب (له) = أحمر.
    // المورد: رصيد موجب (له) = أحمر (دين علينا)، رصيد سالب (لنا) = أخضر.

    // لتبسيط العرض: سنعرض الرقم كما هو، ونلون بناءً على القيمة والدلالة.
    // سنفترض هنا: الرقم الموجب دائمًا يعني "مديونية" على الطرف الآخر تجاه النظام (Asset)،
    // والرقم السالب يعني "دائنية" للطرف الآخر على النظام (Liability).
    // *ملاحظة:* هذا يعتمد على كيفية تخزين الرصيد في الباك إند. سأفترض هنا أن الموجب = لنا، السالب = علينا.

    final balance = entity.balance;
    final isPositive = balance >= 0;

    // اللون: أخضر إذا كان المال لنا (موجب)، أحمر إذا كان علينا (سالب)
    final statusColor = isPositive
        ? Colors.green.shade700
        : Colors.red.shade700;
    final bgColor = isPositive ? Colors.green.shade50 : Colors.red.shade50;
    final icon = isPositive
        ? Icons.trending_up_rounded
        : Icons.trending_down_rounded;

    String statusText;
    if (balance == 0) {
      statusText = "الرصيد متزن";
    } else if (isPositive) {
      statusText = "رصيد لنا (مدين)";
    } else {
      statusText = "رصيد علينا (دائن)";
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                statusText,
                style: TextStyle(
                  color: statusColor.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    balance.abs().toStringAsFixed(2),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "\$", // أو العملة المحلية
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: statusColor.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: statusColor, size: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, Color themeColor) {
    return Column(
      children: [
        _buildInfoTile(
          icon: Icons.phone_rounded,
          title: "رقم الهاتف",
          value: entity.phone.isNotEmpty ? entity.phone : "غير متوفر",
          themeColor: themeColor,
        ),
        const SizedBox(height: 12),
        _buildInfoTile(
          icon: Icons.email_rounded,
          title: "البريد الإلكتروني",
          value: (entity.email?.isNotEmpty ?? false)
              ? entity.email!
              : "غير متوفر",
          themeColor: themeColor,
        ),
        const SizedBox(height: 12),
        _buildInfoTile(
          icon: Icons.location_on_rounded,
          title: "العنوان",
          value: (entity.address?.isNotEmpty ?? false)
              ? entity.address!
              : "غير متوفر",
          themeColor: themeColor,
        ),
        const SizedBox(height: 12),
        _buildInfoTile(
          icon: Icons.verified_user_rounded,
          title: "الرقم الضريبي",
          value: (entity.taxNumber?.isNotEmpty ?? false)
              ? entity.taxNumber!
              : "غير متوفر",
          themeColor: themeColor,
        ),
        const SizedBox(height: 12),
        _buildInfoTile(
          icon: Icons.calendar_month_rounded,
          title: "تاريخ الانضمام",
          value: DateFormat('yyyy-MM-dd').format(entity.createdAt),
          themeColor: themeColor,
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    required Color themeColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: themeColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
