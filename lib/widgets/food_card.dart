import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final bool safe;

  const FoodCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.safe,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(safe ? "Safe " : "Avoid ",
            style: TextStyle(color: safe ? Colors.green : Colors.red)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // navigate to food detail later
        },
      ),
    );
  }
}
