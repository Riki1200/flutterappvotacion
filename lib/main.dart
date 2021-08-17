import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:votaapp/widgets/votes_content.dart';
import 'web/admin.dart';
import 'package:flutter/services.dart';
import 'widgets/nav_bar.dart';
import 'package:votaapp/utils/get_device_info.dart';
import 'package:firebase_core/firebase_core.dart';

// @dart=2.9
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    runApp(Admin());
  } else {
    await Firebase.initializeApp();
    runApp(MyApp());
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle());
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vote APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'Vote APP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(context),

      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Stack(
                textDirection: TextDirection.rtl,
                children: [
                  Container(
                    padding: EdgeInsets.all(30),
                    child: VoteCard(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Cards extends StatelessWidget {
  @override
  Widget build(BuildContext build) {
    return Container(
      child: Column(
        children: [Text("Soy un nuevo container")],
      ),
    );
  }
}
