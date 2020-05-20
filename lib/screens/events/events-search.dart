import 'package:flutter/material.dart';
import 'package:leafer/models/event.dart';
import 'package:leafer/screens/events/event_info.dart';
import 'package:leafer/widgets/loading.dart';

enum SearchType { DATE, KEY_WORDS, LOCATION }

class EventsSearch extends StatefulWidget {
  final SearchType searchType;

  EventsSearch({Key key, @required this.searchType}) : super(key: key);

  @override
  _EventsSearchState createState() => _EventsSearchState(searchType);
}

class _EventsSearchState extends State<EventsSearch> {
  final SearchType _searchType;
  bool _loaded = false;
  List<Event> _foundEvents;

  _EventsSearchState(this._searchType);

  @override
  void initState() {
    super.initState();
    switch (_searchType) {
      case SearchType.DATE:
        searchByDate();
        break;
      case SearchType.KEY_WORDS:
        searchByKeywords();
        break;
      case SearchType.LOCATION:
        searchByLocation();
        break;
    }

    //TODO: remove
    _loaded = true;
    DateTime startDate = new DateTime(2020, 10, 25);
    _foundEvents = [
      Event(
        name: 'Nom Test Flutter',
        description: 'Description de l\'évènement',
        location: '18 rue de la Tamise',
        startDate: startDate,
        endDate: startDate.add(Duration(hours: 4)),
        price: 0,
        maxPeople: 10,
        latitude: 48.2121,
        longitude: 2.0654,
      )
    ];
  }

  void searchByDate() async {}

  void searchByKeywords() async {}

  void searchByLocation() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recherche'),
      ),
      body: _buildScreen(),
    );
  }

  /// Builds the body of the screen
  Widget _buildScreen() {
    if (!this._loaded)
      return Loading();
    else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // TODO: display according to search type
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Text_temp'),
            ),
            Expanded(child: _buildList()),
          ],
        ),
      );
    }
  }

  /// Builds the list view of found events
  ListView _buildList() {
    return ListView.builder(
      itemCount: _foundEvents.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/event.jpg'),
            ),
            title: Text(_foundEvents[index].name),
            subtitle: Text(_foundEvents[index].location),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventInfo(
                    event: _foundEvents[index],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
