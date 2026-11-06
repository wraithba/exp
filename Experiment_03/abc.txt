import 'package:flutter/material.dart';

void main() { runApp(MaterialApp(home: Lab())); }
class Lab extends StatefulWidget {
  @override
  State<Lab> createState() => _LabState();
}
class _LabState extends State<Lab> {
  final searchController = TextEditingController();
  String search = '', category = 'All', sort = 'Name';
  double limit = 3000;
  bool stockOnly = false;
  final products = [
    {'name': 'Watch', 'price': 2000, 'category': 'Electronics', 'stock': true},
    {'name': 'Headphones', 'price': 1500, 'category': 'Electronics', 'stock': false},
    {'name': 'Shirt', 'price': 800, 'category': 'Clothing', 'stock': true},
    {'name': 'Jeans', 'price': 1200, 'category': 'Clothing', 'stock': true},
  ];

  Widget choice(String label, String value, List<String> items,
      ValueChanged<String> changed) {
    return DropdownButtonFormField<String>(
      key: ValueKey('$label:$value'), value: value,
      decoration: InputDecoration(labelText: label),
      items: items.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
      onChanged: (s) { if (s != null) setState(() => changed(s)); });
  }
  Widget button(String label, VoidCallback action) => ElevatedButton(
    onPressed: action, child: Text(label));



  @override
  void dispose() { searchController.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final items = products.where((p) =>
      '${p['name']}'.toLowerCase().contains(search.trim().toLowerCase()) &&
      (category == 'All' || p['category'] == category) &&
      (p['price'] as int) <= limit && (!stockOnly || p['stock'] == true)).toList();
    items.sort((a,b) => sort == 'Price'
      ? (a['price'] as int).compareTo(b['price'] as int)
      : '${a['name']}'.compareTo('${b['name']}'));
    return Scaffold(
      appBar: AppBar(title: const Text('Search and Filter')),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        ConstrainedBox(constraints: BoxConstraints(maxHeight:
          MediaQuery.sizeOf(context).height * 0.62),
          child: SingleChildScrollView(child: Column(children: [
TextField(controller: searchController,
            decoration: const InputDecoration(labelText: 'Search product'),
            onChanged: (v) => setState(() => search = v)),
          choice('Category', category, ['All', 'Electronics', 'Clothing'], (v) => category = v),
          Text('Maximum price: Rs. ${limit.toInt()}'),
          Slider(value: limit, min: 0, max: 3000, divisions: 30,
            onChanged: (v) => setState(() => limit = v)),
          SwitchListTile(title: const Text('In stock only'), value: stockOnly,
            onChanged: (v) => setState(() => stockOnly = v)),
          choice('Sort by', sort, ['Name', 'Price'], (v) => sort = v),
          button('Reset', () => setState(() {
            searchController.clear(); search = ''; category = 'All';
            limit = 3000; stockOnly = false; sort = 'Name';
          })),
          Text('${items.length} matching products'),
        ]))),
        Expanded(child: items.isEmpty ? const Center(child: Text('No products found'))
        : ListView(children: items.map((p) => Card(child: ListTile(
          title: Text('${p['name']} - Rs. ${p['price']}'),
          subtitle: Text('${p['category']} | ${p['stock'] == true ? 'In stock' : 'Out of stock'}'),
        ))).toList())),

      ])),
    );
  }
}
