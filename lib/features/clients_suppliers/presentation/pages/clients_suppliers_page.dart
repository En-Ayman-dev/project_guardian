// [phase_2] modification
// file: lib/features/clients_suppliers/presentation/pages/clients_suppliers_page.dart

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/client_supplier_entity.dart'; // تأكد من وجود هذا الاستيراد للكيان
import '../../domain/entities/enums/client_type.dart';
import '../manager/client_supplier_cubit.dart';
import '../manager/client_supplier_state.dart';
// import '../widgets/client_supplier_tile.dart'; // تم استبداله بتصميم داخلي حديث

class ClientsSuppliersPage extends StatelessWidget {
  const ClientsSuppliersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ClientSupplierCubit>()..getList(ClientType.client),
      child: const _ClientsSuppliersView(),
    );
  }
}

class _ClientsSuppliersView extends StatefulWidget {
  const _ClientsSuppliersView();

  @override
  State<_ClientsSuppliersView> createState() => _ClientsSuppliersViewState();
}

class _ClientsSuppliersViewState extends State<_ClientsSuppliersView> {
  // استبدلنا TabController بمتغير حالة بسيط للتحكم بالنوع
  ClientType _selectedType = ClientType.client;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _switchType(ClientType type) {
    if (_selectedType == type) return;
    setState(() {
      _selectedType = type;
      _searchController.clear();
    });
    context.read<ClientSupplierCubit>().getList(type);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      // تمديد التصميم خلف الـ AppBar
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'العملاء والموردين',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () {
              _searchController.clear();
              context.read<ClientSupplierCubit>().getList(_selectedType);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // ننتظر عودة المستخدم من صفحة الإضافة لتحديث القائمة
          final result = await context.push(
            '/clients-suppliers/add',
            extra: _selectedType,
          );
          if (result == true && mounted) {
            context.read<ClientSupplierCubit>().getList(_selectedType);
          }
        },
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          _selectedType == ClientType.client ? 'إضافة عميل' : 'إضافة مورد',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          // 1. Header Background
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),

                // --- Search Bar (Floating) ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'بحث بالاسم أو الهاتف...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(Icons.search, color: primaryColor),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                  });
                                  context.read<ClientSupplierCubit>().search(
                                    '',
                                  );
                                  FocusScope.of(context).unfocus();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {}); // لتحديث أيقونة المسح
                        context.read<ClientSupplierCubit>().search(value);
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // --- Tabs (Capsules) ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSegmentedTab(
                          context,
                          'العملاء',
                          ClientType.client,
                          Icons.people_alt_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSegmentedTab(
                          context,
                          'الموردين',
                          ClientType.supplier,
                          Icons.local_shipping_rounded,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // --- List Content ---
                Expanded(
                  child: BlocBuilder<ClientSupplierCubit, ClientSupplierState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (msg) => _buildErrorState(msg),
                        success: (list) {
                          if (list.isEmpty) {
                            return _buildEmptyState();
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.fromLTRB(
                              16,
                              0,
                              16,
                              80,
                            ), // bottom padding for FAB
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              final entity = list[index];
                              return _ModernClientSupplierTile(
                                entity: entity,
                                onTap: () async {
                                  await context.push(
                                    '/clients-suppliers/details',
                                    extra: entity,
                                  );
                                  if (mounted) {
                                    context.read<ClientSupplierCubit>().getList(
                                      _selectedType,
                                    );
                                  }
                                },
                              );
                            },
                          );
                        },
                        orElse: () => const SizedBox.shrink(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedTab(
    BuildContext context,
    String title,
    ClientType type,
    IconData icon,
  ) {
    final isSelected = _selectedType == type;
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () => _switchType(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? null : Border.all(color: Colors.grey.shade300),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open_rounded,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد بيانات لعرضها',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 60,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            msg,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                context.read<ClientSupplierCubit>().getList(_selectedType),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// مكون الكرت الحديث (بديل للمكون القديم)
// -----------------------------------------------------------------------------

class _ModernClientSupplierTile extends StatelessWidget {
  final ClientSupplierEntity entity;
  final VoidCallback onTap;

  const _ModernClientSupplierTile({required this.entity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isClient = entity.type == ClientType.client;
    final color = isClient ? Colors.blue.shade700 : Colors.teal.shade700;
    // تحديد لون الرصيد (أحمر إذا مدين، أخضر إذا دائن أو صفر)
    // افتراض: الرصيد الموجب يعني لنا (مدين)، السالب يعني علينا (دائن) - أو حسب منطق التطبيق
    final balanceColor = entity.balance >= 0 ? Colors.black87 : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 26,
                  backgroundColor: color.withOpacity(0.1),
                  child: Text(
                    entity.name.isNotEmpty ? entity.name[0].toUpperCase() : '?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entity.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_rounded,
                            size: 14,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            entity.phone.isNotEmpty
                                ? entity.phone
                                : 'لا يوجد هاتف',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Balance & Arrow
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'الرصيد',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${entity.balance.toStringAsFixed(2)} \$',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: balanceColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
