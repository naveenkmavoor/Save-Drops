import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sed/models/auth.dart';
import 'package:sed/models/main.dart';

class Accountpage extends StatefulWidget {
  final MainModel model;
  Accountpage(this.model);
  @override
  _AccountpageState createState() => _AccountpageState();
}

class _AccountpageState extends State<Accountpage> {
  TextStyle textstyle = TextStyle(
      textBaseline: TextBaseline.alphabetic,
      wordSpacing: 3,
      fontWeight: FontWeight.w300,
      fontSize: 17,
      color: Colors.white);
  double deviceWidth;
  bool ustatus = true,
      estatus = true,
      pstatus = true,
      nstatus = true,
      cstatus = true;
  TextEditingController _controller = TextEditingController();
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  Map<String, dynamic> userval = {};
  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width * 0.90;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
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
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Material(
                            color: Colors.transparent,
                            child: IconButton(
                              icon: Icon(Icons.close),
                              color: Colors.white,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Save Drops',
                        style: TextStyle(
                            fontFamily: 'Angeline', fontSize: 50, height: 3),
                      ),
                      Text(
                        widget.model.updateMode == UpdateMode.NameEmail
                            ? 'Update your Account Details'
                            : 'Update Account Password',
                        style: TextStyle(
                            height: 8,
                            fontWeight: FontWeight.w300,
                            fontSize: 18),
                      ),
                      SizedBox(height: 12),
                      widget.model.updateMode == UpdateMode.NameEmail
                          ? _buildusername()
                          : _buildOldPassword(),
                      SizedBox(
                        height: 20,
                      ),
                      widget.model.updateMode == UpdateMode.NameEmail
                          ? _buildemail()
                          : _buildNewPassword(),
                      SizedBox(
                        height: 20,
                      ),
                      widget.model.updateMode == UpdateMode.NameEmail
                          ? Container()
                          : _buildConfirmPassword(),
                      SizedBox(
                        height: 20,
                      ),
                      Builder(
                        builder: (BuildContext context) {
                          return _submitButton(widget.model, context);
                        },
                      )
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
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
        initialValue: widget.model.uname,
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
        initialValue: widget.model.user.email,
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

  Widget _buildOldPassword() {
    return Container(
      width: deviceWidth * 0.90,
      height: 50,
      decoration: BoxDecoration(
          border:
              Border.all(color: pstatus ? Colors.white : Colors.red, width: 1),
          borderRadius: BorderRadius.circular(30)),
      child: TextFormField(
        onTap: () {
          setState(() {
            pstatus = true;
          });
        },
        onSaved: (String value) {
          userval['Password'] = value;
          if (value.isEmpty || value.length < 6) {
            pstatus = false;
          } else {
            pstatus = true;
          }
        },
        style: textstyle,
        textAlign: TextAlign.center,
        cursorColor: Colors.white,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Current Password',
            hintStyle: TextStyle(
                fontWeight: FontWeight.w200, fontSize: 20, color: Colors.white),
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
              Border.all(color: pstatus ? Colors.white : Colors.red, width: 1),
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
          print(_controller.text);
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

  Widget _submitButton(model, context) {
    return Material(
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
        onTap: () => _buildSubmit(context),
      ),
    );
  }

  void _buildSubmit(context) async {
    _globalKey.currentState.validate();
    _globalKey.currentState.save;
    Map<String, dynamic> successInformation = {
      'success': false,
      'message': 'Oops! Something is not right.'
    };

    if (ustatus == true &&
        pstatus == true &&
        cstatus == true &&
        pstatus == true &&
        nstatus == true) {
      if (widget.model.updateMode == UpdateMode.NameEmail)
        successInformation = await widget.model
            .updateUserData(userval['name'], userval['Email']);
      else
        successInformation = await widget.model
            .updatePassword(userval['Password'], userval['Newpassword']);
    } else {
      setState(() {});
    }
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(successInformation['message']),
      behavior: SnackBarBehavior.floating,
    ));
  }
}
