import 'dart:async';
import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:leafer/models/event.dart';
import 'package:leafer/screens/events/event_info.dart';
import 'package:leafer/utils/utils.dart';
import 'package:leafer/widgets/loading.dart';
import 'package:permission_handler/permission_handler.dart';

enum SearchType { DATE, KEY_WORDS, LOCATION }

class EventsSearch extends StatefulWidget {
  final SearchType searchType;

  EventsSearch({Key key, this.searchType = SearchType.KEY_WORDS})
      : super(key: key);

  @override
  _EventsSearchState createState() => _EventsSearchState(searchType);
}

class _EventsSearchState extends State<EventsSearch> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  final SearchType _searchType;

  bool _searched = false;
  List<Event> _foundEvents;
  DateTime _searchDate;

  _EventsSearchState(this._searchType);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (_searchType == SearchType.DATE) {
      _searchDate = DateTime.now().add(Duration(hours: 1));
    } else if (_searchType == SearchType.LOCATION) {
      searchByLocation();
    }

    //TODO: remove
    //Timer(Duration(seconds: 4), () => _searched = true);
    _searched = true;
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

  /// Gets the current location
  /// Checks for permissions
  void searchByLocation() async {
    PermissionStatus status = await Permission.location.status;
    if (status.isUndetermined) {
      // Ask permission
      if (!await Permission.location.request().isGranted) {
        await _showErrorDialog(
            text: 'Permission de localisation refusée, recherche impossible');
        Navigator.pop(context);
      }
    }

    // Check Location service is enabled
    if (await Permission.location.serviceStatus.isDisabled) {
      await _showErrorDialog(text: 'Géolocalisation désactivée');
      Navigator.pop(context);
    } else {
      print("Working maybe");
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      print('long: ${position.longitude}, lat: ${position.latitude}');
      // TODO: Search by location
      //_searchEvents(url: '');
    }
  }

  /// Show an error dialog and closes the current screen
  Future<void> _showErrorDialog({@required text}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Recherche impossible'),
        content: Text(text),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Recherche'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ..._buildSearchHeader(),
            SizedBox(height: 10.0),
            ..._buildResultArea(),
          ],
        ),
      ),
    );
  }

  /// Returns the top screen parting depending on the Search Type
  List<Widget> _buildSearchHeader() {
    switch (_searchType) {
      case SearchType.DATE:
        return [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Débutant après le :',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(width: 10.0),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                  child: DateTimeField(
                    format: Utils.dateFormat,
                    initialValue: _searchDate,
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        initialDate: currentValue ?? _searchDate,
                        lastDate: DateTime.now().add(Duration(days: 365)),
                        locale: Locale('fr'),
                      );
                    },
                    onSaved: (value) {
                      _searchDate = Utils.updateDate(_searchDate,
                          year: value.year, month: value.month, day: value.day);
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                  child: DateTimeField(
                    initialValue: _searchDate,
                    format: Utils.timeFormat,
                    onShowPicker: (context, currentValue) async {
                      final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(_searchDate));
                      if (time == null) return currentValue;
                      return DateTimeField.convert(time);
                    },
                    onSaved: (value) {
                      _searchDate = Utils.updateDate(_searchDate,
                          hour: value.hour, minute: value.minute);
                    },
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // TODO: submit
                  print(
                      jsonEncode({'startDate': _searchDate.toIso8601String()}));
                },
              ),
            ],
          ),
        ];
      case SearchType.KEY_WORDS:
        return [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Contenant :',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Nom/Description',
                      hintStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // TODO: submit
                  if (_searchController.text.length > 0) {
                    print(jsonEncode({'keywords': _searchController.text}));
                  }
                },
              ),
            ],
          ),
        ];
      case SearchType.LOCATION:
        return [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Proches de moi',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ];
      default:
        throw new Exception('Search Type `$_searchType` invalid.');
    }
  }

  /// Builds the body of the screen
  /// Shows a loading widget or the results of the search
  List<Widget> _buildResultArea() {
    if (!this._searched)
      return [
        Center(
          child: Loading(),
        ),
      ];
    else {
      return [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Résultats',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        Expanded(child: _buildList()),
      ];
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

  /// Search for events
  // TODO: search
  void _searchEvents({String url}) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text('Recherche en cours...')));

    //_foundEvents = await
    setState(() {});
  }
}
