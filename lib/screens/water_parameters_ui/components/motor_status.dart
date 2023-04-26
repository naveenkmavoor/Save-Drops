import 'dart:async';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sed/models/main.dart';
import 'package:intl/intl.dart';

class MotorStatus extends StatefulWidget {
  final MainModel model;
  MotorStatus(this.model);

  @override
  _ShowpageState createState() => _ShowpageState();
}

class _ShowpageState extends State<MotorStatus> {
  String _motorval = "OFF";
  DatabaseReference motorStatus;
  DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
  String date;
  StreamSubscription<Event> _motorvalSubscription;
  String _animate;
  MainModel _model;
  @override
  void initState() {
    _model = widget.model;
    motorStatus = _model.firebaseinstace.child('motorStatus');
    date = dateFormat.format(DateTime.now());
    _animate = "idle";
    _motorvalSubscription = motorStatus.onValue.listen((Event event) {
      print(event.snapshot.value);
      if (event.snapshot.value == "ON") {
        _motorval = "ON";
        _animate = "on";
      } else {
        _motorval = "OFF";
        _animate = "off";
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _motorvalSubscription.cancel();
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
          padding: const EdgeInsets.only(left: 20.0, bottom: 8),
          child: Text(
            'Motor Status',
            style: TextStyle(
                fontWeight: FontWeight.w300, fontSize: 30.0, height: 2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            top: 5,
          ),
          child: Provider.of<DataConnectionStatus>(context) ==
                  DataConnectionStatus.connected
              ? Row(
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
                    Text('Online')
                  ],
                )
              : Row(
                  children: <Widget>[
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Offline')
                  ],
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black,
              ),
              alignment: Alignment.center,
              height: 300,
              width: 300,
              child: Column(
                children: <Widget>[
                  Text(
                    _motorval,
                    style: TextStyle(fontSize: 30, height: 4),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (Provider.of<DataConnectionStatus>(context,
                                listen: false) ==
                            DataConnectionStatus.connected) {
                          _motorval = _motorval == "ON" ? "OFF" : "ON";
                          _buildAnimate();
                          _addMotorstatus();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text('No internet Connection.'),
                              action: SnackBarAction(
                                label: 'cancel',
                                onPressed: () {},
                              ),
                            ),
                          );
                        }

                        _motorval == "ON" ? _showAlert() : null;
                      });
                    },
                    child: Container(
                      height: 150,
                      child: FlareActor(
                        "assets/switch.flr",
                        fit: BoxFit.contain,
                        animation: _animate,
                      ),
                    ),
                  ),
                  _motorval == "ON"
                      ? Text(
                          'Last Active on ${date}',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.white.withOpacity(0.7)),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _addMotorstatus() async {
    final TransactionResult transactionResult =
        await motorStatus.runTransaction((MutableData mutableData) async {
      mutableData.value = _motorval;
      print('transaction done ${mutableData.value}');
      return mutableData;
    });
    print(transactionResult.committed);
    if (transactionResult.committed) {
      print('SUCESSFULL');
    } else {
      _motorval = _motorval == "ON" ? "OFF" : "ON";
      print('Failed');
      _buildAnimate(); // include network connection
    }
  }

  void _buildAnimate() {
    if (_motorval == "ON") {
      _animate = "on";

      date = dateFormat.format(DateTime.now());
    } else
      _animate = "off";
  }

  void _showAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text('We got you covered :)'),
            content: Text('Motor will shutdown automatically. No worry'),
          );
        });
  }
}
