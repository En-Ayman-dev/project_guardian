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

  const ClientSupplierFormPage({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ClientSupplierCubit>(),
      child: _FormView(type: type),
    );
  }
}

class _FormView extends StatefulWidget {
  final ClientType type;
  const _FormView({required this.type});

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
      final entity = ClientSupplierEntity(
        id: const Uuid().v4(), // Generate ID locally if simpler, or let backend do it
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        address: _addressController.text,
        taxNumber: _taxController.text,
        type: widget.type,
        createdAt: DateTime.now(),
        balance: 0.0,
      );

      context.read<ClientSupplierCubit>().addEntry(entity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.type == ClientType.client ? 'New Client' : 'New Supplier';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: BlocListener<ClientSupplierCubit, ClientSupplierState>(
        listener: (context, state) {
          state.whenOrNull(
            actionSuccess: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saved Successfully'), backgroundColor: Colors.green),
              );
              context.pop(true); // Return true to refresh list
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
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name *', prefixIcon: Icon(Icons.person)),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone *', prefixIcon: Icon(Icons.phone)),
                  keyboardType: TextInputType.phone,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address', prefixIcon: Icon(Icons.location_on)),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _taxController,
                  decoration: const InputDecoration(labelText: 'Tax Number', prefixIcon: Icon(Icons.confirmation_number)),
                ),
                const SizedBox(height: 24),
                BlocBuilder<ClientSupplierCubit, ClientSupplierState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.maybeWhen(
                        loading: () => null,
                        orElse: () => _submit,
                      ),
                      child: state.maybeWhen(
                        loading: () => const CircularProgressIndicator(color: Colors.white),
                        orElse: () => const Text('Save'),
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