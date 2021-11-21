// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:example/pages/demo1.dart' show Demo1;
import 'package:example/pages/demo2.dart' show Demo2;

void main() {
  // debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fijkplayer_skin demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          MyButton(
            text: "完整例子（剧集、播放速度）",
            cb: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Demo1(),
                ),
              );
            },
          ),
          MyButton(
            text: "精简例子",
            cb: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Demo2(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  Function cb;
  String text;
  MyButton({
    Key? key,
    required this.cb,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        onPressed: () => cb(),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
