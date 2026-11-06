import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:experiment_05/main.dart';

Future<void> start(WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(routes: {
    '/': (_) => Home(),
    '/details': (_) => Details(),
    '/feedback': (_) => FeedbackPage(),
  }));
}

Future<void> feedback(WidgetTester tester) async {
  await start(tester);
  await tester.tap(find.text('Flutter'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Give Feedback'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Both courses pass the selected name to details', (tester) async {
    await start(tester);
    for (final course in ['Flutter', 'Python']) {
      await tester.tap(find.text(course));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, course), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
    }
  });

  testWidgets('Submitted feedback returns trimmed text', (tester) async {
    await feedback(tester);
    await tester.enterText(find.byKey(const Key('name')), 'Kevin');
    await tester.enterText(find.byKey(const Key('comment')), '  Useful course  ');
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Comment: Useful course'), findsOneWidget);
    expect(find.textContaining('Name: Kevin'), findsOneWidget);
    expect(find.text('Give Feedback'), findsOneWidget);
  });

  testWidgets('Whitespace feedback stays on the form', (tester) async {
    await feedback(tester);
    await tester.enterText(find.byKey(const Key('name')), 'Kevin');
    await tester.enterText(find.byKey(const Key('comment')), '   ');
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
    expect(find.text('Enter your name and feedback'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('Cancel returns without a feedback message', (tester) async {
    await feedback(tester);
    await tester.enterText(find.byKey(const Key('name')), 'Kevin');
    await tester.enterText(find.byKey(const Key('comment')), 'Unsubmitted');
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Give Feedback'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('Missing route argument does not crash', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Details()));
    expect(find.text('Course details'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
