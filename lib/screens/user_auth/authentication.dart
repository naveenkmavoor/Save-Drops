import 'package:flutter/material.dart';
import 'package:sed/models/auth.dart';
import 'package:sed/models/main.dart';
import 'dart:ui';
import 'package:scoped_model/scoped_model.dart';

class Authentication extends StatefulWidget {
  @override
  _HomePagesState createState() => _HomePagesState();
}

class _HomePagesState extends State<Authentication> {
  final GlobalKey<FormState> _newkey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  Map<String, String> userval = {'name': null, 'Email': null, 'Password': null};
  bool emailvalidator = false;
  AuthMode _authMode = AuthMode.Login;
  double newWidth;
  TextStyle textstyle = TextStyle(
      textBaseline: TextBaseline.alphabetic,
      wordSpacing: 3,
      fontWeight: FontWeight.w300,
      fontSize: 17,
      color: Colors.white);
  bool estatus = true, pstatus = true, cstatus = true, ustatus = true;
  @override
  void initState() {
    print('authentication executed');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    newWidth = MediaQuery.of(context).orientation == Orientation.portrait
        ? deviceWidth * 0.80
        : deviceWidth * 0.5;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Container(
              padding: EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/blue.jpg'), fit: BoxFit.cover),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Form(
                  key: _newkey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Save Drops',
                          style: TextStyle(
                            fontFamily: 'Angeline',
                            fontSize: 50,
                            height: 2,
                          ),
                        ),
                        Text(
                          _authMode == AuthMode.Signup ? 'SignUp' : "Login",
                          style: TextStyle(
                              height: 6,
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        _authMode == AuthMode.Login
                            ? Container()
                            : _buildUsername(),
                        SizedBox(
                          height: 20,
                        ),
                        _buildEmail(),
                        SizedBox(
                          height: 20,
                        ),
                        _buildPassword(),
                        SizedBox(
                          height: 20,
                        ),
                        _authMode == AuthMode.Signup
                            ? _buildConfirmPassword()
                            : Container(),
                        SizedBox(
                          height: 20,
                        ),
                        _buildLogin(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                              onPressed: () {
                                _passwordresetemail();
                              },
                            ),
                            Text(
                              "|",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            ElevatedButton(
                              child: Text(
                                  _authMode == AuthMode.Login
                                      ? 'SignUp'
                                      : 'Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400)),
                              onPressed: () {
                                _newkey.currentState.reset();
                                _controller.clear();
                                estatus = true;
                                pstatus = true;
                                cstatus = true;
                                ustatus = true;
                                setState(() {
                                  _authMode = _authMode == AuthMode.Login
                                      ? AuthMode.Signup
                                      : AuthMode.Login;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  void _passwordresetemail() => Navigator.pushNamed(context, '/resetpassword');

  Widget _buildUsername() => Container(
        width: newWidth * 0.90,
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(
                color: ustatus ? Colors.white : Colors.red, width: 1),
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
          textAlign: TextAlign.center,
          cursorColor: Colors.white,
          cursorRadius: Radius.circular(34),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: 'Username',
              alignLabelWithHint: true,
              hintStyle: TextStyle(
                  wordSpacing: 3,
                  fontWeight: FontWeight.w200,
                  fontSize: 20,
                  color: Colors.white),
              border: InputBorder.none),
        ),
      );

  Widget _buildEmail() {
    return Container(
      width: newWidth * 0.90,
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
        textAlign: TextAlign.center,
        cursorColor: Colors.white,
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
    );
  }

  Widget _buildPassword() {
    return Container(
      width: newWidth * 0.90,
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
        controller: _controller,
        cursorColor: Colors.white,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(
                fontWeight: FontWeight.w200, fontSize: 20, color: Colors.white),
            border: InputBorder.none),
      ),
    );
  }

  Widget _buildConfirmPassword() {
    return Container(
      width: newWidth * 0.90,
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

  void _submitButton(MainModel model, context) async {
    _newkey.currentState.validate();

    _newkey.currentState.save();
    Map<String, dynamic> successInformation = {
      'success': false,
      'message': 'Oops! Something is not right.'
    };
    print('$estatus , $pstatus , $cstatus');

    if (estatus && pstatus && cstatus && ustatus) {
      successInformation = await model.authenticate(
          userval['Email'], userval['Password'], _authMode, userval['name']);
      print(userval['Email']);
    } else {
      setState(() {});
    }

    if (successInformation['message'] == 'sent') {
      model.verificationlinksend = true;
      model.email = userval['Email'];
      Navigator.pushReplacementNamed(context, '/resetpassword');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(successInformation['message']),
      ));
    }
  }

  Widget _buildLogin() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return model.isLoading
          ? CircularProgressIndicator()
          : Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(30),
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                splashColor: Color(0xff1FFF00),
                highlightColor: Colors.white,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    _authMode == AuthMode.Login ? 'Login' : 'Signup',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  width: newWidth * 0.9,
                  height: 45,
                  decoration: BoxDecoration(
                      color: Color(0xff09A603).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(30),
                      border: null),
                ),
                onTap: () => _submitButton(model, context),
              ),
            );
    });
  }
}
