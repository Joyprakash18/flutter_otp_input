import 'package:flutter/material.dart';
import 'package:flutterotpinput/widgets/pin_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _onCompleted = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Center(child: new Text('Example verify code')),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Enter your code',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          PinView(
            itemCount: 4,
            itemSize: 50,
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(60.0),
              ),
            ),
            keyboardType: TextInputType.number,
            onCompleted: (String value) {
              print(value);
              setState(() {
                _onCompleted = value;
              });
            },
            autofocus: true,
          ),
          SizedBox(
            height: 10,
          ),
          (_onCompleted != "")
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Your code is: $_onCompleted',
              ),
            ),
          )
              : Container(),
        ],
      ),
    );
  }
}
