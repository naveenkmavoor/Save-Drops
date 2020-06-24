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
  final today = DateTime.now();
  @override
  void initState() {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .reference()
        .child('users')
        .child('${widget.model.user.userid}')
        .child('flowSensorValue');
    databaseReference.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> value = snapshot.value;

      print('snapshot value : ${snapshot.value}');
      value.forEach((dynamic keyname, dynamic data) {
        DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(keyname);
        datevalue.add(DataPoint<DateTime>(xAxis: tempDate, value: data));
        print('keyname : $keyname, value :$data');
      });
      setState(() {});
    });
    super.initState();
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
                onPressed: () =>Navigator.pop(context),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: IconButton( 
                icon: Icon(
                  Icons.settings,
                ),
                onPressed: () =>Navigator.pushNamed(context, '/settings'),
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
                  color: Color(0xff1FFF00),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text('Healthy')
            ],
          ),
        ),
        Center(
          child: Container( 
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(20)),
            height: 100,
            width: 300,
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '1.2 L/s',
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
