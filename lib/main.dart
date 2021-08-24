import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:votaapp/pages/login.dart';
import 'package:votaapp/widgets/votes_content.dart';
import 'web/admin.dart';
import 'package:flutter/services.dart';
import 'widgets/nav_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference users = FirebaseFirestore.instance.collection('votes');

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
      routes: {
        '/': (context) => HomeLogin(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final User? user;
  MyHomePage({Key? key, required this.user}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _isSendingVerification = false;
  bool _isSigningOut = false;
  late User? _currentUser;
  final _navigatorKey = new GlobalKey<NavigatorState>();
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('votes')
      .snapshots(includeMetadataChanges: true);
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _currentUser = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(context, this._currentUser),
      resizeToAvoidBottomInset: false,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Encuesta abiertas",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontFamily: 'arial',
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w200),
              ),
            ),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    child: Column(children: [
                      VoteCard(user: _currentUser),
                      Container(
                        margin: EdgeInsets.only(top: 0),
                        width: 500,
                        height: 600,
                        child: Card(
                          elevation: 0,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  "Voto finalizados",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w200),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                        height: 300,
                                        child: StreamBuilder(
                                            stream: _usersStream,
                                            builder: (BuildContext context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              final parse = snapshot.data?.docs
                                                  .map((e) => e.data())
                                                  .toList();

                                              var data = json.encode(parse);
                                              var jsonMap = json.decode(data);
                                              var str = jsonEncode(jsonMap);
                                              var to = jsonDecode(str);
                                              print(to[0]['isClosed']);
                                              if (snapshot.hasData) {
                                                if (to.length > 0) {
                                                  return ListView.builder(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemExtent: 250,
                                                      itemCount: to.length,
                                                      itemBuilder:
                                                          (BuildContext ctxt,
                                                              int index) {
                                                        return SizedBox(
                                                            width: 200,
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              35),
                                                                  width: 350,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(20),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.how_to_vote,
                                                                              color: Colors.redAccent,
                                                                              size: 90,
                                                                            ),
                                                                            Text(
                                                                              "Cantidad de votos ${to[index]['numTotalVotes']}",
                                                                              style: TextStyle(fontSize: 20),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ));
                                                      });
                                                }
                                              }

                                              // else {
                                              //   return Column(
                                              //     children: [
                                              //       Text(
                                              //           "No se han finalizado la encuestas! O aun no se han creado")
                                              //     ],
                                              //   );
                                              // }
                                              return Container(
                                                  margin:
                                                      EdgeInsets.only(top: 90),
                                                  child: Text(
                                                      "No se han finalizados encuestas"));
                                            })))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
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
