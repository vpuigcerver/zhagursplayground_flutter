import 'package:flutter/material.dart';
import '../models/item.dart';

class ItemsDialog extends StatelessWidget {
  final List<Item> items;
  final Function(Item) onUse;

  const ItemsDialog({
    super.key,
    required this.items,
    required this.onUse,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[850],
      title: const Text("Objetos", style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: items.map((item) {
          return Card(
            color: Colors.grey[800],
            child: ListTile(
              leading: Icon(item.icon, color: Colors.greenAccent),
              title: Text(item.name,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
              subtitle: Text(item.description,
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
              onTap: () {
                Navigator.pop(context);
                onUse(item);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}