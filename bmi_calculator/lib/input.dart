
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'icon_text.dart';
import 'container.dart';
const activeColor = Color(0xFF1D1E33);
const de_activeColor = Color(0xFF111328);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI CALCULATOR"),
      ),
      body: Column(
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
