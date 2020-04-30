import 'package:flutter/material.dart';
import 'package:leafer/models/event.dart';
import 'package:leafer/pages/events/event-form.dart';
import 'package:leafer/pages/events/event-info.dart';
import 'package:leafer/services/event-service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// This class shows the list of all events
class EventsList extends StatefulWidget {
  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  List<Event> _events;
  bool _loading;

  @override
  void initState() {
    super.initState();
    _events = [];
    _loading = true;
    _getEvents();
  }

  void _getEvents() async {
    List<Event> data = await EventService.getEvents();
    print(data);
    setState(() {
      _loading = false;
      _events = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Événements'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildScreen()
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

  Widget _buildScreen() {
    if (_loading) {
      return Center(
        child: SpinKitFadingCube(
          color: Colors.green[400]
        ),
      );
    }

    if (_events.isEmpty) {
      return Center(
        child: Text(
          'Aucun évènement !',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16.0
          ),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'À venir',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        Image(
          image: AssetImage('assets/images/event.jpg'),
          height: 50,
        ),
        Text(
          'Ça m\'intéresse',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        RaisedButton(
          child: Text('Remove'),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => EventInfo(event: _events[0])
            ));
          },
        )
      ],
    );
  }
}
