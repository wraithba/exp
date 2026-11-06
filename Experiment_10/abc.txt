import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final auth = FirebaseAuth.instance;
  String name = '', email = '', password = '', confirm = '', role = 'Student';
  late final Stream<User?> authStream;


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

  void register() {
    if (name.isEmpty || !email.contains('@') || password.length < 6 || password != confirm) {
      setState(() => message = 'Enter name, valid email and matching passwords (6+ characters)'); return;
    }
    final n = name, e = email, p = password, selectedRole = role;
    perform(() async {
      final credential = await auth.createUserWithEmailAndPassword(email: e, password: p);
      try {
        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
          'name': n, 'email': e, 'role': selectedRole,
          'lastLogin': FieldValue.serverTimestamp(),
        });
      } catch (error) {
        throw Exception('Account created but profile save failed. Use Save profile after fixing Firestore access. $error');
      }
    });
  }
  void login() {
    if (email.isEmpty || password.isEmpty) { setState(() => message = 'Enter email and password'); return; }
    final e = email, p = password;
    perform(() async {
      final credential = await auth.signInWithEmailAndPassword(email: e, password: p);
      try {
        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid)
          .set({'lastLogin': FieldValue.serverTimestamp()}, SetOptions(merge: true));
      } catch (error) { throw Exception('Signed in, but timestamp update failed: $error'); }
    });
  }
  @override
  void initState() { super.initState(); authStream = auth.authStateChanges(); }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Registration and Login')),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        ConstrainedBox(constraints: BoxConstraints(maxHeight:
          MediaQuery.sizeOf(context).height * 0.62),
          child: SingleChildScrollView(child: Column(children: [
StreamBuilder<User?>(stream: authStream, builder: (context, snapshot) {
            if (snapshot.hasError) return Text('Login state error: ${snapshot.error}');
            if (snapshot.connectionState == ConnectionState.waiting) return const CircularProgressIndicator();
            final user = snapshot.data;
            if (user == null) return Column(children: [
              field('Name (registration)', (v) => name = v.trim()),
              field('Email', (v) => email = v.trim()),
              field('Password', (v) => password = v, secret: true),
              field('Confirm password (registration)', (v) => confirm = v, secret: true),
              choice('Role', role, ['Student', 'Employee'], (v) => role = v),
              Wrap(spacing: 12, children: [button('Register', register), button('Login', login)]),
            ]);
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Welcome', style: TextStyle(fontSize: 24)),
              Text('Signed in as: ${user.email}'),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
                builder: (context, profile) {
                  if (profile.hasError) return Text('Profile read failed: ${profile.error}');
                  if (!profile.hasData) return const Text('Loading profile...');
                  final data = profile.data!.data();
                  if (data == null) return const Text('Account exists but profile is missing. Enter name and use Save profile.');
                  final stamp = data['lastLogin'];
                  final time = stamp is Timestamp ? stamp.toDate().toLocal().toString() : 'Updating...';
                  return Card(child: Padding(padding: const EdgeInsets.all(12),
                    child: Text('Name: ${data['name']}\nRole: ${data['role']}\nLast login: $time')));
                }),
              field('Name for profile / correction', (v) => name = v.trim()),
              choice('Profile role', role, ['Student', 'Employee'], (v) => role = v),
              Wrap(spacing: 12, children: [
                button('Save profile', () {
                  if (name.isEmpty) { setState(() => message = 'Enter your name'); return; }
                  perform(() => FirebaseFirestore.instance.collection('users').doc(user.uid)
                    .set({'name': name, 'role': role, 'email': user.email}, SetOptions(merge: true)));
                }),
                button('Logout', () => perform(() async { await auth.signOut(); password = ''; confirm = ''; })),
              ]),
            ]);
          }),
          if (busy) const LinearProgressIndicator(),
          if (message.isNotEmpty) Padding(padding: const EdgeInsets.all(8),
            child: Text(message)),
        ]))),

      ])),
    );
  }
}
