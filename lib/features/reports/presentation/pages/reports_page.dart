// [phase_3] update - Full File
// file: lib/features/reports/presentation/pages/reports_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'التقارير',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: const _ReportsView(),
    );
  }
}

class _ReportsView extends StatelessWidget {
  const _ReportsView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. كشف الحساب
        _ReportCard(
          title: 'كشف حساب عميل/مورد',
          subtitle: 'عرض وتصدير كشف حساب تفصيلي',
          icon: Icons.description_outlined,
          color: Colors.blue.shade700,
          onTap: () {
            // الانتقال لصفحة اختيار العميل أولاً (أو صفحة كشف الحساب مباشرة حسب تصميمك)
            // هنا نفترض أننا نذهب لصفحة اختيار العميل ثم هو يوجهنا للكشف
            // أو يمكن استخدام المسار المباشر إذا كنت تمرر العميل
            context.push('/clients-suppliers?selectionMode=true');
            // ملاحظة: تأكد من أن صفحة العملاء لديك تدعم وضع الاختيار (selectionMode)
            // أو وجهه للمسار الذي تفضله
          },
        ),

        const SizedBox(height: 12),

        // 2. تقرير الأرصدة العامة
        _ReportCard(
          title: 'الأرصدة العامة',
          subtitle: 'ملخص أرصدة جميع العملاء والموردين',
          icon: Icons.groups_rounded,
          color: Colors.teal.shade700,
          onTap: () => context.push('/reports/general-balances'),
        ),

        const SizedBox(height: 12),

        // 3. [NEW] تقرير المبيعات اليومي (الأصناف)
        _ReportCard(
          title: 'تقرير المبيعات اليومي',
          subtitle: 'حركة الأصناف اليومية (ديناميكي)',
          icon: Icons.calendar_view_day_rounded,
          color: Colors.indigo.shade700,
          // الرابط الذي أضفناه في الخطوة 1
          onTap: () => context.push('/reports/daily-sales'),
        ),

        // مساحة إضافية في الأسفل
        const SizedBox(height: 40),
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ReportCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
