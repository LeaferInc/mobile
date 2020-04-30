import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leafer/models/event.dart';
import 'package:leafer/services/entry-service.dart';

/// This class shows the details of a single Event
class EventInfo extends StatefulWidget {
  final Event event;

  EventInfo({Key key, @required this.event}) : super(key: key);

  @override
  _EventInfoState createState() => _EventInfoState(event);
}

class _EventInfoState extends State<EventInfo> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _timeFormat = DateFormat('EEE d MMMM y', 'fr-FR');

  Event _event;
  bool _eventJoined;

  _EventInfoState(this._event);

  @override
  void initState() {
    super.initState();
    _getEventState();
  }

  void _getEventState() async {
    bool joined = await EntryService.getJoinState(_event.id);
    setState(() {
      _eventJoined = joined;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Événements'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                image: AssetImage('assets/images/event.jpg'),
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _event.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.place),
                  Text(
                    _event.location,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _event.description,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Début:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                    child: Text(
                      _timeFormat.format(_event.startDate),
                      style: TextStyle(fontSize: 16.0),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Fin:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                    child: Text(
                      _timeFormat.format(_event.endDate),
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildButton(),
    );
  }

  /// Build a FloatingActionButton depending on the joined state
  FloatingActionButton _buildButton() {
    if (_eventJoined == null) {
      return null;
    } else {
      return FloatingActionButton(
        child: Icon(_eventJoined ? Icons.exit_to_app : Icons.check),
        onPressed: () async {
          String infoMessage;
          if (_eventJoined) {
            int code = await EntryService.unjoinEvent(_event.id);
            _eventJoined = code != 200;
            infoMessage = code == 200 ? 'Événement quitté !' : 'Erreur...';
          } else {
            int code = await EntryService.joinEvent(_event.id);
            _eventJoined = code == 201;
            infoMessage = code == 403
                ? 'Événement complet !'
                : code == 201 ? 'Événement rejoint !' : 'Erreur...';
          }

          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(infoMessage),
          ));

          setState(() {});
        },
      );
    }
  }
}
