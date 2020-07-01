import 'dart:ui';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sed/models/main.dart';

class Usage_Stastics extends StatefulWidget {
  final MainModel model;
  final GlobalKey<ScaffoldState> scaffoldKey;
  Usage_Stastics({this.model, this.scaffoldKey});
  @override
  _Usage_StasticsState createState() => _Usage_StasticsState();
}

final List<DataPoint<DateTime>> datevalue = [];
final Radius radius = Radius.circular(20);

double width;

class _Usage_StasticsState extends State<Usage_Stastics> {
  String dateData = DateFormat('yyyy-MM-dd').format(DateTime.now());
  @override
  void initState() {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .reference()
        .child('users')
        .child('${widget.model.user.userid}')
        .child('flowSensorValue');
    databaseReference.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> value = snapshot.value;

      print('snapshot value : ${snapshot.value}');
      if (snapshot.value != null) {
        value.forEach((dynamic keyname, dynamic data) {
          DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(keyname);
          datevalue.add(DataPoint<DateTime>(xAxis: tempDate, value: data));
          print('keyname : $keyname, value :$value');
        });
        if (mounted) setState(() {});
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    datevalue.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/menuicons.svg', //style attribute
                        semanticsLabel: 'Menu',
                      ),
                      onPressed: () {
                        widget.scaffoldKey.currentState.openDrawer();
                      },
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    child: IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () =>
                          Navigator.pushNamed(context, '/settings'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 25, bottom: 10),
                child: Text(
                  'Usage Stastics',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 30),
                )),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, bottom: 40),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xff1FFF00),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Normal consumption',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
            _buildContainer(
              'Weekly usage',
            ),
            sample1(context),
            SizedBox(
              height: 30,
            ),
            _buildContainer(
              'Monthly usage',
            ),
            sample2(context),
            SizedBox(
              height: 30,
            ),
            _buildContainer(
              'Yearly usage',
            ),
            sample3(context),
            SizedBox(
              height: 65,
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildContainer(title) {
  return Container(
    alignment: Alignment.bottomCenter,
    height: 35,
    width: 170,
    decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.only(topLeft: radius, topRight: radius)),
    child: Text(title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
  );
}

Widget sample1(BuildContext context) {
  final today = DateTime.now();
  return Container(
    height: 250,
    width: width,
    decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
    child: BezierChart(
      fromDate:
          DateTime(2020, 03, 01), //actually set to last 6 days before toDate
      toDate: today,
      selectedDate: today,
      bezierChartScale: BezierChartScale.WEEKLY,
      series: [
        BezierLine(
          lineColor: Color(0xff1FFF00),
          dataPointFillColor: Colors.white,
          dataPointStrokeColor: Colors.white,
          label: 'Litre',
          data: datevalue,
        ),
      ],
      config: BezierChartConfig(
        verticalIndicatorStrokeWidth: 3.0,
        verticalIndicatorColor: Colors.lightBlueAccent,
        updatePositionOnTap: true,
        verticalIndicatorFixedPosition: false,
        showVerticalIndicator: true,
        footerHeight: 60,
        snap: false,
      ),
    ),
  );
}

Widget sample2(BuildContext context) {
  final today = DateTime.now();
  return Container(
    decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
    height: 250,
    width: width,
    child: BezierChart(
      fromDate: DateTime(2019, 09, 22),
      toDate: today,
      selectedDate: today,
      bezierChartScale: BezierChartScale.MONTHLY,
      series: [
        BezierLine(
          lineColor: Color(0xff1FFF00),
          dataPointFillColor: Colors.white,
          dataPointStrokeColor: Colors.white,
          label: 'Litre',
          data: datevalue,
        ),
      ],
      config: BezierChartConfig(
        verticalIndicatorStrokeWidth: 3.0,
        verticalIndicatorColor: Colors.lightBlueAccent,
        updatePositionOnTap: true,
        verticalIndicatorFixedPosition: false,
        showVerticalIndicator: true,
        footerHeight: 60,
        snap: false,
      ),
    ),
  );
}

Widget sample3(BuildContext context) {
  final today = DateTime.now();
  return Container(
    height: 250,
    width: width,
    child: BezierChart(
      fromDate: DateTime(2018, 10, 19),
      toDate: today,
      selectedDate: today,
      bezierChartScale: BezierChartScale.YEARLY,
      series: [
        BezierLine(
          lineColor: Color(0xff1FFF00),
          dataPointFillColor: Colors.white,
          dataPointStrokeColor: Colors.white,
          label: 'Litre',
          data: datevalue,
        ),
      ],
      config: BezierChartConfig(
        backgroundColor: Colors.black.withOpacity(0.5),
        verticalIndicatorStrokeWidth: 3.0,
        verticalIndicatorColor: Colors.lightBlueAccent,
        updatePositionOnTap: true,
        verticalIndicatorFixedPosition: false,
        showVerticalIndicator: true,
        footerHeight: 60,
        snap: false,
      ),
    ),
  );
}
