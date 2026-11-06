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
  final books = FirebaseFirestore.instance.collection('books');
  String title = '', author = '', genre = 'Technology', filter = 'All', search = '';
  String mode = 'Prefix';
  List<QueryDocumentSnapshot<Map<String, dynamic>>> results = [];
  bool searched = false;

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

  void addBook() {
    if (title.isEmpty || author.isEmpty) {
      setState(() => message = 'Enter title and author'); return;
    }
    final data = {'title': title, 'author': author, 'genre': genre,
      'titleLower': title.toLowerCase(),
      'keywords': title.toLowerCase().split(RegExp(r'\s+'))};
    perform(() async { await books.add(data); await loadBooks(); });
  }
  Future<void> loadBooks() async {
    final text = search;
    Query<Map<String, dynamic>> query = books;
    if (text.isNotEmpty) {
      query = mode == 'Keyword' ? books.where('keywords', arrayContains: text)
        : books.orderBy('titleLower').startAt([text]).endAt(['$text\uf8ff']);
    }
    final found = await query.get();
    if (mounted) setState(() { results = found.docs; searched = true; });
  }
  void find() { perform(loadBooks); }


  @override
  Widget build(BuildContext context) {
    final shown = results.where((d) => filter == 'All' || d.data()['genre'] == filter).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Book Catalog and Search')),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        ConstrainedBox(constraints: BoxConstraints(maxHeight:
          MediaQuery.sizeOf(context).height * 0.62),
          child: SingleChildScrollView(child: Column(children: [
field('Book title', (v) => title = v.trim()),
          field('Author', (v) => author = v.trim()),
          choice('Book genre', genre, ['Technology', 'Fiction', 'Science'], (v) => genre = v),
          button('Add book', addBook),
          const Divider(),
          field('Search title', (v) => search = v.trim().toLowerCase()),
          choice('Search mode', mode, ['Prefix', 'Keyword'], (v) => mode = v),
          choice('Filter genre', filter, ['All', 'Technology', 'Fiction', 'Science'], (v) => filter = v),
          button('Search / show all', find),
          if (busy) const LinearProgressIndicator(),
          if (message.isNotEmpty) Padding(padding: const EdgeInsets.all(8),
            child: Text(message)),
        ]))),
        Expanded(child: !searched ? const Center(child: Text('Add a book or press Search to load the catalog'))
        : shown.isEmpty ? const Center(child: Text('No books found'))
        : ListView(children: shown.map((d) => Card(child: ListTile(
          title: Text('${d.data()['title']}'),
          subtitle: Text('Author: ${d.data()['author']} | Genre: ${d.data()['genre']}'),
        ))).toList())),

      ])),
    );
  }
}
