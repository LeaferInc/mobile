import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:leafer/main.dart';
import 'package:leafer/models/event.dart';
import 'package:leafer/pages/event-form.dart';
import 'package:leafer/services/event-service.dart';

class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  List<Event> _events;

  @override
  void initState() {
    super.initState();
    _events = [];
    _getEvents();
  }

  void _getEvents() async {
    List<Event> data = await EventService.getEvents();
    setState(() {
      _events = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build events list');
    print(_events);

    return Scaffold(
      appBar: AppBar(
        title: Text('Événements'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Event result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => EventForm()));

          print("Result: ");
          print(result);
          if (result != null) {
            _events.add(result);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
