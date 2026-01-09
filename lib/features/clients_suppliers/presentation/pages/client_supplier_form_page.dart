// [phase_2] modification
// file: lib/features/clients_suppliers/presentation/pages/client_supplier_form_page.dart

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

  late Color themeColor;
  late String typeLabel;

  @override
  void initState() {
    super.initState();
    // إعداد البيانات الأولية
    themeColor = widget.type == ClientType.client
        ? const Color(0xFF1A73E8) // أزرق للعميل
        : const Color(0xFFE65100); // برتقالي للمورد

    typeLabel = widget.type == ClientType.client ? 'عميل' : 'مورد';

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
    final title = isEdit ? 'تعديل بيانات $typeLabel' : 'إضافة $typeLabel جديد';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: Stack(
        children: [
          // 1. Curved Header Background
          Container(
            height: 200,
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

          // 2. Floating Form Card
          SafeArea(
            child: BlocListener<ClientSupplierCubit, ClientSupplierState>(
              listener: (context, state) {
                state.whenOrNull(
                  actionSuccess: () {
                    final msg = isEdit
                        ? 'تم تحديث البيانات بنجاح'
                        : 'تمت الإضافة بنجاح';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(msg),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // حاوية النموذج
                    Container(
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // أيقونة توضيحية في الأعلى
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: themeColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isEdit
                                      ? Icons.edit_note_rounded
                                      : Icons.person_add_rounded,
                                  size: 40,
                                  color: themeColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            _buildSectionTitle('المعلومات الأساسية'),
                            const SizedBox(height: 16),

                            _buildTextField(
                              controller: _nameController,
                              label: 'الاسم الكامل',
                              icon: Icons.person_outline_rounded,
                              isRequired: true,
                            ),
                            const SizedBox(height: 16),

                            _buildTextField(
                              controller: _phoneController,
                              label: 'رقم الهاتف',
                              icon: Icons.phone_android_rounded,
                              isRequired: true,
                              inputType: TextInputType.phone,
                            ),

                            const SizedBox(height: 24),
                            _buildSectionTitle('معلومات التواصل والضرائب'),
                            const SizedBox(height: 16),

                            _buildTextField(
                              controller: _emailController,
                              label: 'البريد الإلكتروني (اختياري)',
                              icon: Icons.email_outlined,
                              inputType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),

                            _buildTextField(
                              controller: _addressController,
                              label: 'العنوان (اختياري)',
                              icon: Icons.location_on_outlined,
                            ),
                            const SizedBox(height: 16),

                            _buildTextField(
                              controller: _taxController,
                              label: 'الرقم الضريبي (اختياري)',
                              icon: Icons.confirmation_number_outlined,
                            ),

                            const SizedBox(height: 32),

                            // زر الحفظ
                            BlocBuilder<
                              ClientSupplierCubit,
                              ClientSupplierState
                            >(
                              builder: (context, state) {
                                final isLoading = state.maybeWhen(
                                  loading: () => true,
                                  orElse: () => false,
                                );
                                return SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: themeColor,
                                      foregroundColor: Colors.white,
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      disabledBackgroundColor: themeColor
                                          .withOpacity(0.6),
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.save_rounded),
                                              const SizedBox(width: 8),
                                              Text(
                                                isEdit
                                                    ? 'حفظ التغييرات'
                                                    : 'إضافة $typeLabel',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(width: 4, height: 18, color: themeColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isRequired = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: isRequired
          ? (v) => v?.trim().isEmpty == true ? 'هذا الحقل مطلوب' : null
          : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(icon, color: themeColor.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: themeColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }
}
