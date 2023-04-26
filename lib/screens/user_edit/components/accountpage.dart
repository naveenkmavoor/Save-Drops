import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sed/models/auth.dart';
import 'package:sed/models/main.dart';

class Accountpage extends StatefulWidget {
  final MainModel model;
  Accountpage(this.model);
  @override
  _AccountpageState createState() => _AccountpageState();
}

class _AccountpageState extends State<Accountpage> {
  MainModel _model;
  TextStyle textstyle = TextStyle(
      textBaseline: TextBaseline.alphabetic,
      wordSpacing: 3,
      fontWeight: FontWeight.w300,
      fontSize: 17,
      color: Colors.white);
  double deviceWidth;
  bool ustatus = true, estatus = true, nstatus = true, cstatus = true;
  TextEditingController _controller = TextEditingController();
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  Map<String, dynamic> userval = {};

  @override
  void initState() {
    _model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width * 0.90;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/blue.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: SafeArea(
                  child: Form(
                    key: _globalKey,
                    child: Material(
                      color: Colors.transparent,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.close),
                                color: Colors.white,
                                onPressed: () => Navigator.pop(context),
                              ),
                              _selectPopup()
                            ],
                          ),
                          Text(
                            'Save Drops',
                            style: TextStyle(
                                fontFamily: 'Angeline',
                                fontSize: 50,
                                height: 3),
                          ),
                          Text(
                            _model.updateMode == UpdateMode.NameEmail
                                ? 'Update your Account Details'
                                : 'Update Account Password',
                            style: TextStyle(
                                height: 8,
                                fontWeight: FontWeight.w300,
                                fontSize: 18),
                          ),
                          SizedBox(height: 12),
                          SizedBox(
                            height: 20,
                          ),
                          _model.updateMode == UpdateMode.NameEmail
                              ? _buildusername()
                              : _buildNewPassword(),
                          SizedBox(
                            height: 20,
                          ),
                          _model.updateMode == UpdateMode.NameEmail
                              ? _buildemail()
                              : _buildConfirmPassword(),
                          SizedBox(
                            height: 20,
                          ),
                          Builder(
                            builder: (BuildContext context) {
                              return _submitButton(context);
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            _model.updateMode == UpdateMode.NameEmail
                                ? 'Note : After updating email address you need to login again'
                                : 'Note : After updating password you need to login again',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Widget _selectPopup() => PopupMenuButton<int>(
        color: Colors.black,
        icon: Icon(Icons.more_vert),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text("Delete account"),
          ),
        ],
        onSelected: (value) {
          _showAlertbox();
        },
        offset: Offset(0, 10),
      );

  void _showAlertbox() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text('Warning'),
            content: Text('Are you sure you want to delete this account?'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  _model.removeFromDatabase();
                  _model.deleteAccount();
                },
              ),
              ElevatedButton(
                child: Text('No'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  Widget _buildusername() {
    return Container(
      width: deviceWidth * 0.9,
      height: 50,
      decoration: BoxDecoration(
          border:
              Border.all(color: ustatus ? Colors.white : Colors.red, width: 1),
          borderRadius: BorderRadius.circular(30)),
      child: TextFormField(
        onTap: () {
          setState(() {
            ustatus = true;
          });
        },
        onSaved: (String value) {
          userval['name'] = value;
          if (value.isEmpty || value.length > 16) {
            ustatus = false;
          }
        },
        style: textstyle,
        initialValue: _model.uname,
        textAlign: TextAlign.center,
        cursorColor: Colors.white,
        cursorRadius: Radius.circular(34),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintStyle: TextStyle(
                wordSpacing: 3,
                fontWeight: FontWeight.w200,
                fontSize: 20,
                color: Colors.white),
            border: InputBorder.none),
      ),
    );
  }

  Widget _buildemail() {
    return Container(
      width: deviceWidth * 0.9,
      height: 50,
      decoration: BoxDecoration(
          border:
              Border.all(color: estatus ? Colors.white : Colors.red, width: 1),
          borderRadius: BorderRadius.circular(30)),
      child: TextFormField(
        onTap: () {
          setState(() {
            estatus = true;
          });
        },
        onSaved: (String value) {
          userval['Email'] = value;

          if (value.isEmpty ||
              !RegExp("[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                      "\\@" +
                      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                      "(" +
                      "\\." +
                      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                      ")+")
                  .hasMatch(value)) {
            estatus = false;
          } else {
            estatus = true;
          }
        },
        style: textstyle,
        initialValue: _model.user.email,
        textAlign: TextAlign.center,
        cursorColor: Colors.white,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintStyle: TextStyle(
                wordSpacing: 3,
                fontWeight: FontWeight.w200,
                fontSize: 20,
                color: Colors.white),
            border: InputBorder.none),
      ),
    );
  }

  Widget _buildNewPassword() {
    return Container(
      width: deviceWidth * 0.90,
      height: 50,
      decoration: BoxDecoration(
          border:
              Border.all(color: nstatus ? Colors.white : Colors.red, width: 1),
          borderRadius: BorderRadius.circular(30)),
      child: TextFormField(
        onTap: () {
          setState(() {
            nstatus = true;
          });
        },
        onSaved: (String value) {
          userval['Newpassword'] = value;
          if (value.isEmpty || value.length < 6) {
            nstatus = false;
          } else {
            nstatus = true;
          }
        },
        style: textstyle,
        textAlign: TextAlign.center,
        controller: _controller,
        cursorColor: Colors.white,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'New Password',
            hintStyle: TextStyle(
                fontWeight: FontWeight.w200, fontSize: 20, color: Colors.white),
            border: InputBorder.none),
      ),
    );
  }

  Widget _buildConfirmPassword() {
    return Container(
      width: deviceWidth * 0.90,
      height: 50,
      decoration: BoxDecoration(
          border:
              Border.all(color: cstatus ? Colors.white : Colors.red, width: 1),
          borderRadius: BorderRadius.circular(30)),
      child: TextFormField(
        onTap: () {
          setState(() {
            cstatus = true;
          });
        },
        style: textstyle,
        textAlign: TextAlign.center,
        cursorColor: Colors.white,
        validator: (String value) {
          if (_controller.text != value || _controller.text == '') {
            cstatus = false;
          } else {
            cstatus = true;
          }

          return;
        },
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Confirm Password',
            hintStyle: TextStyle(
                fontWeight: FontWeight.w200, fontSize: 20, color: Colors.white),
            border: InputBorder.none),
      ),
    );
  }

  Widget _submitButton(context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? CircularProgressIndicator()
            : Material(
                elevation: 10,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  highlightColor: Colors.white,
                  splashColor: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: 45,
                    width: deviceWidth * 0.9,
                    alignment: Alignment.center,
                    child: Text('Update'),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xff09A603).withOpacity(0.8)),
                  ),
                  onTap: () => _buildSubmit(context, model),
                ),
              );
      },
    );
  }

  void _buildSubmit(context, model) async {
    _globalKey.currentState.validate();
    _globalKey.currentState.save;
    Map<String, dynamic> successInformation = {
      'success': false,
      'message': 'Oops! Something is not right.'
    };

    _globalKey.currentState.save();
    if (ustatus == true &&
        estatus == true &&
        cstatus == true &&
        nstatus == true) {
      if (model.updateMode == UpdateMode.NameEmail)
        successInformation =
            await model.updateUserData(userval['name'], userval['Email']);
      else
        successInformation = await model.updatePassword(userval['Newpassword']);
    } else {
      setState(() {});
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(successInformation['message']),
      behavior: SnackBarBehavior.floating,
    ));
  }
}
