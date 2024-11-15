
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'icon_text.dart';
import 'container.dart';
import 'constant.dart';
enum Gender{
  male,
  female,
}

class InputPage extends StatefulWidget {
  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  Gender? selectGender;
  int sliderHeight=180;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI CALCULATOR"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(

                    child: RepeatContainerCode(
                      onPressed: (){
                        setState(() {
                          selectGender=Gender.male;
                        });
                      },
                      colors: selectGender==Gender.male ? activeColor : de_activeColor,
                      cardwidget: RepeatTextandIconCode(
                        iconData: FontAwesomeIcons.male,
                        label: 'Male',
                      ),
                    ),
                ),
                Expanded(
                    child: RepeatContainerCode(
                      onPressed: (){
                        setState(() {
                          selectGender=Gender.female;
                        });
                      },
                      colors: selectGender==Gender.female ? activeColor : de_activeColor,
                      cardwidget: RepeatTextandIconCode(
                        iconData: FontAwesomeIcons.female,
                        label: 'Female',
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: RepeatContainerCode(
              colors: Color(0xFF1D1E33),
                cardwidget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Height',
                      style: kLabelstyle,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          sliderHeight.toString(),
                          style:kNumberstyle,
                        ),
                        Text(
                          'cm',
                          style: kLabelstyle,
                        ),
                      ],
                    ),
                    Slider(value: sliderHeight.toDouble(),
                        min: 120.0,
                        max: 220.0,
                        activeColor: Color(0xFFEB1555),
                        inactiveColor: Color(0xFF8D8E98),
                        onChanged: (double newvalue){
                          setState(() {
                            sliderHeight = newvalue.round();
                          });
                        }
                    ),
                  ],
                ),
            ),

          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RepeatContainerCode(
                    colors: Color(0xFF1D1E33),
                  ),
                ),
                Expanded(
                  child: RepeatContainerCode(
                    colors: Color(0xFF1D1E33),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
