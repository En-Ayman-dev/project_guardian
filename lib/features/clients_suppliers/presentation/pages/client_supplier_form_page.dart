import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/client_supplier_entity.dart';
import '../../domain/entities/enums/client_type.dart';
import '../manager/client_supplier_cubit.dart';
import '../manager/client_supplier_state.dart';

class ClientSupplierFormPage extends StatelessWidget {
  final ClientType type;
  final ClientSupplierEntity? clientToEdit;

  const ClientSupplierFormPage({
    super.key,
    required this.type,
    this.clientToEdit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ClientSupplierCubit>(),
      child: _FormView(type: type, clientToEdit: clientToEdit),
    );
  }
}

class _FormView extends StatefulWidget {
  final ClientType type;
  final ClientSupplierEntity? clientToEdit;

  const _FormView({required this.type, this.clientToEdit});

  @override
  State<_FormView> createState() => _FormViewState();
}

class _FormViewState extends State<_FormView> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _taxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.clientToEdit != null) {
      final client = widget.clientToEdit!;
      _nameController.text = client.name;
      _phoneController.text = client.phone;
      _emailController.text = client.email ?? '';
      _addressController.text = client.address ?? '';
      _taxController.text = client.taxNumber ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final isEdit = widget.clientToEdit != null;

      final entity = ClientSupplierEntity(
        id: isEdit ? widget.clientToEdit!.id : const Uuid().v4(),
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        address: _addressController.text,
        taxNumber: _taxController.text,
        type: widget.type,
        createdAt: isEdit ? widget.clientToEdit!.createdAt : DateTime.now(),
        // نحافظ على الرصيد كما هو عند التعديل، أو 0 عند الإنشاء
        balance: isEdit ? widget.clientToEdit!.balance : 0.0,
      );

      context.read<ClientSupplierCubit>().addEntry(entity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.clientToEdit != null;
    final typeName = widget.type == ClientType.client ? 'عميل' : 'مورد';
    final title = isEdit ? 'تعديل بيانات $typeName' : 'إضافة $typeName جديد';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: BlocListener<ClientSupplierCubit, ClientSupplierState>(
        listener: (context, state) {
          state.whenOrNull(
            actionSuccess: () {
              final msg = isEdit ? 'تم التعديل بنجاح' : 'تم الحفظ بنجاح';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg), backgroundColor: Colors.green),
              );
              context.pop(true);
            },
            error: (msg) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg), backgroundColor: Colors.red),
              );
            },
          );
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // 1. الاسم (تم التأكد من عدم وجود inputFormatters مقيدة)
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'الاسم *',
                    prefixIcon: Icon(Icons.person),
                    hintText: 'أدخل الاسم (عربي أو إنجليزي)',
                  ),
                  keyboardType: TextInputType.text, // يسمح بكل النصوص
                  validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),
                
                // 2. الهاتف
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف *', 
                    prefixIcon: Icon(Icons.phone)
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),

                // 3. البريد
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني', 
                    prefixIcon: Icon(Icons.email)
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // 4. العنوان
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'العنوان', 
                    prefixIcon: Icon(Icons.location_on)
                  ),
                  keyboardType: TextInputType.streetAddress, // تحسين للكيبورد
                ),
                const SizedBox(height: 16),

                // 5. الرقم الضريبي
                TextFormField(
                  controller: _taxController,
                  decoration: const InputDecoration(
                    labelText: 'الرقم الضريبي', 
                    prefixIcon: Icon(Icons.confirmation_number)
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 24),

                // زر الحفظ
                BlocBuilder<ClientSupplierCubit, ClientSupplierState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state.maybeWhen(
                          loading: () => null,
                          orElse: () => _submit,
                        ),
                        child: state.maybeWhen(
                          loading: () => const CircularProgressIndicator(color: Colors.white),
                          orElse: () => Text(isEdit ? 'حفظ التعديلات' : 'حفظ'),
                        ),
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
}