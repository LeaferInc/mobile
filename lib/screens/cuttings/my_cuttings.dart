import 'package:flutter/material.dart';
import 'package:leafer/models/cutting.dart';
import 'package:leafer/screens/cuttings/cutting_form.dart';
import 'package:leafer/screens/cuttings/cutting_info.dart';
import 'package:leafer/screens/events/event_info.dart';
import 'package:leafer/services/cutting_service.dart';
import 'package:leafer/widgets/cutting_card.dart';
import 'package:leafer/widgets/loading_list.dart';
import 'package:random_string/random_string.dart';

class MyCuttings extends StatefulWidget {
  @override
  MyCuttingsState createState() => MyCuttingsState();
}

class MyCuttingsState extends State<MyCuttings> {
  List<Cutting> _myCuttings;

  @override
  initState() {
    super.initState();
    _getMyCuttings();
  }

  void _getMyCuttings() async {
    List<Cutting> data = await CuttingService.getMyCuttings();
    setState(() {
      _myCuttings = data;
    });
  }

  ListView _buildList(BuildContext context, List<Cutting> cuttings) {
    return ListView.builder(
        key: Key(randomString(20)),
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, item) {
          final index = item;
          return _buildRow(cuttings.elementAt(index));
        },
        itemCount: cuttings != null ? cuttings.length : 0);
  }

  Widget _buildRow(Cutting cutting) {
    return Card(
        child: Stack(children: <Widget>[
      CuttingCard(
        cutting: cutting,
        onTap: () async {
          final EntryAction action = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CuttingInfo(cutting: cutting)));
        },
      ),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body: _buildList(context, _myCuttings),
      body: LoadingList(
        emptyText: 'Aucune bouture trouvée',
        child: _buildList(context, _myCuttings),
        list: _myCuttings,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'MyCuttingsTag',
        child: Icon(Icons.add),
        onPressed: () async {
          final Cutting result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => CuttingForm()));
          if (result != null) {
            _myCuttings.add(result);
          }
        },
      ),
    );
  }
}
