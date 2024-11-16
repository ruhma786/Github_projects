import 'package:bmi_calculator/constant.dart';
import 'package:bmi_calculator/container.dart';
import 'package:flutter/material.dart';
import 'input.dart';
class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              'BMI result'
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                child: Center(
                  child: Text(
                    'Your Result',
                    style: kTitleStyleS2,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: RepeatContainerCode(
                colors: activeColor,
                cardwidget: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Normal',
                      style: kResultText,
                    ),
                    Text(
                      '18.3',
                      style: kBMITextStyle,
                    ),
                    Text(
                      'BMI is Low You Should have to Work More',
                      textAlign: TextAlign.center,
                      style: kbodyTextStyle,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child:  GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                child: Center(
                  child: Text(
                    'Re-Calculate',
                    style: kLargeButtonstyle,
                  ),
                ),
                color: Color(0xFFEB1555),
                margin: EdgeInsets.only(top: 10.0), // Corrected margin usage
                height: 30.0,
              ),
            ),
            ),
          ],
        )
    );
  }
}