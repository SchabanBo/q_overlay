import 'package:example/screens/scetion.dart';
import 'package:example/screens/sections/expander_section.dart';
import 'package:example/screens/sections/global_expander_section.dart';
import 'package:example/screens/sections/windows_scetion.dart';
import 'package:example/screens/sections/notifications_section.dart';
import 'package:example/screens/sections/panel_section.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _childrens = <Section>[
    NotificationSection(),
    PanelSection(),
    WindowSection(),
    ExpanderSection(),
    GlobalExpanderssSection(),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _childrens[index].isExpanded = !isExpanded;
          });
        },
        children: _childrens
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
