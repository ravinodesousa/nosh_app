import 'package:flutter/material.dart';

Widget text(
  String text, {
  var fontSize = 14.0,
  textColor = const Color(0xFF212121),
  var fontFamily = 'Regular',
  var isCentered = false,
  var maxLine = 1,
  var latterSpacing = 0.25,
  var textAllCaps = false,
  var isLongText = false,
  var fontweight = FontWeight.bold,
}) {
  return Text(textAllCaps ? text.toUpperCase() : text,
      textAlign: isCentered ? TextAlign.center : TextAlign.start,
      maxLines: isLongText ? null : maxLine,
      style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          color: textColor,
          height: 1.5,
          letterSpacing: latterSpacing,
          fontWeight: fontweight));
}

Widget text1(
  String text, {
  var fontSize = 14.0,
  textColor = const Color(0xFF212121),
  var fontFamily = 'Regular',
  var isCentered = false,
  var maxLine = 1,
  var latterSpacing = 0.25,
  var textAllCaps = false,
  var isLongText = false,
}) {
  return Text(textAllCaps ? text.toUpperCase() : text,
      textAlign: isCentered ? TextAlign.center : TextAlign.start,
      maxLines: isLongText ? null : maxLine,
      style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          color: textColor,
          height: 1.5,
          letterSpacing: latterSpacing));
}

BoxDecoration boxDecoration(
    {double radius = 2,
    Color color = Colors.transparent,
    Color bgColor = Colors.white,
    var showShadow = false}) {
  return BoxDecoration(
      color: bgColor,
      //gradient: LinearGradient(colors: [bgColor, whiteColor]),
      boxShadow: showShadow
          ? [
              BoxShadow(
                  color: Color(0x95E9EBF0), blurRadius: 10, spreadRadius: 2)
            ]
          : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color),
      borderRadius: BorderRadius.all(Radius.circular(radius)));
}

BoxDecoration boxDecoration2(
    {double radius = 2,
    Color color = Colors.transparent,
    Color bgColor = Colors.white,
    var showShadow = false}) {
  return BoxDecoration(
      color: bgColor,
      //gradient: LinearGradient(colors: [bgColor, whiteColor]),
      boxShadow: showShadow
          ? [
              BoxShadow(
                  color: Color(0x95E9EBF0), blurRadius: 10, spreadRadius: 2)
            ]
          : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color),
      borderRadius: BorderRadius.all(Radius.circular(radius)));
}

Widget mHeading(var value) {
  return Container(
    margin: EdgeInsets.all(16.0),
    child: text(value, fontFamily: 'Medium', textAllCaps: true),
  );
}

Widget text2(var text,
    {var fontSize = 18.0,
    textColor = const Color(0xFF838591),
    var fontFamily = 'Regular',
    var isCentered = false,
    var maxLine = 1,
    var latterSpacing = 0.1,
    overflow: null}) {
  return Text(text,
      textAlign: isCentered ? TextAlign.center : TextAlign.start,
      maxLines: maxLine,
      style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          color: textColor,
          height: 1.5,
          letterSpacing: latterSpacing));
}

Widget mViewAll(BuildContext context, var value, {var tags}) {
  return GestureDetector(
    onTap: () {
      if (tags != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => tags));
      } //launchScreen(context, tags);
    },
    child: Container(
      margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 0, bottom: 8),
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.arrow_forward,
                      color: Color(0xFF3B8BEA), size: 18)),
            ),
            TextSpan(
                text: value,
                style: TextStyle(fontSize: 16.0, color: Color(0xFF3B8BEA))),
          ],
        ),
      ),
    ),
  );
}
