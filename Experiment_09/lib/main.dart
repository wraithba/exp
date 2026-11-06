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
  final tasks = FirebaseFirestore.instance.collection('tasks');
  String title = '', assignee = '', filter = 'All';

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

  Future<void> edit(QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
    final titleInput = TextEditingController(text: '${doc.data()['title']}');
    final personInput = TextEditingController(text: '${doc.data()['assignee']}');
    final result = await showDialog<Map<String, String>>(context: context,
      builder: (dialogContext) => AlertDialog(title: const Text('Edit task'),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: titleInput, decoration: const InputDecoration(labelText: 'Title')),
          TextField(controller: personInput, decoration: const InputDecoration(labelText: 'Assignee')),
        ])), actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          TextButton(child: const Text('Save'), onPressed: () {
            if (titleInput.text.trim().isEmpty || personInput.text.trim().isEmpty) return;
            Navigator.pop(dialogContext, <String, String>{
              'title': titleInput.text.trim(), 'assignee': personInput.text.trim()});
          }),
        ]));
    // Controllers belong to the dialog; allow its closing animation to finish.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    titleInput.dispose(); personInput.dispose();
    if (!mounted || result == null) return;
    perform(() => doc.reference.update({...result, 'updatedAt': FieldValue.serverTimestamp()}));
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Task Update Manager')),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        ConstrainedBox(constraints: BoxConstraints(maxHeight:
          MediaQuery.sizeOf(context).height * 0.62),
          child: SingleChildScrollView(child: Column(children: [
field('Task title', (v) => title = v.trim()),
          field('Assignee', (v) => assignee = v.trim()),
          button('Add task', () {
            if (title.isEmpty || assignee.isEmpty) {
              setState(() => message = 'Enter title and assignee'); return;
            }
            final data = {'title': title, 'assignee': assignee,
              'progress': 0, 'status': 'Pending', 'updatedAt': FieldValue.serverTimestamp()};
            perform(() async { await tasks.add(data); });
          }),
          choice('Status filter', filter, ['All', 'Pending', 'In progress', 'Completed'], (v) => filter = v),
          if (busy) const LinearProgressIndicator(),
          if (message.isNotEmpty) Padding(padding: const EdgeInsets.all(8),
            child: Text(message)),
        ]))),
        Expanded(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: tasks.snapshots(), builder: (context, snapshot) {
            if (snapshot.hasError) return Text('Database error: ${snapshot.error}');
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final docs = snapshot.data!.docs;
            final shown = docs.where((d) => filter == 'All' || d.data()['status'] == filter).toList();
            if (shown.isEmpty) return const Center(child: Text('No tasks found'));
            return ListView(children: shown.map((d) {
              final data = d.data();
              final progress = ((data['progress'] as num?) ?? 0).toDouble().clamp(0, 100).toDouble();
              return Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${data['title']}', style: const TextStyle(fontSize: 18)),
                  Text('Assignee: ${data['assignee']} | ${data['status']}'),
                  Text('Progress: ${progress.toInt()}%'),
                  Slider(value: progress, min: 0, max: 100, divisions: 10,
                    onChanged: busy ? null : (value) => perform(() => d.reference.update({
                      'progress': value.toInt(),
                      'status': value == 100 ? 'Completed' : value == 0 ? 'Pending' : 'In progress',
                      'updatedAt': FieldValue.serverTimestamp(),
                    }))),
                  Wrap(spacing: 12, children: [
                    button('Edit details', () => edit(d)),
                    button('Delete', () => perform(() => d.reference.delete())),
                  ]),
                ])));
            }).toList());
          })),

      ])),
    );
  }
}
