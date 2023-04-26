import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sed/models/auth.dart';
import 'package:sed/models/main.dart';

class Settings extends StatefulWidget {
  final MainModel model;
  Settings(this.model);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/blue.jpg'), fit: BoxFit.cover),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: SafeArea(
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Material(
                          color: Colors.transparent,
                          child: IconButton(
                            icon: Icon(FontAwesomeIcons.arrowLeft),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        SizedBox(
                            width:
                                MediaQuery.of(context).size.width / 2 * 0.55),
                        Text(
                          'Settings',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 20,
                              height: 2),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        widget.model.updateMode = UpdateMode.NameEmail;
                        Navigator.pushNamed(context, '/account');
                      },
                      child: Container(
                        height: 60,
                        child: ListTile(
                          leading: Icon(Icons.account_circle),
                          title: Text(
                            'Account info',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        widget.model.updateMode = UpdateMode.Password;
                        Navigator.pushNamed(context, '/account');
                      },
                      child: Container(
                        height: 60,
                        child: ListTile(
                          leading: Icon(Icons.lock_outline),
                          title: Text(
                            'Update password',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _showAlert();
                      },
                      child: Container(
                        height: 60,
                        child: ListTile(
                          leading: Icon(Icons.delete),
                          title: Text(
                            'Clear history',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void _showAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text('Are you sure you want to clear history?'),
            content:
                Text('Clearing history will permanently erase all your data.'),
            actions: <Widget>[
              ElevatedButton(
                  child: Text('Yes'),
                  onPressed: () {
                    widget.model.removeFromDatabase();
                    Navigator.pop(context);
                  }),
              ElevatedButton(
                child: Text('No'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }
}
