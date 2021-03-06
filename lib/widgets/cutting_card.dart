import 'package:flutter/material.dart';
import 'package:leafer/models/cutting.dart';

class CuttingCard extends StatefulWidget {
  final Cutting cutting;
  final VoidCallback onTap;

  CuttingCard({Key key, @required this.cutting, @required this.onTap})
      : super(key: key);

  @override
  _CuttingCardState createState() => _CuttingCardState(cutting, onTap);
}

class _CuttingCardState extends State<CuttingCard> {
  final Cutting _cutting;
  final VoidCallback _onTap;

  _CuttingCardState(this._cutting, this._onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  image: _cutting.getPicture(),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    child: Text(
                      _cutting.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontSize: 22),
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      "Description : " + _cutting.description,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
