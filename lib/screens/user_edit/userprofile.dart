import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:sed/models/main.dart';
import 'package:sed/ui_widgets/image_widget.dart';

class UserProfile extends StatefulWidget {
  final MainModel model;
  UserProfile(this.model);
  @override
  _UserprofileState createState() => _UserprofileState();
}

class _UserprofileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Material(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Profile',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w300, height: 2),
              ),
              SizedBox(
                height: 40,
              ),
              Image_Widget(),
              Text(
                widget.model.uname,
                style: TextStyle(
                    height: 3, fontSize: 20, fontWeight: FontWeight.w300),
              ),
              Text(
                widget.model.user.email,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                    color: Colors.white54),
              ),
              SizedBox(
                height: 30,
              ),
              Divider(),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/settings'),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  height: 70,
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text(
                      'Settings',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w300),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
