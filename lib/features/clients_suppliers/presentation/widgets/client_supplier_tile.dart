// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../domain/entities/client_supplier_entity.dart';

class ClientSupplierTile extends StatelessWidget {
  final ClientSupplierEntity entity;
  final VoidCallback? onTap;

  const ClientSupplierTile({
    super.key,
    required this.entity,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد لون الرصيد (أحمر إذا مدين، أخضر إذا دائن)
    final balanceColor = entity.balance < 0 
        ? Colors.red 
        : (entity.balance > 0 ? Colors.green : Colors.grey);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Text(
            entity.name.characters.first.toUpperCase(),
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        title: Text(entity.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entity.phone.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.phone, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(entity.phone, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            if (entity.address != null && entity.address!.isNotEmpty)
              Text(
                entity.address!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Balance',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              entity.balance.toStringAsFixed(2),
              style: TextStyle(
                color: balanceColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}