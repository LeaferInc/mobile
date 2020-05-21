import 'package:flutter/material.dart';
import 'package:leafer/models/event.dart';
import 'package:leafer/screens/events/event_form.dart';
import 'package:leafer/screens/events/events-search.dart';
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

  List<Event> _events;
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
    _getEvents();
    _getIncomingEvents();
    _getJoinedEvents();
  }

  /// Get all events
  void _getEvents() async {
    List<Event> data = await EventService.getEvents();
    setState(() {
      // TODO: get favorites
      _events = data;
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
    return _incomingEvents != null && _joinedEvents != null && _events != null;
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
                _events.add(result);
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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildList(title: 'À venir', events: _incomingEvents),
          _buildList(
              title: 'Je participe', events: _joinedEvents, joined: true),
          _buildList(title: 'Ça m\'intéresse', events: _events),
        ],
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
                        size: MediaQuery.of(context).size.width * 0.25,
                        onTap: () async {
                          final EntryAction action = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventInfo(
                                event: events[index],
                                joined: joined,
                              ),
                            ),
                          );

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
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text('Invalid action menu'),
              ));
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
