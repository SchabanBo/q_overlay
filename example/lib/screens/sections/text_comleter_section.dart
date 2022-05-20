import 'package:example/screens/section.dart';
import 'package:flutter/material.dart';
import 'package:q_overlay/q_overlay.dart';

class TextCompleterSection extends Section {
  @override
  Widget header(BuildContext context, bool isExpanded) => const ListTile(
        title: Text('Text Completer'),
      );

  @override
  final Widget body = const _DialogSection();
}

class _DialogSection extends StatefulWidget {
  const _DialogSection({Key? key}) : super(key: key);

  @override
  _DialogSectionState createState() => _DialogSectionState();
}

class _DialogSectionState extends State<_DialogSection> {
  final store = List.generate(100, (index) => index.toString());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: QTextCompleter<String>(
        loadSuggestions: (q) async =>
            store.where((element) => element.contains(q)).take(5).toList(),
        initialValue: "5",
        onSelect: (value) => print(value),
        suggestionsBuilder: (p0) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(p0),
        ),
        querySelector: (p0) => p0,
        inputDecoration: const InputDecoration(
          labelText: 'Enter a number up to 100',
        ),
      ),
    );
  }
}
