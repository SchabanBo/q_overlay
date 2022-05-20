import 'package:flutter/material.dart';

import '../../q_overlay.dart';

class QTextCompleter<T> extends StatefulWidget {
  final Future<List<T>> Function(String) loadSuggestions;
  final Widget Function(T) suggestionsBuilder;
  final Widget loadingWidget;
  final T? initialValue;
  final Function(T) onSelect;
  final bool Function(T)? validator;
  final String Function(T) querySelector;
  final InputDecoration? inputDecoration;

  const QTextCompleter({
    required this.loadSuggestions,
    required this.onSelect,
    required this.querySelector,
    required this.suggestionsBuilder,
    this.inputDecoration,
    this.validator,
    this.initialValue,
    Key? key,
    this.loadingWidget = const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: CircularProgressIndicator())),
  }) : super(key: key);

  @override
  State<QTextCompleter<T>> createState() => _QTextCompleterState<T>();
}

class _QTextCompleterState<T> extends State<QTextCompleter<T>> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  bool _isValid(T? v) =>
      v != null && (widget.validator == null || widget.validator!(v));

  @override
  void initState() {
    super.initState();
    if (_isValid(widget.initialValue!)) {
      _textController.text = widget.querySelector(widget.initialValue!);
      current = widget.initialValue;
    }
    _focusNode.addListener(() {
      setState(() {
        expanded = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  T? current;
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return QExpander(
      expand: expanded,
      alignment: Alignment.bottomCenter,
      backgroundFilter: BackgroundFilterSettings.transparent(false),
      expandChild: _Suggestions<T>(
        controller: _textController,
        validator: _isValid,
        querySelector: widget.querySelector,
        loadSuggestions: widget.loadSuggestions,
        suggestionsBuilder: widget.suggestionsBuilder,
        loadingWidget: widget.loadingWidget,
        result: (e) {
          current = e;
          widget.onSelect(e);
          expanded = false;
        },
      ),
      isClickable: false,
      child: TextField(
        focusNode: _focusNode,
        controller: _textController,
        decoration: widget.inputDecoration,
      ),
    );
  }
}

class _Suggestions<T> extends StatefulWidget {
  final TextEditingController controller;
  final Future<List<T>> Function(String) loadSuggestions;
  final Function(T) result;
  final bool Function(T) validator;
  final String Function(T) querySelector;
  final Widget Function(T) suggestionsBuilder;
  final Widget loadingWidget;
  const _Suggestions({
    required this.controller,
    required this.loadSuggestions,
    required this.validator,
    required this.querySelector,
    required this.result,
    required this.suggestionsBuilder,
    required this.loadingWidget,
    Key? key,
  }) : super(key: key);

  @override
  State<_Suggestions> createState() => _SuggestionsState<T>();
}

class _SuggestionsState<T> extends State<_Suggestions<T>> {
  late String query = widget.controller.text;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listen);
  }

  @override
  void dispose() {
    widget.controller.removeListener(listen);
    super.dispose();
  }

  void listen() {
    query = widget.controller.text;
    update(query);
  }

  void update(String v, {bool confirm = false}) {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    widget.loadSuggestions(v).then((value) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        suggestions = value;
      });

      if (confirm && value.isNotEmpty && widget.validator(value.first)) {
        widget.result(value.first);
      }

      if (query != v) {
        update(query);
      }
    });
  }

  List<T> suggestions = [];

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return widget.loadingWidget;
    }

    return ListView(
      shrinkWrap: true,
      children: suggestions
          .map(
            (e) => InkWell(
              child: widget.suggestionsBuilder(e),
              onTap: () {
                query = widget.querySelector(e);
                update(query, confirm: true);
                widget.controller.text = query;
              },
            ),
          )
          .toList(),
    );
  }
}
