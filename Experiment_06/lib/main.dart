import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit(); databaseFactory = databaseFactoryFfi;
  runApp(MaterialApp(home: Lab()));
}
class Lab extends StatefulWidget {
  @override
  State<Lab> createState() => _LabState();
}
class _LabState extends State<Lab> {
  Database? db;
  String roll = '', name = '', course = '', cgpa = '', search = '';
  List<Map<String, Object?>> students = [];

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

  Future<void> load() async {
    final rows = await db!.query('students');
    if (mounted) setState(() => students = rows);
  }
  Future<void> open() async {
    await perform(() async {
      db = await openDatabase(join(await getDatabasesPath(), 'lab_students_v2.db'),
        version: 1, onCreate: (db, version) async {
          await db.execute('CREATE TABLE students(roll TEXT PRIMARY KEY, name TEXT, course TEXT, cgpa REAL)');
        });
      await load();
    });
  }
  void saveStudent() {
    final g = double.tryParse(cgpa);
    if (db == null) { setState(() => message = 'Database is not ready'); return; }
    if (roll.isEmpty || name.isEmpty || course.isEmpty ||
        g == null || !g.isFinite || g < 0 || g > 10) {
      setState(() => message = 'Enter all fields and CGPA from 0 to 10'); return;
    }
    final row = <String, Object?>{'roll': roll, 'name': name, 'course': course, 'cgpa': g};
    perform(() async {
      final found = await db!.query('students', where: 'roll = ?', whereArgs: [row['roll']]);
      if (found.isNotEmpty) throw Exception('Roll number already exists');
      await db!.insert('students', row); await load();
    });
  }
  @override
  void initState() { super.initState(); open(); }

  @override
  Widget build(BuildContext context) {
    final items = students.where((s) => '${s['name']} ${s['roll']}'.toLowerCase().contains(search)).toList();
    final average = students.isEmpty ? '0.00' :
      (students.fold<double>(0, (sum, s) => sum + (s['cgpa'] as num).toDouble()) / students.length).toStringAsFixed(2);
    return Scaffold(
      appBar: AppBar(title: const Text('SQLite Student Records')),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        ConstrainedBox(constraints: BoxConstraints(maxHeight:
          MediaQuery.sizeOf(context).height * 0.62),
          child: SingleChildScrollView(child: Column(children: [
field('Roll number', (v) => roll = v.trim()),
          field('Student name', (v) => name = v.trim()),
          field('Course', (v) => course = v.trim()),
          field('CGPA (0 to 10)', (v) => cgpa = v.trim(), number: true),
          button('Save student', saveStudent),
          field('Search name or roll', (v) => setState(() => search = v.trim().toLowerCase())),
          Text('${students.length} students | Average CGPA: $average'),
          if (busy) const LinearProgressIndicator(),
          if (message.isNotEmpty) Padding(padding: const EdgeInsets.all(8),
            child: Text(message)),
        ]))),
        Expanded(child: items.isEmpty ? const Center(child: Text('No students found'))
        : ListView(children: items.map((s) => Card(child: ListTile(
          title: Text('${s['name']} (${s['roll']})'),
          subtitle: Text('Course: ${s['course']} | CGPA: ${s['cgpa']}'),
        ))).toList())),

      ])),
    );
  }
}
