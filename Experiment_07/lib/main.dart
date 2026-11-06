import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    runApp(MaterialApp(home: Lab()));
  } catch (error) {
    runApp(MaterialApp(home: Scaffold(body: Center(
      child: Text('Firebase setup failed: $error')))));
  }
}
class Lab extends StatefulWidget {
  @override
  State<Lab> createState() => _LabState();
}
class _LabState extends State<Lab> {
  final employees = FirebaseFirestore.instance.collection('employees');
  String id = '', name = '', department = 'Engineering', search = '', filter = 'All';

  String message = '';
  bool busy = false;
  Future<void> perform(Future<void> Function() action) async {
    if (busy) return;
    setState(() { busy = true; message = ''; });
    try {
      await action();
      if (mounted && message.isEmpty) message = 'Completed successfully';
    } catch (error) {
      if (mounted) message = 'Operation failed: $error';
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }
  Widget field(String label, ValueChanged<String> changed,
      {bool secret = false, bool number = false}) {
    return TextField(obscureText: secret,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label), onChanged: changed);
  }
  Widget choice(String label, String value, List<String> items,
      ValueChanged<String> changed) {
    return DropdownButtonFormField<String>(
      key: ValueKey('$label:$value'), value: value,
      decoration: InputDecoration(labelText: label),
      items: items.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
      onChanged: (s) { if (s != null) setState(() => changed(s)); });
  }
  Widget button(String label, VoidCallback action) => ElevatedButton(
    onPressed: busy ? null : action, child: Text(label));

  void saveEmployee() {
    if (id.isEmpty || id.contains('/') || name.isEmpty) {
      setState(() => message = 'Enter a valid ID and name'); return;
    }
    final ref = employees.doc(id);
    final data = {'name': name, 'department': department};
    perform(() => FirebaseFirestore.instance.runTransaction<void>((tx) async {
      if ((await tx.get(ref)).exists) throw Exception('Employee ID already exists');
      tx.set(ref, data);
    }));
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Employee Directory')),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        ConstrainedBox(constraints: BoxConstraints(maxHeight:
          MediaQuery.sizeOf(context).height * 0.62),
          child: SingleChildScrollView(child: Column(children: [
field('Employee ID', (v) => id = v.trim()),
          field('Employee name', (v) => name = v.trim()),
          choice('Department', department, ['Engineering', 'HR', 'Sales'], (v) => department = v),
          button('Add employee', saveEmployee),
          field('Search name or ID', (v) => setState(() => search = v.trim().toLowerCase())),
          choice('Filter department', filter, ['All', 'Engineering', 'HR', 'Sales'], (v) => filter = v),
          if (busy) const LinearProgressIndicator(),
          if (message.isNotEmpty) Padding(padding: const EdgeInsets.all(8),
            child: Text(message)),
        ]))),
        Expanded(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: employees.snapshots(), builder: (context, snapshot) {
            if (snapshot.hasError) return Text('Database error: ${snapshot.error}');
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final docs = snapshot.data!.docs;
            final shown = docs.where((d) =>
              '${d.id} ${d.data()['name']}'.toLowerCase().contains(search) &&
              (filter == 'All' || d.data()['department'] == filter)).toList();
            if (shown.isEmpty) return const Center(child: Text('No employees found'));
            return ListView(children: shown.map((d) => Card(child: ListTile(
              title: Text('${d.data()['name']} (${d.id})'),
              subtitle: Text('Department: ${d.data()['department']}'),
              trailing: IconButton(icon: const Icon(Icons.delete),
                onPressed: busy ? null : () => perform(() => d.reference.delete())),
            ))).toList());
          })),

      ])),
    );
  }
}
