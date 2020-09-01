import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leafer/models/entrant.dart';
import 'package:leafer/models/event.dart';
import 'package:leafer/models/user.dart';
import 'package:leafer/services/entry_service.dart';
import 'package:leafer/services/event_service.dart';
import 'package:leafer/services/user_service.dart';
import 'package:leafer/widgets/loading.dart';

/// This class shows the details of a single Event
class EventInfo extends StatefulWidget {
  final int eventId;

  EventInfo({Key key, @required this.eventId}) : super(key: key);

  @override
  _EventInfoState createState() => _EventInfoState(eventId);
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
  int _eventId;
  Event _event;
  User _currentUser;

  _EventInfoState(this._eventId);

  @override
  void initState() {
    super.initState();
    _action = EventAction.NONE;

    _getEvent(this._eventId);
    _getCurrentUser();
  }

  /// Gets an event
  void _getEvent(int eventId) async {
    Event data = await EventService.getEventById(_eventId);
    setState(() {
      _event = data;
    });
  }

  /// Gets the current user
  void _getCurrentUser() async {
    User data = await UserService.getCurrentUser();
    setState(() {
      _currentUser = data;
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
          actions: _isOrganizer()
              ? <Widget>[
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
                                int res =
                                    await EventService.deleteEvent(_event.id);
                                Navigator.pop(context);
                                if (res == 401) {
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'Vous n\'êtes pas l\'organisateur de cet évènement'),
                                  ));
                                } else if (res != 200) {
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'Impossible de supprimer l\'évènement'),
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
                ]
              : null,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _event == null || _currentUser == null
              ? Loading()
              : Column(
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
                            padding:
                                const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
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
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
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
                      child: _buildJoining(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Participants: ${_event.entrants.length} (Max: ${_event.maxPeople})',
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      // TODO: child: _event.entrants.length == 0 ? null : ,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  /// Whether or not the currentUser is the organizer
  bool _isOrganizer() {
    return _currentUser != null &&
        _event != null &&
        _currentUser.id == _event.id;
  }

  /// Build a RaisedButton depending on the joined state
  /// No button if the current user is the organizer
  Widget _buildJoining() {
    if (_currentUser == null || _isOrganizer()) {
      print(_currentUser);
      return null;
    } else if (_event.isFinished()) {
      return Text(
        'Cet évènement est terminé',
        style: TextStyle(fontSize: 15.0),
      );
    } else if (_event.entrants.length == _event.maxPeople) {
      return Text(
        'Cet évènement est complet',
        style: TextStyle(fontSize: 15.0),
      );
    } else {
      return RaisedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(_event.joined ? Icons.close : Icons.check),
            Text(_event.joined ? 'Je quitte' : 'Je participe'),
          ],
        ),
        onPressed: () async {
          String infoMessage;
          if (_event.joined) {
            int code = await EntryService.unjoinEvent(_event.id);
            if (code == 200) {
              infoMessage = 'Événement quitté !';
              _event.joined = false;
              _action = EventAction.LEFT;
              _event.entrants.removeWhere((item) => item.id == _currentUser.id);
            } else {
              infoMessage = 'Erreur...';
            }
          } else {
            int code = await EntryService.joinEvent(_event.id);
            if (code == 201) {
              infoMessage = 'Événement rejoint !';
              _event.joined = true;
              _action = EventAction.JOINED;
              _event.entrants.add(new Entrant(
                id: _currentUser.id,
                username: _currentUser.username,
                firstname: _currentUser.firstname,
                lastname: _currentUser.lastname,
              ));
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
    Navigator.pop(context, _action);
    return Future.value(false);
  }
}
