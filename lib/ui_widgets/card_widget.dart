import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Card_widget extends StatelessWidget {
  final String title;
  final String svg;
  final Function press;
  final Colors color;
  const Card_widget({Key key, this.title, this.press, this.svg, this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        splashColor: Color(0xff1FFF00),
        child: Container(
          width: 170,
          height: 170,
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
              border: null),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 0, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SvgPicture.asset(
                  svg,
                  height: 42,
                  color: Colors.white,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                )
              ],
            ),
          ),
        ),
        onTap: press,
      ),
    );
  }
}
