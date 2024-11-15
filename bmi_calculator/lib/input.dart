import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'icon_text.dart'; // Ensure this file exists
import 'container.dart'; // Ensure this file exists
import 'constant.dart'; // Ensure this file exists
import 'result.dart';
enum Gender {
  male,
  female,
}

class InputPage extends StatefulWidget {
  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  Gender? selectGender;
  int sliderHeight = 180;
  int sliderWeight = 60;
  int sliderAge = 20;

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
                    onPressed: () {
                      setState(() {
                        selectGender = Gender.male;
                      });
                    },
                    colors:
                    selectGender == Gender.male ? activeColor : de_activeColor,
                    cardwidget: RepeatTextandIconCode(
                      iconData: FontAwesomeIcons.male,
                      label: 'Male',
                    ),
                  ),
                ),
                Expanded(
                  child: RepeatContainerCode(
                    onPressed: () {
                      setState(() {
                        selectGender = Gender.female;
                      });
                    },
                    colors: selectGender == Gender.female
                        ? activeColor
                        : de_activeColor,
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
                  Text(
                    'Height',
                    style: kLabelstyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        sliderHeight.toString(),
                        style: kNumberstyle,
                      ),
                      Text(
                        'cm',
                        style: kLabelstyle,
                      ),
                    ],
                  ),
                  Slider(
                    value: sliderHeight.toDouble(),
                    min: 120.0,
                    max: 220.0,
                    activeColor: Color(0xFFEB1555),
                    inactiveColor: Color(0xFF8D8E98),
                    onChanged: (double newValue) {
                      setState(() {
                        sliderHeight = newValue.round();
                      });
                    },
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
                    cardwidget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Weight',
                          style: kLabelstyle,
                        ),
                        Text(
                          sliderWeight.toString(),
                          style: kNumberstyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RoundIcon(
                              iconData: FontAwesomeIcons.minus,
                              onPress: () {
                                setState(() {
                                  sliderWeight--;
                                });
                              },
                            ),
                            SizedBox(width: 10.0),
                            RoundIcon(
                              iconData: FontAwesomeIcons.plus,
                              onPress: () {
                                setState(() {
                                  sliderWeight++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: RepeatContainerCode(
                    colors: Color(0xFF1D1E33),
                    cardwidget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Age',
                          style: kLabelstyle,
                        ),
                        Text(
                          sliderAge.toString(),
                          style: kNumberstyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RoundIcon(
                              iconData: FontAwesomeIcons.minus,
                              onPress: () {
                                setState(() {
                                  sliderAge--;
                                });
                              },
                            ),
                            SizedBox(width: 10.0),
                            RoundIcon(
                              iconData: FontAwesomeIcons.plus,
                              onPress: () {
                                setState(() {
                                  sliderAge++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> ResultScreen()));
            },
            child: Container(
              child: Center(
              child: Text(
                'Calculate',
                style: kLargeButtonstyle,
              ),
              ),
              color: Color(0xFFEB1555),
              margin: EdgeInsets.only(top: 10.0), // Corrected margin usage
              height: 30.0,
            ),
          ),
        ],
      ),
    );
  }
}

class RoundIcon extends StatelessWidget {
  RoundIcon({required this.iconData, required this.onPress});

  final IconData iconData;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(iconData),
      onPressed: () => onPress(),
      constraints: BoxConstraints.tightFor(
        height: 56.0,
        width: 56.0,
      ),
      shape: CircleBorder(),
      fillColor: Color(0xFF4C4F5E),
    );
  }
}
