import 'dart:async';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:sed/class/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth.dart';

class ConnectedModel extends Model {
  User _authUser;
  int timeout = 5;
  bool _isLoading = false;
  Map<String, dynamic> authData = {};
}

class WatervalModel extends ConnectedModel {
  int parameters;

  Map<String, dynamic> waterConsumed = {
    'todayprice': 0.0,
    'thismonthprice': 0.0
  };
}

class UtilityModel extends ConnectedModel {
  bool get isLoading {
    return _isLoading;
  }
}

class UserModel extends ConnectedModel {
  String uname;
  bool verificationlinksend = false;
  String email;
  UpdateMode updateMode;
  DatabaseReference firebaseinstace;
  PublishSubject<bool> _userSubject = PublishSubject();
  Timer _authTimer;

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login, String username = null]) async {
    Map<String, dynamic> returnmessage = {
      'success': false,
      'message': 'Oops! something went wrong.'
    };
    print('username :$username');
    _isLoading = true;
    notifyListeners();
    try {
      authData = {
        'email': email,
        'password': password,
        'returnSecureToken': true
      };
      http.Response response;

      if (mode == AuthMode.Login) {
        response = await http.post(
            'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCATpo1Jvz5cKGoVF7pR9xy-Pz2BuS-8T0',
            body: convert.json.encode(authData),
            headers: {
              'Content-type': 'application/json'
            }).timeout(Duration(seconds: timeout));
      } else {
        //signup the user
        response = await http.post(
            'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCATpo1Jvz5cKGoVF7pR9xy-Pz2BuS-8T0',
            body: convert.json.encode(authData),
            headers: {
              'Content-type': 'application/json'
            }).timeout(Duration(seconds: timeout));
        Map<String, dynamic> responsevalue = convert.json.decode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          //sending email confirmation
          http.Response emailconfirmation = await http.post(
              'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyCATpo1Jvz5cKGoVF7pR9xy-Pz2BuS-8T0',
              body: convert.json.encode({'requestType': 'VERIFY_EMAIL', 'idToken': responsevalue['idToken']}),
              headers: {'Content-type': 'application/json'});
          print(
              'email confirmation :${convert.json.decode(emailconfirmation.body)}');
          returnmessage['message'] = 'sent';
          //setting userprofile
          Map<String, dynamic> uservalue = {
            'idToken': responsevalue['idToken'],
            'displayName': username,
            'photoUrl':
                'https://www.google.com/search?q=water+image&rlz=1C1CHBF_enIN853IN853&sxsrf=ALeKk02_TDr6gfnqiCLAGVka4Xc39YKUEA:1590820547019&tbm=isch&source=iu&ictx=1&fir=HjfDiWWf_bNEkM%253A%252C05VRHkgmXcyWYM%252C_&vet=1&usg=AI4_-kS9tgSeYLe2hb8RHU0IlYWQSBcVpA&sa=X&ved=2ahUKEwjMxOys_NrpAhWMyDgGHaf6AeIQ9QEwBXoECAUQOg#imgrc=HjfDiWWf_bNEkM:',
            'deleteAttribute': 'PHOTO_URL',
            'returnSecureToken': true
          };
          http.Response userProfileUpdateResponse = await http.post(
              'https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyCATpo1Jvz5cKGoVF7pR9xy-Pz2BuS-8T0',
              headers: {'Content-type': 'application/json'},
              body: convert.json.encode(uservalue));
          print(
              'user Profile Update value : ${convert.json.decode(userProfileUpdateResponse.body)}');
          _isLoading = false;
          notifyListeners();
          return returnmessage;
        }
      }

      Map<String, dynamic> responsevalue = convert.json.decode(response.body);

      //check for the http statusCode
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Status code = ${response.statusCode}');

        //verification of email by getting user info
        http.Response emailresponse = await http.post(
            'https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=AIzaSyCATpo1Jvz5cKGoVF7pR9xy-Pz2BuS-8T0',
            body: convert.json.encode({'idToken': responsevalue['idToken']}),
            headers: {'Content-type': 'application/json'});
        print('send email verification');
        print(convert.json.decode(emailresponse.body));
        final Map<String, dynamic> userResponse =
            convert.json.decode(emailresponse.body);
        if (!userResponse['users'][0]['emailVerified']) {
          //check the user email is verified or not
          _isLoading = false;
          notifyListeners();
          returnmessage['message'] = 'email not verified';
          return returnmessage;
        }

        uname = userResponse['users'][0]['displayName'];
        print('username execute: $uname');

        returnmessage['success'] = true;
        returnmessage['message'] = 'authentication successfull.';
        _authUser = User(
            email: email,
            userid: responsevalue['localId'],
            token: responsevalue['idToken']);

        setAuthTimer(int.parse(responsevalue['expiresIn']));
        final DateTime now = DateTime.now();
        final DateTime expiryTime =
            now.add(Duration(seconds: int.parse(responsevalue['expiresIn'])));

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', responsevalue['idToken']);
        prefs.setString('userEmail', email);
        prefs.setString('username', uname);
        prefs.setString('userId', responsevalue['localId']);
        prefs.setString('expiryTime', expiryTime.toIso8601String());
        print('authuser token ${_authUser.userid} ');
        _userSubject.add(true);
        _isLoading = false;
        notifyListeners();
        return returnmessage;
      } else {
        print('status code not 200 :  ${convert.json.decode(response.body)}');
        if (responsevalue['error']['message'] == 'INVALID_PASSWORD') {
          returnmessage['message'] = 'This password is invalid.';
        } else if (responsevalue['error']['message'] == 'EMAIL_NOT_FOUND') {
          returnmessage['message'] = 'This email is not found.';
        } else if (responsevalue['error']['message'] == 'EMAIL_EXISTS') {
          returnmessage['message'] = 'This email already exists.';
        }
      }
    } on TimeoutException {
      print('on timeout exception');
      returnmessage['message'] = 'Timeout error';
    } on SocketException {
      print('on socket exception');
      returnmessage['message'] = 'No internet Connection';
    } on Error {
      print('on Error catch');
    }
    print('if there is error i will execute');
    _isLoading = false;
    notifyListeners();
    return returnmessage;
  }

  void userAutoValidate() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String token = preferences.getString('token');

    final String expiryTime = preferences.getString('expiryTime');
    if (token != null) {
      final DateTime now = DateTime.now();
      final DateTime parseExpiryTime = DateTime.parse(expiryTime);
      if (parseExpiryTime.isBefore(now)) {
        _authUser = null;
        notifyListeners();
        return;
      }
      final String userEmail = preferences.getString('userEmail');
      final String userId = preferences.getString('userId');
      uname = preferences.getString('username');
      print('auto username : $uname');
      _authUser = User(
        email: userEmail,
        token: token,
        userid: userId,
      );
      final int tokenLifespan = parseExpiryTime.difference(now).inSeconds;
      setAuthTimer(tokenLifespan);
      _userSubject.add(true);
      notifyListeners();
    }
  }

  User get user {
    return _authUser;
  }

  void logout() async {
    print('Logout');
    _authUser = null;
    uname = null;
    _authTimer.cancel();
    _userSubject.add(false);
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('token');
    preferences.remove('userEmail');
    preferences.remove('username');
    preferences.remove('userId');
  }

  void setAuthTimer(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }

  Future<bool> passwordReset(String email) async {
    _isLoading = true;
    notifyListeners();
    Map<String, dynamic> responseValue = {
      'requestType': 'PASSWORD_RESET',
      'email': email
    };
    http.Response response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyCATpo1Jvz5cKGoVF7pR9xy-Pz2BuS-8T0',
        headers: {'Content-type': 'application/json'},
        body: convert.json.encode(responseValue));
    print('password reset : ${convert.json.decode(response.body)}');
    responseValue = convert.json.decode(response.body);
    print(response.statusCode);
    _isLoading = false;
    notifyListeners();
    if (response.statusCode != 200) {
      print('email not found!');
      return false;
    }
    return true;
  }

  Future<Map<String, dynamic>> updateUserData(String username, String email,
      [String photoUrl = null]) async {
    _isLoading = true;
    notifyListeners();
    http.Response response;
    Map<String, dynamic> responseValue = {
      'message': 'Failed to update credentials.'
    };
    Map<String, dynamic> updateemail = {
      'idToken': _authUser.token,
      'email': email,
      'returnSecureToken': true
    };
    Map<String, dynamic> uservalue = {
      'displayName': username,
      'idToken': _authUser.token,
      'photoUrl': photoUrl,
      'returnSecureToken': true
    };
    try {
      //Updating userprofile
      response = await http
          .post(
              'https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyCATpo1Jvz5cKGoVF7pR9xy-Pz2BuS-8T0',
              headers: {'Content-type': 'application/json'},
              body: convert.json.encode(uservalue))
          .timeout(Duration(seconds: timeout));

      if (response.statusCode == 200) {
        Map<String, dynamic> responsevalue = convert.json.decode(response.body);
        print('user profile : $responsevalue');

        uname = responsevalue['providerUserInfo'][0]['displayName'];
        print(uname);

        //Updating user email address
        response = await http
            .post(
                'https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyCATpo1Jvz5cKGoVF7pR9xy-Pz2BuS-8T0',
                headers: {'Content-type': 'application/json'},
                body: convert.json.encode(updateemail))
            .timeout(Duration(seconds: timeout));
        updateemail = convert.json.decode(response.body);
        print('updateEmail $updateemail');
        if (response.statusCode != 200) {
          _isLoading = false;
          notifyListeners();
          return {
            'message':
                'User name updated successfully :). Failed to update email :( try again!'
          };
        }
        responseValue = {'message': 'Updated successfully :)'};
        logout();
      }
    } catch (e) {
      print(e);
    }
    _isLoading = false;
    notifyListeners();
    return responseValue;
  }

  Future<Map<String, dynamic>> updatePassword( 
    String newpassword,
  ) async {
    _isLoading = true;
    notifyListeners();
    http.Response response;
    Map<String, dynamic> responseValue = {
      'message': 'Failed to update password.'
    };
    Map<String, dynamic> updatepassword = {
      'idToken': _authUser.token,
      'password': newpassword,
      'returnSecureToken': true
    };

    try {
      response = await http
          .post(
              'https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyCATpo1Jvz5cKGoVF7pR9xy-Pz2BuS-8T0',
              headers: {'Content-type': 'application/json'},
              body: convert.json.encode(updatepassword))
          .timeout(Duration(seconds: timeout));
      updatepassword = convert.json.decode(response.body);
      print('updated password: $updatepassword');
      if (response.statusCode == 200) {
        responseValue = {'message': 'Password updated successfully :)'};
        logout();
      }
    } catch (e) {
      print(e);
    }
    _isLoading = false;
    notifyListeners();
    return responseValue;
  }

  void removeFromDatabase() {
    firebaseinstace.remove();
  }

  Future<bool> deleteAccount() async {
    Map tokenvalue = {'idToken': _authUser.token};
    try {
      http.Response response = await http
          .post(
              'https://identitytoolkit.googleapis.com/v1/accounts:delete?key=AIzaSyCATpo1Jvz5cKGoVF7pR9xy-Pz2BuS-8T0',
              headers: {'Content-type': 'application/json'},
              body: convert.json.encode(tokenvalue))
          .timeout(Duration(seconds: timeout));

      print(response.body);
      if (response.statusCode == 200) {
        logout();
        return true;
      }
      return false;
    } catch (e) {
      print('exeception');
      return false;
    }
  }
}
