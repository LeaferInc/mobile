import 'package:flutter/material.dart';
import 'package:leafer/models/event.dart';

class EventCard extends StatefulWidget {
  final Event event;
  final double size;
  final VoidCallback onTap;

  EventCard(
      {Key key,
      @required this.event,
      @required this.size,
      @required this.onTap})
      : super(key: key);

  @override
  _EventCardState createState() => _EventCardState(event, size, onTap);
}

class _EventCardState extends State<EventCard> {
  final Event _event;
  final double _size;
  final VoidCallback _onTap;

  _EventCardState(this._event, this._size, this._onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      child: SizedBox(
        width: _size,
        height: _size + 40.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image(
                image: MemoryImage(_event.picture),
                width: _size,
                height: _size - 10.0,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              _event.name,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
            ),
            Text(
              _event.location,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
