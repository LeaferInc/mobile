import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:leafer/models/event.dart';
import 'package:leafer/pages/events/event-form.dart';
import 'package:leafer/services/event-service.dart';
import 'package:leafer/widgets/event-card.dart';
import 'package:random_string/random_string.dart';

import 'event-info.dart';

/// This class shows the list of all events
class EventsList extends StatefulWidget {
  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  List<Event> _events;
  List<Event> _incomingEvents;
  List<Event> _joinedEvents;

  @override
  void initState() {
    super.initState();
    _getEvents();
    _getIncomingEvents();
    _getJoinedEvents();
  }

  /// Get all events
  void _getEvents() async {
    List<Event> data = await EventService.getEvents();
    print('Get events');
    setState(() {
      _events = data;
    });
  }

  /// Get incoming events
  void _getIncomingEvents() async {
    List<Event> data = await EventService.getIncomingEvents();
    print('Get incoming');
    setState(() {
      _incomingEvents = data;
    });
  }

  /// Get joined events
  void _getJoinedEvents() async {
    List<Event> data = await EventService.getJoinedEvents();
    print('Get joined');
    setState(() {
      _joinedEvents = data;
    });
  }

  /// True if the data have been loaded
  bool _isLoaded() {
    return _incomingEvents != null && _joinedEvents != null && _events != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Événements'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildScreen(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Event result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => EventForm()));

          if (result != null) {
            _events.add(result);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  /// Builds the screen
  /// Displays a loading widget if all events have not been loaded
  Widget _buildScreen() {
    if (!_isLoaded()) {
      return Center(
        child: SpinKitFadingCube(color: Colors.green[400]),
      );
    } else
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildList('À venir', _incomingEvents),
          _buildList('Je participe', _joinedEvents, joined: true),
          _buildList('Ça m\'intéresse', _events),
        ],
      );
  }

  /// Builds a title and a list view for the given title and events
  Column _buildList(String title, List<Event> events, {bool joined = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 26.0,
          ),
        ),
        events.length == 0
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: Center(
                  child: Text(
                    'Aucun évènement !',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.width * 0.3 + 40.0,
                child: ListView.builder(
                  key: Key(randomString(20)),
                  scrollDirection: Axis.horizontal,
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: EventCard(
                        event: events[index],
                        size: MediaQuery.of(context).size.width * 0.25,
                        onTap: () async {
                          final EntryAction action = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EventInfo(
                                        event: events[index],
                                        joined: joined,
                                      )));

                          // No action done, no need to update screen
                          if (action == EntryAction.NONE) return;

                          if (action == EntryAction.JOINED) {
                            setState(() {
                              _joinedEvents.add(events[index]);
                            });
                          } else {
                            int deleteIndex = -1;
                            for (Event e in _joinedEvents) {
                              deleteIndex++;
                              if (e.id == events[index].id) break;
                            }
                            setState(() {
                              _joinedEvents.removeAt(deleteIndex);
                            });
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
