import 'package:flutter/material.dart';
import 'package:leafer/screens/cuttings/cutting_exchange.dart';
import 'package:leafer/screens/cuttings/cutting_tab.dart';
import 'package:leafer/screens/cuttings/my_cuttings.dart';

const List<CuttingTab> tabs = const <CuttingTab>[
  const CuttingTab(title: 'Mes boutures', icon: Icons.collections_bookmark),
  const CuttingTab(title: 'Échanges', icon: Icons.shop),
];

class CuttingHome extends StatelessWidget {
  static const String TITLE = 'Boutures';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(TITLE),
          bottom: TabBar(
            tabs: tabs.map((CuttingTab tab) {
              return Tab(text: tab.title, icon: Icon(tab.icon));
            }).toList(),
          ),
        ),
        body: TabBarView(children: <Widget>[MyCuttings(), CuttingExchange()]),
      ),
    );
  }
}
