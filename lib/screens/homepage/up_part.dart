import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sed/models/main.dart';

class UpPart extends StatefulWidget {
  final MainModel model;
  final GlobalKey<ScaffoldState> scaffoldkey;

  UpPart({this.model, this.scaffoldkey});

  @override
  _ColumnWidgetState createState() => _ColumnWidgetState();
}

class _ColumnWidgetState extends State<UpPart> {
  var style = TextStyle(fontSize: 17, fontWeight: FontWeight.w300);
  DatabaseReference _level;
  DatabaseReference _consumed;
  StreamSubscription<Event> _levelSubscription;
  StreamSubscription<Event> _consumedSubscription;
  double waterlevelL = 0.0;
  double consumed = 0.0;
  String dateformat = DateFormat('yyyy-MM-dd').format(DateTime.now());
  @override
  void initState() {
    DatabaseReference _firebaseinstace = FirebaseDatabase.instance
        .reference()
        .child('users')
        .child('${widget.model.user.userid}');
    _consumed = _firebaseinstace.child('flowSensorValue').child(dateformat);
    _level =
        _firebaseinstace.child('waterQuantity').child('WaterlevelPercentage');
    _level.keepSynced(true);

    _levelSubscription = _level.onValue.listen((Event event) {
      print('flow Rate : ${event.snapshot.value}');
      print('executed');
      if (event.snapshot.value != null) waterlevelL = event.snapshot.value;
    }, onError: (Object o) {
      final DatabaseError error = o;
      print(error);
    });

    _consumedSubscription = _consumed.onValue.listen((Event event) {
      print('total water consumes per day : ${event.snapshot.value}');
      setState(() {
        if (event.snapshot.value != null) {
          consumed = event.snapshot.value;
          double convertedvalue = (consumed / 1000) * 6; // 6rs for 1kL
          widget.model.waterConsumed['todayprice'] =
              num.parse(convertedvalue.toStringAsFixed(2));
        }
      });
    }, onError: (Object o) {
      final DatabaseError error = o;
      setState(() {
        print(error);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _levelSubscription.cancel();
    _consumedSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/menuicons.svg', //style attribute
                    semanticsLabel: 'Menu',
                  ),
                  onPressed: () {
                    widget.scaffoldkey.currentState.openDrawer();
                  },
                ),
              ),
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                child: IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 9, bottom: 10),
            child: Text(
              '${widget.model.uname}',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, bottom: 50),
            child: Text(
              '3 Monitered Devices',
              style: style,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Icon(
                FontAwesomeIcons.water,
                size: 30,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                waterlevelL.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 20,
                ),
              ), 
              Text(
                '%',
                style: TextStyle(height: -1),
              ),
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.local_drink,
                size: 30,
              ),
              Text(consumed.toStringAsFixed(1), style: TextStyle(fontSize: 20)),
              Text(
                'L/DAY',
                style: TextStyle(height: -1),
              ),
              SizedBox(
                width: 20,
              ),
              Provider.of<DataConnectionStatus>(context) ==
                      DataConnectionStatus.connected
                  ? Row(
                      children: <Widget>[
                        Icon(
                          Icons.lock,
                          color: Color(0xff1FFF00),
                          size: 30,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text('Online', style: TextStyle(fontSize: 20)),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(
                          Icons.lock_open,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text('Offline', style: TextStyle(fontSize: 20)),
                      ],
                    ),
              SizedBox(
                width: 10,
              )
            ],
          )
        ],
      ),
    );
  }
}
