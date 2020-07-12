import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leafer/models/event.dart';
import 'package:leafer/services/entry_service.dart';
import 'package:leafer/services/event_service.dart';

/// This class shows the details of a single Event
class EventInfo extends StatefulWidget {
  final Event event;
  final bool joined;

  EventInfo({Key key, @required this.event, this.joined}) : super(key: key);

  @override
  _EventInfoState createState() => _EventInfoState(event, joined);
}

/// User action on the event
enum EventAction {
  JOINED,
  LEFT,
  NONE,
  DELETED,
}

class _EventInfoState extends State<EventInfo> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _timeFormat = DateFormat('EEE d MMMM y à HH:mm', 'fr-FR');

  EventAction _action;
  Event _event;
  bool _joined;

  _EventInfoState(this._event, this._joined);

  @override
  void initState() {
    super.initState();
    _action = EventAction.NONE;

    if (!_joined) {
      _getEventState();
    }
  }

  void _getEventState() async {
    bool state = await EntryService.getJoinState(_event.id);
    setState(() {
      _joined = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_action == EventAction.DELETED) {
      Navigator.of(context).pop(_action);
      return Scaffold(
        appBar: AppBar(
          title: Text('Événements'),
        ),
      );
    }
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Événements'),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (item) {
                return showDialog<void>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Supprimmer'),
                    content: Text(
                        'Voulez-vous vraiment supprimer cet évènement ? Cette action est irréversible.'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Annuler'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text('Supprimer'),
                        onPressed: () async {
                          int res = await EventService.deleteEvent(_event.id);
                          Navigator.pop(context);
                          if (res == 401) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                  'Vous n\'êtes pas l\'organisateur de cet évènement'),
                            ));
                          } else if (res != 200) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content:
                                  Text('Impossible de supprimer l\'évènement'),
                            ));
                          } else {
                            setState(() {
                              this._action = EventAction.DELETED;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: 0,
                    child: Text(
                      'Supprimer',
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  image: _event.getPicture(),
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _event.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.place),
                    Flexible(
                      child: Text(
                        _event.location,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _event.description,
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Début:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                      child: Text(
                        _timeFormat.format(_event.startDate),
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Fin:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                      child: Text(
                        _timeFormat.format(_event.endDate),
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build a RaisedButton depending on the joined state
  RaisedButton _buildButton() {
    if (_joined == null) {
      return null;
    } else {
      return RaisedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(_joined ? Icons.close : Icons.check),
            Text(_joined ? 'Je quitte' : 'Je participe'),
          ],
        ),
        onPressed: () async {
          String infoMessage;
          if (_joined) {
            int code = await EntryService.unjoinEvent(_event.id);
            if (code == 200) {
              infoMessage = 'Événement quitté !';
              _joined = false;
              _action = EventAction.LEFT;
            } else {
              infoMessage = 'Erreur...';
            }
          } else {
            int code = await EntryService.joinEvent(_event.id);
            if (code == 201) {
              infoMessage = 'Événement rejoint !';
              _joined = true;
              _action = EventAction.JOINED;
            } else if (code == 403) {
              infoMessage = 'Événement complet !';
            }
          }

          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(infoMessage),
          ));

          setState(() {});
        },
      );
    }
  }

  /// Give back data to update joined events list
  Future<bool> _onBackPressed() {
    print("Popped");
    Navigator.pop(context, _action);
    return Future.value(false);
  }
}
