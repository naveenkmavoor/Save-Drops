import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sed/models/main.dart'; 
import 'package:sed/screens/homepage/up_part.dart'; 
import 'package:sed/ui_widgets/card_widget.dart'; 

class DownPart extends StatelessWidget {
  DownPart({this.model, this.scaffoldkey});
  final MainModel model;
  final GlobalKey<ScaffoldState> scaffoldkey;
  @override
  Widget build(BuildContext context) {
      return  SingleChildScrollView(
              child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildContainer(context),
            SizedBox(
              height: 20,
            ),
            _buildWrap(context)
          ], 
    ),
      );
  }

  Widget _buildContainer(context) =>  
       Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 9),
          child: SafeArea(
              child: UpPart(model: model, scaffoldkey: scaffoldkey)),
          height: MediaQuery.of(context).size.height * 0.38,
          decoration: BoxDecoration(
            color: Color(0xff263A54),
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.4), BlendMode.modulate),
                image: AssetImage(
                  'assets/water.jpg',
                ),
                fit: BoxFit.fill),
          ),
       
  );

  Widget _buildWrap(context) => Wrap(
        runSpacing: 10,
        spacing: 10,
        children: <Widget>[
          Card_widget(
            svg: 'assets/flow.svg',
            title: 'Flow Meter',
            press: () {
              model.parameters = 1;
              Navigator.pushNamed(context, "/parameterpage");
            },
          ),
          Card_widget(
              svg: 'assets/motor.svg',
              title: 'Motor Status',
              press: () {
                model.parameters = 2;
                Navigator.pushNamed(context, '/parameterpage');
              }),
          Card_widget(
            svg: 'assets/level.svg',
            title: 'Tank status',
            press: () {
              model.parameters = 3;
              Navigator.pushNamed(context, "/parameterpage");
            },
          ),
          Card_widget(
            svg: 'assets/rupee.svg',
            title: 'Water Bill',
            press: () {
              model.parameters = 4;
              Navigator.pushNamed(context, "/parameterpage");
            },
          ),
        ],
      );
}
