import 'package:flutter/material.dart';

void main() { runApp(MaterialApp(home: Fruits())); }
class Fruits extends StatelessWidget {
  final fruits = [
    {'name': 'Apple', 'price': 120, 'about': 'A sweet and crunchy fruit.', 'nutrient': 'Fibre'},
    {'name': 'Banana', 'price': 50, 'about': 'A soft fruit and quick snack.', 'nutrient': 'Potassium'},
    {'name': 'Orange', 'price': 80, 'about': 'A juicy citrus fruit.', 'nutrient': 'Vitamin C'},
    {'name': 'Mango', 'price': 100, 'about': 'A sweet seasonal fruit.', 'nutrient': 'Vitamin A'},
    {'name': 'Grapes', 'price': 90, 'about': 'Small fruits eaten fresh.', 'nutrient': 'Vitamin K'},
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Fruit Market')),
    body: Column(children: [
      Padding(padding: const EdgeInsets.all(16),
        child: Text('${fruits.length} fruits available - prices per kg')),
      Expanded(child: ListView(children: fruits.map((f) => FruitCard(fruit: f)).toList())),
    ]),
  );
}
class FruitCard extends StatelessWidget {
  final Map<String, Object> fruit;
  const FruitCard({super.key, required this.fruit});
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: ListTile(leading: const Icon(Icons.shopping_basket),
      title: Text('${fruit['name']} - Rs. ${fruit['price']}'),
      subtitle: Text('${fruit['about']}\nNutrient: ${fruit['nutrient']}'),
      isThreeLine: true),
  );
}
