import 'dart:ui'; 
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sed/models/main.dart';

class ResetPassword extends StatefulWidget {
  final MainModel model;
  ResetPassword(this.model);
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();  
  String email;
  bool sendlink = false;
  double newWidth;
  TextStyle textstyle = TextStyle(
      textBaseline: TextBaseline.alphabetic,
      wordSpacing: 1,
      fontWeight: FontWeight.w300,
      fontSize: 17,
      color: Colors.white);
  bool estatus = true;
  @override
  void initState() {
    sendlink = widget.model.verificationlinksend;
    email = widget.model.email;
    print(sendlink);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    newWidth = MediaQuery.of(context).orientation == Orientation.portrait
        ? deviceWidth * 0.80
        : deviceWidth * 0.5;
    return WillPopScope(
      onWillPop: () {
        print('backbutton pressed');
        widget.model.verificationlinksend = false;
        Navigator.pushReplacementNamed(context, '/');
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: deviceWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/blue.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: SafeArea(
                child: sendlink
                    ? _buildLinkSend(deviceWidth)
                    : _buildNoLinkSend(deviceWidth),
              )),
        ),
      ),
    );
  }

  Widget _buildLinkSend(devicewidth) => Column(children: <Widget>[
        Row(
          children: <Widget>[
            Material(
                color: Colors.transparent,
                child: IconButton(
                  splashColor: Colors.lightBlue,
                  icon: Icon(Icons.close),
                  iconSize: 30,
                  onPressed: () {
                    widget.model.verificationlinksend = false;
                    Navigator.pushReplacementNamed(context, '/');
                  },
                )),
          ],
        ),
        SizedBox(
          height: 60,
        ),
        Text('Check your inbox',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300)),
        SizedBox(
          height: 35,
        ),
        Text(
          'Click the verification link we just sent.',
          style: textstyle,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Email: $email',
          style: textstyle,
        ),
        
      ]);

  Widget _buildNoLinkSend(deviceWidth) => Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Material(
                  color: Colors.transparent,
                  child: IconButton(
                    splashColor: Colors.lightBlue,
                    icon: Icon(Icons.arrow_back),
                    iconSize: 30,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Text('Enter your email id for password reset.', style: textstyle),
          SizedBox(
            height: 35,
          ),
          _buildTextFormField(),
          SizedBox(
            height: 20,
          ),
          _buildButton()
        ],
      );
  Widget _buildTextFormField() => Form(
        key: _formkey,
        child: Container(
          width: newWidth * 0.90,
          height: 45,
          decoration: BoxDecoration(
              border: Border.all(
                  color: estatus ? Colors.white : Colors.red, width: 1),
              borderRadius: BorderRadius.circular(30)),
          child: TextFormField(
            onSaved: (String value) {
              email = value;

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
            onTap: () {
              setState(() {
                estatus = true;
              });
            },
            textAlign: TextAlign.center,
            cursorColor: Colors.white,
            cursorRadius: Radius.circular(34),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                hintText: 'Email Address',
                alignLabelWithHint: true,
                hintStyle: TextStyle(
                    wordSpacing: 3,
                    fontWeight: FontWeight.w200,
                    fontSize: 20,
                    color: Colors.white),
                border: InputBorder.none),
          ),
        ),
      );

  Widget _buildButton() => ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return model.isLoading
              ? CircularProgressIndicator( 
                )
              : Material(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    splashColor: Colors.white,
                    child: Container(
                      alignment: Alignment.center,
                      width: newWidth * 0.9,
                      height: 40,
                      child: Text(
                        'Ok',
                        style: TextStyle(
                            wordSpacing: 3,
                            fontWeight: FontWeight.w300,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xff09A603).withOpacity(0.8)),
                    ),
                    onTap: () {
                      _buildPress(model, context);
                    },
                  ));
        },
      );

  void _buildPress(model, context) async {
    _formkey.currentState.save();
    String message = 'Email not found.';
    bool success = false;
    if (estatus) {
      success = await model.passwordReset(email);
    } else {
      message = 'Enter valid Email address.';
      setState(() {});
    }

    if (success) {
      setState(() {
        sendlink = true;
      });
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }
  }
}
