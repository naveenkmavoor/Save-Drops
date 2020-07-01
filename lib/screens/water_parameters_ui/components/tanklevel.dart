import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sed/ui_widgets/circle_progress.dart';

import '../../../models/main.dart';

class TankLevel extends StatefulWidget {
  final MainModel model;
  TankLevel(this.model);
  @override
  _TankLevelState createState() => _TankLevelState();
}

class _TankLevelState extends State<TankLevel>
    with SingleTickerProviderStateMixin {
  AnimationController progressController;
  Animation animation;
  int waterlevel = 0;
  double absolutewatervalue = 0.0;
  int tankHeight = 0;
  int tankCapacity = 0;
  bool _isActive = false;
  TextStyle style = TextStyle(
      fontSize: 20,
      height: 2,
      fontWeight: FontWeight.w300,
      color: Colors.white.withOpacity(0.7));
  String dateData = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
  @override
  void initState() {
    widget.model.firebaseinstace
        .child('waterTankCapacity')
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        tankCapacity = snapshot.value;
      }
      print(snapshot.value);
    });
    widget.model.firebaseinstace
        .child('tankHeight')
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        _isActive = true; // Ultrasonic sensor is active
        tankHeight = snapshot.value;
      }
      setState(() {});
      print(snapshot.value);
    });
    widget.model.firebaseinstace
        .child('waterQuantity')
        .child('WaterlevelPercentage')
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null && snapshot.value != 0) {
        waterlevel = snapshot.value;
        absolutewatervalue = num.parse(waterlevel.toStringAsFixed(1));
        progressController = AnimationController(
            vsync: this, duration: Duration(milliseconds: 1000));
        print('waterlevel :$absolutewatervalue');
        animation = Tween<double>(begin: 0, end: absolutewatervalue)
            .animate(progressController)
              ..addListener(() {
                setState(() {
                  waterlevel < 10 || tankHeight == 0
                      ? _isActive = false
                      : _isActive = true;
                });
              });
        print('animation value ${animation}');
        progressController.forward();
      }
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
          padding: const EdgeInsets.only(left: 20.0, bottom: 8),
          child: Text(
            'Tank Status',
            style: TextStyle(
                fontWeight: FontWeight.w300, fontSize: 30.0, height: 2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 5),
          child: Row(
            children: <Widget>[
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: _isActive ? Color(0xff1FFF00) : Colors.red),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                _isActive ? '1 Active Sensor' : 'No Active Sensor',
                style: TextStyle(fontWeight: FontWeight.w300),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 60.0,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black,
              ),
              height: 500,
              width: 350,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          height: 110,
                          width: 160,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: <Widget>[
                              Text('Tank Capacity', style: style),
                              Text(
                                '$tankCapacity L',
                                style: style,
                              )
                            ],
                          )),
                      Container(
                          height: 110,
                          width: 160,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: <Widget>[
                              Text('Tank Height', style: style),
                              Text(
                                '$tankHeight cm',
                                style: style,
                              )
                            ],
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text('Water level present in tank( % ) ', style: style),
                  waterlevel == 0.0
                      ? Container(
                          width: 200,
                          height: 200,
                          child: Center(
                            child: Text(
                              "$absolutewatervalue%",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : CustomPaint(
                          foregroundPainter: CircleProgress(animation
                              .value), // this will add custom painter after child
                          child: Container(
                            width: 200,
                            height: 200,
                            child: Center(
                              child: Text(
                                "$absolutewatervalue%",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(height: 40),
                  Text('last updated ${dateData}'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
