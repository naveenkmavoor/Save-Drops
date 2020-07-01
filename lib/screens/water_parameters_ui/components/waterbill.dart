import 'package:date_format/date_format.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_database/firebase_database.dart' as database;
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sed/models/main.dart';

class WaterBill extends StatefulWidget {
  final MainModel model;
  WaterBill(this.model);
  @override
  _WaterBillState createState() => _WaterBillState();
}

final List<DataPoint<DateTime>> datevalue = [];

final Radius radius = Radius.circular(10);

class _WaterBillState extends State<WaterBill> {
  MainModel _model;
  String dateData = formatDate(DateTime.now(), [yyyy, '-', mm]);
  double thismonth = 0.0;
  @override
  void initState() {
    _model = widget.model;
    DatabaseReference _usageStatics =
        _model.firebaseinstace.child('flowSensorValue');

    _usageStatics.once().then((database.DataSnapshot snapshot) {
      Map<dynamic, dynamic> value = snapshot.value;
      double bill;
      if (value != null) {
        value.forEach((dynamic keyname, dynamic data) {
          DateTime tempDate = new DateFormat("yyyy-MM").parse(keyname);
          if (formatDate(tempDate, [yyyy, '-', mm]) == dateData)
            thismonth = thismonth + value[keyname];
          bill = (data / 1000) *
              6; // calculating bill for each day , assuming 1000L costs 6 rs in india.
          datevalue.add(DataPoint<DateTime>(
              xAxis: tempDate, value: num.parse(bill.toStringAsFixed(2))));
          print('keyname : $tempDate, value :$bill');
        });
        if (mounted)
          setState(() {
            _model.waterConsumed['thismonthprice'] = (thismonth / 1000) * 6;
            _model.waterConsumed['thismonthprice'] = num.parse(
                _model.waterConsumed['thismonthprice'].toStringAsFixed(2));
          });
      }
    });

    print('thismonth : $thismonth');
    super.initState();
  }

  @override
  void dispose() {
    datevalue.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Material(
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.arrowLeft,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(
                  Icons.settings,
                ),
                onPressed: () => Navigator.pushNamed(context, '/settings'),
              ),
            ),
          ],
        ),
        Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 8),
            child: Text(
              'Water Bill',
              style: TextStyle(
                  fontWeight: FontWeight.w300, fontSize: 30, height: 2),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 5),
          child: Row(
            children: <Widget>[
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xff1FFF00),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Normal Consumption Bill',
                style: TextStyle(fontWeight: FontWeight.w300),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top:40,bottom: 20 ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Wrap(
                runSpacing: 10,
                spacing: 10,
                children: <Widget>[
                  _buildContainer('Today Consumed', 'assets/rupee.svg',
                      _model.waterConsumed['todayprice']),
                  _buildContainer('This month Consumed', 'assets/rupee.svg',
                      _model.waterConsumed['thismonthprice']),
                ],
              ),
            ],
          ),
        ),
        Container(
            height: 50,
            width: 500,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(topLeft: radius, topRight: radius),
                color: Colors.black.withOpacity(0.5)),
            child: Text(
              'Water bill of each month',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
            )),
        sample1(context),
      ],
    );
  }
}

Widget _buildContainer(title, svg, price) => Container(
      width: 170,
      height: 170,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(15),
          border: null),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 0, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
            Row(
              children: <Widget>[
                SvgPicture.asset(
                  svg,
                  height: 42,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  '${price}',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                )
              ],
            ),
          ],
        ),
      ),
    );

Widget sample1(BuildContext context) {
  final today = DateTime.now();
  return Container(
    height: 250,
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.5),
      borderRadius: BorderRadius.only(bottomLeft: radius, bottomRight: radius),
    ),
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
          label: '₹',
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
        snap: true,
      ),
    ),
  );
}
