import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/unit_entity.dart';
import '../manager/inventory_settings_cubit.dart';
import '../manager/inventory_settings_state.dart';

class InventorySettingsPage extends StatelessWidget {
  const InventorySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<InventorySettingsCubit>()
        ..loadCategories()
        ..loadUnits(),
      child: const _InventorySettingsView(),
    );
  }
}

class _InventorySettingsView extends StatelessWidget {
  const _InventorySettingsView();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inventory Settings'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Categories', icon: Icon(Icons.category)),
              Tab(text: 'Units', icon: Icon(Icons.straighten)),
            ],
          ),
        ),
        floatingActionButton: Builder(
          builder: (ctx) => FloatingActionButton(
            onPressed: () => _showAddDialog(ctx),
            child: const Icon(Icons.add),
          ),
        ),
        body: BlocConsumer<InventorySettingsCubit, InventorySettingsState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
              );
              context.read<InventorySettingsCubit>().resetActionState();
            }
            if (state.isActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Operation Successful'), backgroundColor: Colors.green),
              );
              context.read<InventorySettingsCubit>().resetActionState();
            }
          },
          builder: (context, state) {
            if (state.isLoading && state.categories.isEmpty && state.units.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return TabBarView(
              children: [
                _buildList(
                  context, 
                  state.categories, 
                  (id) => context.read<InventorySettingsCubit>().deleteCategory(id)
                ),
                _buildList(
                  context, 
                  state.units, 
                  (id) => context.read<InventorySettingsCubit>().deleteUnit(id)
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<dynamic> items, Function(String) onDelete) {
    if (items.isEmpty) {
      return const Center(child: Text('No items found.'));
    }
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // زر التعديل الجديد
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showAddDialog(context, itemToEdit: item),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => onDelete(item.id),
              ),
            ],
          ),
        );
      },
    );
  }

void _showAddDialog(BuildContext context, {dynamic itemToEdit}) {
    final tabIndex = DefaultTabController.of(context).index;
    final isCategory = tabIndex == 0;
    
    // تحديد العنوان والنص المبدئي
    final isEditing = itemToEdit != null;
    final title = isEditing 
        ? (isCategory ? 'Edit Category' : 'Edit Unit') 
        : (isCategory ? 'New Category' : 'New Unit');
        
    final controller = TextEditingController(text: isEditing ? itemToEdit.name : '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                if (isCategory) {
                  if (isEditing) {
                    // منطق التعديل للقسم (نحافظ على ID القديم ونحدث الاسم)
                    final updated = CategoryEntity(id: itemToEdit.id, name: controller.text);
                    context.read<InventorySettingsCubit>().updateCategory(updated);
                  } else {
                    // منطق الإضافة
                    context.read<InventorySettingsCubit>().addCategory(controller.text);
                  }
                } else {
                  if (isEditing) {
                    // منطق التعديل للوحدة
                    final updated = UnitEntity(id: itemToEdit.id, name: controller.text);
                    context.read<InventorySettingsCubit>().updateUnit(updated);
                  } else {
                    // منطق الإضافة
                    context.read<InventorySettingsCubit>().addUnit(controller.text);
                  }
                }
                Navigator.pop(context);
              }
            },
            child: Text(isEditing ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }
}