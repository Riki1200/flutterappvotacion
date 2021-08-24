import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class AdminWeb extends StatefulWidget {
  AdminWeb({Key? key}) : super(key: key);
  @override
  _AdminWeb createState() {
    return _AdminWeb();
  }
}

final users = firestore.collection('votes');

class _AdminWeb extends State<AdminWeb> {
  @override
  void initState() {
    super.initState();
  }

  bool closedVote = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Administrador de encuestas"),
        backgroundColor: Colors.black,
        elevation: 1,
        actions: [NavigationBar()],
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: users.snapshots(includeMetadataChanges: true),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text("No se ecuentram encuestas activas");
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.hasData) {
                      final parse =
                          snapshot.data?.docs.map((e) => e.data()).toList();

                      var data = json.encode(parse);
                      var jsonMap = json.decode(data);
                      var str = jsonEncode(jsonMap);
                      var to = jsonDecode(str);

                      return Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.all(10),
                          itemCount: to.length,
                          itemBuilder: (context, index) {
                            return Flexible(
                                child: Card(
                              elevation: 2,
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          to[index]["answer"],
                                          textAlign: TextAlign.start,
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                            fontFamily: "arial",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 20, left: 16),
                                        child: Row(
                                          children: [
                                            Text("Votos maximos: " +
                                                to[index]['numTotalVotes']
                                                    .toString()),
                                            Spacer(
                                              flex: 2,
                                            ),
                                            IconButton(
                                                alignment: Alignment.center,
                                                onPressed: () {
                                                  final ButtonStyle style =
                                                      ElevatedButton.styleFrom(
                                                          textStyle:
                                                              const TextStyle(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      20));
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          'Estas seguro?',
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        actions: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context,
                                                                        false),
                                                                child:
                                                                    Text('No'),
                                                              ),
                                                              Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10)),
                                                              ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  users.get().then(
                                                                      (value) async {
                                                                    print(value
                                                                        .docs);
                                                                  });

                                                                  users
                                                                      .where(
                                                                        'answer',
                                                                        isEqualTo:
                                                                            to[index]['answer'],
                                                                      )
                                                                      .get()
                                                                      .then(
                                                                          (value) {
                                                                    value.docs
                                                                        .forEach(
                                                                            (element) {
                                                                      print(
                                                                          "clicked: ${element.id}");
                                                                      users
                                                                          .doc(element
                                                                              .id)
                                                                          .delete()
                                                                          .then(
                                                                              (value) {
                                                                        print(
                                                                            "Why do all deleted?");
                                                                      });
                                                                    });
                                                                  });

                                                                  Navigator.pop(
                                                                      context,
                                                                      true);
                                                                }, // passing true
                                                                child:
                                                                    Text('Si'),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: Icon(Icons.delete)),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  users
                                                      .where(
                                                        'answer',
                                                        isEqualTo: to[index]
                                                            ['answer'],
                                                      )
                                                      .get()
                                                      .then((value) {
                                                    value.docs
                                                        .forEach((element) {
                                                      print(
                                                          "clicked: ${element.id}");
                                                      users
                                                          .doc(element.id)
                                                          .update({
                                                        'isClosed': true
                                                      }).then((value) {
                                                        print("Done");
                                                      });
                                                    });
                                                  });
                                                },
                                                child: Text("Cerrar ecuesta"))
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 20, left: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                    "Personas a favor: ${to[index]['inFavor'].length}"),
                                                SizedBox(
                                                  width: 50,
                                                ),
                                                Icon(Icons.favorite,
                                                    color: Colors.green),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    "Personas a favor: ${to[index]['abstain'].length}"),
                                                SizedBox(
                                                  width: 50,
                                                ),
                                                Icon(
                                                  Icons.mood_bad,
                                                  color: Colors.yellow[500],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    "Personas en contra: ${to[index]['against'].length}"),
                                                SizedBox(
                                                  width: 33,
                                                ),
                                                Icon(
                                                  Icons.mood_bad,
                                                  color: Colors.red,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            ));
                          },
                        ),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: const Text('Agregar encuesta'),
              ),
              body: Container(
                padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                child: _FormState(),
              ),
            );
          },
        )),
        backgroundColor: Colors.black,
        tooltip: "Agregar",
        child: Icon(Icons.add),
      ),
    );
  }
}

class Admin extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vote APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      routes: {'/': (context) => AdminWeb()},
    );
  }
}

class NavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NabvarItem(
            icon: Icon(Icons.article),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.black,
                      title: const Text('Lista de encuestas'),
                    ),
                    body: const Center(
                      child: Text(
                        'Aqui se agregaran las encuestas?',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ));
            },
          ),
        ],
      ),
    );
  }
}

class NabvarItem extends StatelessWidget {
  final Function onPressed;
  final Widget icon;
  const NabvarItem({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: IconButton(
            onPressed: () {
              this.onPressed();
            },
            icon: this.icon));
  }
}

class AppView extends StatelessWidget {
  final Widget child;

  const AppView({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [NavigationBar(), Expanded(child: child)],
      ),
    );
  }
}

class _FormState extends StatefulWidget {
  _FormState({Key? key}) : super(key: key);
  @override
  FormWidget createState() {
    return FormWidget();
  }
}

class MyRoutes extends Route<String> {}

class FormWidget extends State<_FormState> {
  String answer = '';
  num totalVotes = 0;
  final answerController = TextEditingController();
  final numVotesController = TextEditingController();
  final nameVote = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void endSnackbar() {
    Future.delayed(Duration(seconds: 1), () {
      answerController.text = '';
      numVotesController.text = '';
      nameVote.text = '';
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    answerController.dispose();
    numVotesController.dispose();
    nameVote.dispose();
    super.dispose();
  }

  Future saveVotes() async {
    CollectionReference users = FirebaseFirestore.instance.collection('votes');

    return await users.doc(nameVote.text).set({
      'isClosed': false,
      'inFavor': [],
      'abstain': [],
      'against': [],
      'answer': answerController.text,
      'numTotalVotes': num.parse(numVotesController.text)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Crear encuesta",
            style: TextStyle(fontSize: 40),
          ),
          TextFormField(
            controller: nameVote,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: "Nombre unico de la encuesta",
              fillColor: Colors.grey[300],
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresar un nombre unico de la encuesta ';
              }
              return null;
            },
          ),
          Divider(
            color: Colors.transparent,
          ),
          TextFormField(
            controller: answerController,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: "Ocurrencia?",
              fillColor: Colors.grey[300],
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresar alguna pregunta para la encuesta';
              }
              return null;
            },
          ),
          Divider(
            color: Colors.transparent,
          ),
          TextFormField(
            controller: numVotesController,
            keyboardType: TextInputType.number,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: "Numero maximo de votos",
              fillColor: Colors.grey[300],
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
            ),
            enableSuggestions: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresar alguna pregunta para la encuesta';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 26.0),
            child: RaisedButton(
              padding:
                  EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  saveVotes().then(
                      (value) => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green[400],
                              content: Text("Ha sido guardado con exito"),
                              onVisible: endSnackbar,
                              duration: Duration(seconds: 3),
                            ),
                          ));
                }
              },
              child: const Text('Guardar'),
            ),
          ),
        ],
      ),
      key: _formKey,
    );
  }
}

class GetUserName extends StatelessWidget {
  final String documentId;

  GetUserName(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('votes');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text("Full Name: ${data}");
        }

        return Text("loading");
      },
    );
  }
}
