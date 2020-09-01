import 'package:flutter/material.dart';
import 'package:leafer/models/event.dart';
import 'package:leafer/screens/events/event_form.dart';
import 'package:leafer/screens/events/events_search.dart';
import 'package:leafer/services/event_service.dart';
import 'package:leafer/widgets/event_card.dart';
import 'package:leafer/widgets/loading.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:random_string/random_string.dart';

import 'event_info.dart';

/// This class shows the list of all events
class EventsList extends StatefulWidget {
  static const String TITLE = 'Événements';

  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchKey = GlobalKey();

  List<Event> _organizedEvents;
  List<Event> _incomingEvents;
  List<Event> _joinedEvents;

  final List<String> _searchMenuItems = const <String>[
    'Par date',
    'Par mots-clés',
    'Proches de moi',
  ];

  @override
  void initState() {
    super.initState();
    _getOrganizedEvents();
    _getIncomingEvents();
    _getJoinedEvents();
  }

  /// Get all events
  void _getOrganizedEvents() async {
    List<Event> data = await EventService.getOrganizedEvents();
    setState(() {
      _organizedEvents = data;
    });
  }

  /// Get incoming events
  void _getIncomingEvents() async {
    List<Event> data = await EventService.getIncomingEvents();
    setState(() {
      _incomingEvents = data;
    });
  }

  /// Get joined events
  void _getJoinedEvents() async {
    List<Event> data = await EventService.getJoinedEvents();
    setState(() {
      _joinedEvents = data;
    });
  }

  /// True if the data have been loaded
  bool _isLoaded() {
    return _incomingEvents != null &&
        _joinedEvents != null &&
        _organizedEvents != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(EventsList.TITLE),
        actions: <Widget>[
          IconButton(
            key: _searchKey,
            icon: Icon(Icons.search),
            onPressed: () => _showSearchMenu(context),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final Event result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EventForm()));

              if (result != null) {
                _organizedEvents.add(result);
                _incomingEvents.add(result);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildScreen(),
      ),
    );
  }

  /// Builds the screen
  /// Displays a loading widget if all events have not been loaded
  Widget _buildScreen() {
    if (!_isLoaded()) {
      return Loading();
    } else
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildList(title: 'À venir', events: _incomingEvents),
            _buildList(
                title: 'Je participe', events: _joinedEvents, joined: true),
            _buildList(title: 'Évènements organisés', events: _organizedEvents),
          ],
        ),
      );
  }

  /// Builds a title and a list view for the given title and events
  Column _buildList(
      {@required String title,
      @required List<Event> events,
      bool joined = false}) {
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
                height: MediaQuery.of(context).size.width * 0.3 + 42.0,
                child: ListView.builder(
                  key: Key(randomString(20)),
                  scrollDirection: Axis.horizontal,
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: EventCard(
                        event: events[index],
                        //size: MediaQuery.of(context).size.width * 0.25,
                        size: 60.0,
                        onTap: () async {
                          final EventAction action = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventInfo(
                                eventId: events[index].id,
                              ),
                            ),
                          );

                          switch (action) {
                            case EventAction.JOINED:
                              setState(() {
                                _joinedEvents.add(events[index]);
                              });
                              break;
                            case EventAction.LEFT:
                              int deleteIndex = _indexOfEvent(
                                  eventId: events[index].id,
                                  list: _joinedEvents);
                              setState(() {
                                _joinedEvents.removeAt(deleteIndex);
                              });
                              break;
                            case EventAction.DELETED:
                              // Event deleted
                              int deleteJoinedIndex = _indexOfEvent(
                                  eventId: events[index].id,
                                  list: _joinedEvents);
                              int deleteIncomingIndex = _indexOfEvent(
                                  eventId: events[index].id,
                                  list: _incomingEvents);
                              int deleteAllIndex = _indexOfEvent(
                                  eventId: events[index].id,
                                  list: _organizedEvents);

                              setState(() {
                                if (deleteJoinedIndex >= 0)
                                  _joinedEvents.removeAt(deleteJoinedIndex);
                                if (deleteIncomingIndex >= 0)
                                  _incomingEvents.removeAt(deleteIncomingIndex);
                                if (deleteAllIndex >= 0)
                                  _organizedEvents.removeAt(deleteAllIndex);
                              });
                              break;
                            case EventAction.NONE:
                            // No action done, no need to update screen
                            default:
                              return;
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

  /// Returns the index of the event in the list
  /// Or -1 if not found
  int _indexOfEvent({@required int eventId, @required List<Event> list}) {
    bool found = false;
    int index = -1;

    for (Event e in list) {
      index++;
      if (e.id == eventId) {
        found = true;
        break;
      }
    }

    return found ? index : -1;
  }

  /// Displays a search dialog to start a Search-for-Events-Activity
  void _showSearchMenu(BuildContext context) {
    PopupMenu(
        context: context,
        items: _searchMenuItems
            .map((String title) => MenuItem(
                  title: title,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                ))
            .toList(),
        onClickMenu: (MenuItemProvider item) {
          int index = _searchMenuItems.indexOf(item.menuTitle);

          SearchType searchType;
          switch (index) {
            case 0:
              searchType = SearchType.DATE;
              break;
            case 1:
              searchType = SearchType.KEY_WORDS;
              break;
            case 2:
              searchType = SearchType.LOCATION;
              break;
            default:
              print('Invalid action menu');
              return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventsSearch(
                searchType: searchType,
              ),
            ),
          );
        }).show(widgetKey: _searchKey);
  }
}
