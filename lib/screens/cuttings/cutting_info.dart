import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leafer/models/cutting.dart';

class CuttingInfo extends StatefulWidget {
  final Cutting cutting;

  CuttingInfo({Key key, @required this.cutting}) : super(key: key);

  @override
  _CuttingInfoState createState() => _CuttingInfoState(cutting);
}

class _CuttingInfoState extends State<CuttingInfo> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Cutting _cutting;

  _CuttingInfoState(this._cutting);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_cutting.name),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: NetworkImage("https://picsum.photos/200"),
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _cutting.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _cutting.description,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ])),
    );
  }
}
