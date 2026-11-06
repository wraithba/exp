import 'package:flutter/material.dart';

void main() { runApp(MaterialApp(home: Lab())); }
class Lab extends StatefulWidget {
  @override
  State<Lab> createState() => _LabState();
}
class _LabState extends State<Lab> {
  final inputs = List.generate(4, (_) => TextEditingController());
  final labels = ['Initial km', 'Final km', 'Fuel litres', 'Price per litre'];
  String result = '';
  final history = <String>[];
  void calculate() {
    final values = inputs.map((c) => double.tryParse(c.text.trim())).toList();
    if (values.any((v) => v == null || !v.isFinite)) {
      setState(() => result = 'Enter valid numbers');
      return;
    }
    final a = values[0]!, b = values[1]!, fuel = values[2]!, price = values[3]!;
    setState(() {
      if (a < 0 || b <= a || fuel <= 0 || price < 0) {
        result = 'Check readings, fuel and price';
      } else {
        result = 'Mileage: ${((b-a)/fuel).toStringAsFixed(2)} km/l\n'
            'Cost: Rs. ${(fuel*price).toStringAsFixed(2)}';
        history.insert(0, result);
      }
    });
  }
  @override
  void dispose() {
    for (final c in inputs) { c.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mileage Calculator')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16),
        child: Column(children: [
          for (int i = 0; i < 4; i++)
            TextField(controller: inputs[i],
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: labels[i])),
          ElevatedButton(onPressed: calculate, child: const Text('Calculate')),
          Text(result),
        ])),
    );
  }
}
