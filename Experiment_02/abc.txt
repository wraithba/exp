import 'package:flutter/material.dart';

void main() { runApp(MaterialApp(home: Lab())); }
class Lab extends StatefulWidget {
  @override
  State<Lab> createState() => _LabState();
}
class _LabState extends State<Lab> {
  String category = 'All';
  bool grid = true;
  final products = [
    {'name': 'Phone', 'price': 15000, 'category': 'Electronics'},
    {'name': 'Watch', 'price': 2000, 'category': 'Electronics'},
    {'name': 'Shirt', 'price': 800, 'category': 'Clothing'},
    {'name': 'Jeans', 'price': 1200, 'category': 'Clothing'},
  ];

  Widget choice(String label, String value, List<String> items,
      ValueChanged<String> changed) {
    return DropdownButtonFormField<String>(
      key: ValueKey('$label:$value'), value: value,
      decoration: InputDecoration(labelText: label),
      items: items.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
      onChanged: (s) { if (s != null) setState(() => changed(s)); });
  }




  @override
  Widget build(BuildContext context) {
    final items = products.where((p) => category == 'All' || p['category'] == category).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Product Catalog')),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        ConstrainedBox(constraints: BoxConstraints(maxHeight:
          MediaQuery.sizeOf(context).height * 0.62),
          child: SingleChildScrollView(child: Column(children: [
choice('Category', category, ['All', 'Electronics', 'Clothing'], (v) => category = v),
          SwitchListTile(title: const Text('Grid view'), value: grid,
            onChanged: (v) => setState(() => grid = v)),
          Text('${items.length} products'),
        ]))),
        Expanded(child: LayoutBuilder(builder: (context, size) {
          final cards = items.map((p) => Card(child: Padding(
            padding: const EdgeInsets.all(12), child: Column(
              mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min,
              children: [const Icon(Icons.shopping_bag), Text('${p['name']}'),
                Text('Rs. ${p['price']}'), Text('${p['category']}')])))).toList();
          return grid ? GridView.count(
            crossAxisCount: size.maxWidth < 360 ? 1 : size.maxWidth < 600 ? 2 : 4,
            childAspectRatio: 1.0, children: cards)
            : ListView(children: cards);
        })),

      ])),
    );
  }
}
