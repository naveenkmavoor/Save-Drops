import 'package:flutter/material.dart';
import 'package:sed/models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class Logout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListTile(
          title: Text('Logout'),
          leading: Icon(Icons.exit_to_app),
          onTap: () {
            model.logout();
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
