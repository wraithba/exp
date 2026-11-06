import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(routes: {
    '/': (_) => Home(),
    '/details': (_) => Details(),
    '/feedback': (_) => FeedbackPage(),
  }));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Catalog')),
      body: ListView(children: ['Flutter', 'Python'].map((course) {
        return Card(child: ListTile(
          title: Text(course),
          subtitle: const Text('View course details and give feedback'),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () => Navigator.pushNamed(context, '/details', arguments: course),
        ));
      }).toList()),
    );
  }
}

class Details extends StatefulWidget {
  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Map<String, dynamic>? feedback;

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)?.settings.arguments;
    final course = argument is String ? argument : 'Course details';
    final isFlutter = course == 'Flutter';
    return Scaffold(
      appBar: AppBar(title: Text(course)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Learn $course', style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 12),
          Text(isFlutter
            ? 'Build mobile and desktop applications using Dart and Flutter.'
            : 'Learn Python programming through simple practical exercises.'),
          const SizedBox(height: 12),
          const Text('Level: Beginner'),
          const Text('Duration: 4 weeks (sample course)'),
          const SizedBox(height: 12),
          const Text('Topics', style: TextStyle(fontSize: 20)),
          Text(isFlutter
            ? '1. Dart basics\n2. Widgets and layouts\n3. Forms and navigation'
            : '1. Variables and loops\n2. Functions\n3. Lists and dictionaries'),
          const SizedBox(height: 20),
          ElevatedButton(child: const Text('Give Feedback'), onPressed: () async {
            final result = await Navigator.pushNamed(context, '/feedback');
            if (!mounted || result is! Map<String, dynamic>) return;
            setState(() => feedback = result);
          }),
          const SizedBox(height: 20),
          const Text('Submitted feedback', style: TextStyle(fontSize: 20)),
          if (feedback == null)
            const Text('No feedback submitted yet.')
          else
            Card(child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text('Name: ${feedback!['name']}\n'
                'Rating: ${feedback!['rating']}/5\n'
                'Comment: ${feedback!['comment']}'),
            )),
        ]),
      ),
    );
  }
}

class FeedbackPage extends StatefulWidget {
  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String name = '', comment = '';
  int rating = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Feedback')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(key: const Key('name'),
            decoration: const InputDecoration(labelText: 'Your name'),
            onChanged: (v) => name = v.trim()),
          const SizedBox(height: 12),
          const Text('Rating out of 5'),
          DropdownButton<int>(value: rating,
            items: [1, 2, 3, 4, 5].map((n) => DropdownMenuItem(
              value: n, child: Text('$n stars'))).toList(),
            onChanged: (v) => setState(() => rating = v!)),
          TextField(key: const Key('comment'), maxLines: 3,
            decoration: const InputDecoration(labelText: 'Your feedback'),
            onChanged: (v) => comment = v.trim()),
          const SizedBox(height: 16),
          ElevatedButton(child: const Text('Submit'), onPressed: () {
            if (name.isEmpty || comment.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Enter your name and feedback')));
              return;
            }
            Navigator.pop(context, <String, dynamic>{
              'name': name, 'rating': rating, 'comment': comment,
            });
          }),
        ]),
      ),
    );
  }
}
