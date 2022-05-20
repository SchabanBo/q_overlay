import 'package:example/screens/section.dart';
import 'package:example/screens/sections/dialog_section.dart';
import 'package:example/screens/sections/expander_section.dart';
import 'package:example/screens/sections/global_expander_section.dart';
import 'package:example/screens/sections/notifications_section.dart';
import 'package:example/screens/sections/panel_section.dart';
import 'package:example/screens/sections/text_comleter_section.dart';
import 'package:example/screens/sections/windows_scetion.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _children = <Section>[
    NotificationSection(),
    PanelSection(),
    TextCompleterSection(),
    WindowSection(),
    ExpanderSection(),
    GlobalExpandersSection(),
    DialogSection(),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _children[index].isExpanded = !isExpanded;
          });
        },
        children: _children
            .map((e) => ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: e.header,
                body: e.body,
                isExpanded: e.isExpanded))
            .toList(),
      ),
    );
  }
}
