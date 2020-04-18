import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:leafer/models/event.dart';
import 'package:leafer/services/event-service.dart';
import 'package:leafer/services/utils.dart';

class EventForm extends StatefulWidget {
  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Event _createdEvent;
  bool _isSending;

  @override
  void initState() {
    super.initState();
    _isSending = false;

    DateTime tomorrow = DateTime.now().add(Duration(days: 1));
    tomorrow = tomorrow.subtract(Duration(minutes: tomorrow.minute));
    _createdEvent = Event(
        name: 'Nom Test Flutter',
        description: 'Description de l\'évènement',
        location: '18 rue de la Tamise',
        startDate: tomorrow,
        endDate: tomorrow.add(Duration(hours: 4)),
        price: 0,
        maxPeople: 10,
        latitude: 48,
        longitude: 6);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Événements'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Nom',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Un nom original',
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                initialValue: _createdEvent.name,
                maxLines: 1,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Entrez un nom';
                  }
                  return null;
                },
                onSaved: (value) => _createdEvent.name = value,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              SizedBox(height: 10.0),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Une description',
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                initialValue: _createdEvent.description,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Entrez une description';
                  }
                  return null;
                },
                onSaved: (value) => _createdEvent.description = value,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              SizedBox(height: 10.0),
              Text(
                'Adresse',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: '17, rue ...',
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                initialValue: _createdEvent.location,
                onChanged: (value) {
                  // TODO: query locations
                  //print(value);
                  _createdEvent.location = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Entrez un lieu';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              SizedBox(height: 10.0),
              Text(
                'Début',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              _buildDateInput(
                  context: context,
                  initialDate: _createdEvent.startDate,
                  isStart: true),
              SizedBox(height: 10.0),
              Text(
                'Fin',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              _buildDateInput(
                  context: context,
                  initialDate: _createdEvent.endDate,
                  isStart: false),
              SizedBox(height: 10.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: Text(
                        'Prix (€)',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Text(
                        'Max. Places',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: '5',
                          hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        initialValue: _createdEvent.price.toString(),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          try {
                            double nb = double.parse(value);
                            if (nb < 0) return 'Nombre incorrect';
                          } on FormatException {
                            return 'Nombre incorrect';
                          }
                          return null;
                        },
                        onSaved: (value) =>
                            _createdEvent.price = double.parse(value),
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: '20',
                          hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        initialValue: _createdEvent.price.toString(),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          try {
                            int nb = int.parse(value);
                            if (nb < 0) return 'Prix incorrect';
                          } on FormatException {
                            return 'Prix incorrect';
                          }
                          return null;
                        },
                        onSaved: (value) =>
                            _createdEvent.maxPeople = int.parse(value),
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate() && !_isSending) {
                        _isSending = true;
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text('Ajout en cours...')));

                        _formKey.currentState.save();

                        Event created = await EventService.saveEvent(_createdEvent);
                        Navigator.pop(context, created);
                        _isSending = false;
                      }
                    },
                    elevation: 0.0,
                    child: Text('Créer')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Return a Row containing an input for the Date and another for the Time
  /// `isStart` true if the field relates to the start date of the event,
  /// otherwise it relates to the end date
  Row _buildDateInput(
      {BuildContext context, DateTime initialDate, bool isStart = true}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                isStart ? 0.0 : 8.0, 0.0, isStart ? 8.0 : 0.0, 0.0),
            child: DateTimeField(
              format: Utils.dateFormat,
              initialValue: initialDate,
              textInputAction: TextInputAction.next,
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                  context: context,
                  firstDate: DateTime.now().add(Duration(hours: 4)),
                  initialDate: currentValue ?? initialDate,
                  lastDate: DateTime.now().add(Duration(days: 365)),
                  locale: Locale('fr'),
                );
              },
              onSaved: (value) {
                if (isStart) {
                  _createdEvent.startDate = Utils.updateDate(
                      _createdEvent.startDate,
                      year: value.year,
                      month: value.month,
                      day: value.day);
                } else {
                  _createdEvent.endDate = Utils.updateDate(
                      _createdEvent.endDate,
                      year: value.year,
                      month: value.month,
                      day: value.day);
                }
              },
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
            child: DateTimeField(
              initialValue: initialDate,
              format: Utils.timeFormat,
              textInputAction: TextInputAction.next,
              onShowPicker: (context, currentValue) async {
                final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(initialDate));
                return DateTimeField.convert(time);
              },
              onSaved: (value) {
                if (isStart) {
                  _createdEvent.startDate = Utils.updateDate(
                      _createdEvent.startDate,
                      hour: value.hour,
                      minute: value.minute);
                } else {
                  _createdEvent.endDate = Utils.updateDate(
                      _createdEvent.endDate,
                      hour: value.hour,
                      minute: value.minute);
                }
              },
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            ),
          ),
        ),
      ],
    );
  }
}
