import 'package:flutter/material.dart';
class climate extends StatefulWidget {
  const climate({super.key});
  @override
  State<climate> createState() => _climateState();
}

class _climateState extends State<climate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ClimateApp'),
        backgroundColor: Colors.red,
        actions: <Widget>[
          IconButton(
              onPressed: ()=>print('clicked'),
              icon: Icon(Icons.menu))
        ],


      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image(
              image: AssetImage('images/umbrella.png'),
              height: 1200.0,
              width: 500.0,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: Text(
              'Vehari',
              style: cityStyle(),
            ),
          ),
        ],
      ),
    );
  }
}


TextStyle cityStyle(){
  return TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}