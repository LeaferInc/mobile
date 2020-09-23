import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafer/models/recognition.dart';
import 'package:leafer/services/recognition_service.dart';
import 'package:leafer/widgets/loading.dart';
import 'package:path/path.dart';

class RecognitionScreen extends StatefulWidget {
  @override
  _RecognitionScreenState createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final ImagePicker _picker = new ImagePicker();
  File _image;
  RecognitionResult _recognition;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Identifier une plante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    'Image:',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    icon: Icon(
                      Icons.collections,
                      color: Colors.green,
                    ),
                    onPressed: () async {
                      final pickedFile =
                          await _picker.getImage(source: ImageSource.gallery);
                      setState(() {
                        _image = File(pickedFile.path);
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.green,
                    ),
                    onPressed: () async {
                      final pickedFile =
                          await _picker.getImage(source: ImageSource.camera);
                      setState(() {
                        _image = File(pickedFile.path);
                      });
                    },
                  ),
                ),
              ],
            ),
            Text(
              _image == null
                  ? 'Aucune image selectionnée'
                  : basename(_image.path),
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text('Identifier'),
                onPressed: () async {
                  if (_loading) return;
                  if (_image == null) {
                    _scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: Text('Une image est requise')));
                    return;
                  }

                  RecognitionSearch search =
                      new RecognitionSearch(_image.readAsBytesSync());
                  setState(() {
                    _loading = true;
                  });

                  dynamic result = await RecognitionService.recognize(search);

                  if (result == 404) {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content:
                            Text('Aucune correspondance pour cette image')));
                    _recognition = null;
                  } else
                    _recognition = result;

                  setState(() {
                    _loading = false;
                  });
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            ..._buildResults(),
          ],
        ),
      ),
    );
  }

  /// Returns loading widget (if loading), empty (if no result)
  /// or result widgets (if result is present)
  List<Widget> _buildResults() {
    return _loading
        ? [Center(child: Loading())]
        : _recognition == null
            ? []
            : [
                Text(
                  'Résultats',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Nom de la plante: ${_recognition.name}',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                Text(
                  'Taux de reconnaissance: ${_recognition.getScoreRate()}%',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ];
  }
}
