import 'dart:async';
import 'dart:ui';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sed/models/main.dart';

class Flowpage extends StatefulWidget {
  final MainModel model;
  Flowpage(this.model);
  @override
  _SubpageState createState() => _SubpageState();
}

List<DataPoint<DateTime>> datevalue = [];

class _SubpageState extends State<Flowpage> {
  String dateData = DateFormat('yyyy-MM-dd').format(DateTime.now());
  StreamSubscription<Event> _flowSubscription;
  double oldValue = 0.0, newValue = 0.0;
  String flowvalue = '0.0';
  bool _isActive = false;
  @override
  void initState() {
    DatabaseReference databaseReference = widget.model.firebaseinstace
        .child('flowSensorValue')
        .child('$dateData');
    _flowSubscription = databaseReference.onValue.listen((Event event) {
      print(event.snapshot.value);

      //Determining the flow rate of water in L/sec through the pipe
      if (event.snapshot.value != null) {
        if (oldValue > event.snapshot.value) oldValue = 0.0;
        newValue = event.snapshot.value - oldValue;
        flowvalue = newValue.toStringAsFixed(1);
        if (oldValue != 0.0)
          setState(() {
            _isActive = true; //shows flow sensor is active
          });
        oldValue = event.snapshot.value;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _flowSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Material(
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.arrowLeft,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(
                  Icons.settings,
                ),
                onPressed: () => Navigator.pushNamed(context, '/settings'),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 15, bottom: 8),
          child: Text(
            'Flow Meter',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 5, bottom: 80),
          child: Row(
            children: <Widget>[
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _isActive ? Color(0xff1FFF00) : Colors.red,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(_isActive ? 'Active' : 'Inactive')
            ],
          ),
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(20)),
            height: 100,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$flowvalue L/s',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
