import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sed/class/checkconnectivity.dart';
import 'package:sed/models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import './screens/user_auth/resetpassword.dart';
import 'package:sed/screens/user_edit/components/accountpage.dart';
import 'package:sed/screens/user_edit/settings.dart';
import 'package:sed/screens/water_parameters_ui/parameter_page.dart';
import 'package:sed/ui_widgets/curvenavigator.dart';
import './screens/user_auth/authentication.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseApp.configure(
    name: 'DATABASE INSTANCE NAME',
    options: const FirebaseOptions(
      googleAppID: 'APP ID',
      apiKey: 'API KEY',
      databaseURL: 'DB URL',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MainModel _model = MainModel();
  bool _isAuthenticated = false;
  @override
  void initState() {
    _model.userAutoValidate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        print('userauth setstate rendered!');
        _isAuthenticated = isAuthenticated;
        if (isAuthenticated) {
          _model.firebaseinstace = FirebaseDatabase.instance
              .reference()
              .child('users')
              .child('${_model.user.userid}');
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]); //Sets the orientation of device in potrait mode only
    return ScopedModel<MainModel>(
        model: _model,
        child: StreamProvider<DataConnectionStatus>(
          create: (context) {
            return DataConnectivityService()
                .connectivityStreamController
                .stream;
          },
          child: MaterialApp(
            theme: ThemeData(
              accentColor: Color(0xff1FFF00),
              brightness: Brightness.dark,
            ),
            darkTheme: ThemeData.dark(),
            routes: {
              '/': (BuildContext context) =>
                  !_isAuthenticated ? Authentication() : Redirect(_model),
            },
            onGenerateRoute: (RouteSettings settings) {
              if (settings.name == '/parameterpage') {
                return MaterialPageRoute(builder: (BuildContext context) {
                  return !_isAuthenticated
                      ? Authentication()
                      : Parameter_page(_model);
                });
              } else if (settings.name == '/resetpassword') {
                return MaterialPageRoute(builder: (BuildContext context) {
                  return ResetPassword(_model);
                });
              } else if (settings.name == '/settings') {
                return MaterialPageRoute(builder: (BuildContext context) {
                  return !_isAuthenticated
                      ? Authentication()
                      : Settings(_model);
                });
              } else if (settings.name == '/account') {
                return MaterialPageRoute(builder: (BuildContext context) {
                  return !_isAuthenticated
                      ? Authentication()
                      : Accountpage(_model);
                });
              }
              return null;
            },
            debugShowCheckedModeBanner: false,
            title: 'Flutter Playground',
          ),
        ));
  }
}
