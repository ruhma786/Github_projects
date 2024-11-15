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
  Color maleColor = de_activeColor;
  Color femaleColor = de_activeColor;
  void updateColor(Gender gendertype)
  {
    if(gendertype==Gender.male)
    {
      maleColor = activeColor;
      femaleColor = de_activeColor;
    }
    if(gendertype==Gender.female)
    {
      maleColor = de_activeColor;
      femaleColor = activeColor;
    }

  }
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
                  child: GestureDetector(
                    onTap: ()
                  {
                    setState(()
                    {
                      updateColor(Gender.male);
                    });
                  },
                    child: RepeatContainerCode(
                      colors: maleColor,
                      cardwidget: RepeatTextandIconCode(
                        iconData: FontAwesomeIcons.male,
                        label: 'Male',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: ()
                    {
                      setState(()
                      {
                        updateColor(Gender.female);
                      });
                    },
                    child: RepeatContainerCode(
                      colors: femaleColor,
                      cardwidget: RepeatTextandIconCode(
                          iconData: FontAwesomeIcons.female,
                          label: 'Female',
                      ),
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



