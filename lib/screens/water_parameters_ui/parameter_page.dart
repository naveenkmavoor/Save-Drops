import 'dart:ui'; 
import 'package:flutter/material.dart';
import 'package:sed/models/main.dart';
import 'package:sed/screens/water_parameters_ui/components/flowpage.dart';
import 'package:sed/screens/water_parameters_ui/components/motor_status.dart';
import 'package:sed/screens/water_parameters_ui/components/tanklevel.dart';
import 'package:sed/screens/water_parameters_ui/components/waterbill.dart'; 

class Parameter_page extends StatefulWidget {
  final MainModel model;
  Parameter_page(this.model);
  @override
  _Parameter_pageState createState() => _Parameter_pageState();
}

class _Parameter_pageState extends State<Parameter_page> {
  int pagenumber;
  @override
  void initState() {
    pagenumber = widget.model.parameters;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body:   Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 10),
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/blue.jpg'), fit: BoxFit.cover),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: SingleChildScrollView(
                              child: SafeArea(
                    child: pagenumber == 1
                        ? Flowpage(widget.model)
                        : pagenumber == 2
                            ? MotorStatus(widget.model)
                            : pagenumber == 3
                                ? TankLevel(widget.model)
                                : WaterBill(widget.model)),
              ),
            ),
          ),
        );
  }
}
