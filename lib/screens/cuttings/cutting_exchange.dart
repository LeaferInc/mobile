import 'package:flutter/material.dart';
import 'package:leafer/models/cutting.dart';
import 'package:leafer/screens/events/event_info.dart';
import 'package:leafer/services/cutting_service.dart';
import 'package:leafer/widgets/cutting_card.dart';
import 'package:random_string/random_string.dart';

import 'cutting_info.dart';

class CuttingExchange extends StatefulWidget {
  static const String TITLE = 'Trouver des boutures';

  @override
  CuttingExchangeState createState() => CuttingExchangeState();
}

class CuttingExchangeState extends State<CuttingExchange> {
  List<Cutting> _myCuttings = new List<Cutting>();

  @override
  initState() {
    super.initState();
    _getMyCuttings();
  }

  void _getMyCuttings() async {
    List<Cutting> data = await CuttingService.getAllCuttings();
    setState(() {
      _myCuttings = data;
    });
  }

  Widget _buildList(BuildContext context, List<Cutting> cuttings) {
    return ListView.builder(
        key: Key(randomString(20)),
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, item) {
          final index = item;
          return _buildRow(cuttings.elementAt(index));
        },
        itemCount: cuttings.length);
  }

  Widget _buildRow(Cutting cutting) {
    return Card(
        child: Stack(
      children: <Widget>[
        CuttingCard(
          cutting: cutting,
          onTap: () async {
            final EntryAction action = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CuttingInfo(cutting: cutting)));
          },
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CuttingExchange.TITLE),
      ),
      body: _buildList(context, _myCuttings),
    );
  }
}
