import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference users = FirebaseFirestore.instance.collection('votes');

final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
    .collection('votes')
    .snapshots(includeMetadataChanges: true);

class VoteCard extends StatefulWidget {
  final User? user;
  VoteCard({Key? key, this.user}) : super(key: key);
  @override
  _VoteCard createState() => _VoteCard(user);
}

class _VoteCard extends State<VoteCard> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  _VoteCard(User? user);

  @override
  Widget build(BuildContext build) {
    Future getAllVotes() async {
      await users.get().then((value) {});
    }

    return Container(
        color: Colors.transparent,
        padding: EdgeInsets.all(1),
        child: StreamBuilder(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            try {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                final parse = snapshot.data?.docs.map((e) => e.data()).toList();
                var userID = widget.user!.isAnonymous
                    ? widget.user?.uid
                    : widget.user?.uid as String;
                var idUsers = [];
                var data = json.encode(parse);
                var jsonMap = json.decode(data);
                var str = jsonEncode(jsonMap);
                var to = jsonDecode(str);
                bool isClosed = false;

                if (to.length > 0) {
                  return Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 100,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: to.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return Card(
                                  borderOnForeground: true,
                                  elevation: 2,
                                  margin: EdgeInsets.all(7),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                  flex: 15,
                                                  fit: FlexFit.loose,
                                                  child: Text(
                                                    to[index]['answer'],
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  )),
                                              Spacer(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(to[index]['inFavor']
                                                          .length
                                                          .toString()),
                                                      IconButton(
                                                          color: Colors.green,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          onPressed: () async {
                                                            idUsers.addAll(
                                                                [userID]);
                                                            await VoteUsers(
                                                                field:
                                                                    'inFavor',
                                                                fieldWhere: to[
                                                                        index]
                                                                    ['inFavor'],
                                                                value: idUsers);
                                                          },
                                                          icon: Icon(
                                                              Icons.thumb_up)),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(to[index]['abstain']
                                                          .length
                                                          .toString()),
                                                      IconButton(
                                                          color: Colors.orange,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          onPressed: () async {
                                                            idUsers.addAll(
                                                                [userID]);
                                                            await VoteUsers(
                                                                field:
                                                                    'abstain',
                                                                fieldWhere: to[
                                                                        index]
                                                                    ['abstain'],
                                                                value: idUsers);
                                                          },
                                                          icon: Icon(
                                                              Icons.mood_bad)),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(to[index]['against']
                                                          .length
                                                          .toString()),
                                                      IconButton(
                                                          color:
                                                              Colors.redAccent,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          onPressed: () async {
                                                            if (widget.user !=
                                                                null) {
                                                              idUsers.addAll(
                                                                  [userID]);
                                                              await VoteUsers(
                                                                field:
                                                                    'against',
                                                                fieldWhere: to[
                                                                        index]
                                                                    ['against'],
                                                                value: idUsers,
                                                              );
                                                            }
                                                          },
                                                          icon: Icon(Icons
                                                              .thumb_down)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ]),
                                      ),
                                    ],
                                  ));
                            }),
                      ));
                } else {
                  print('else');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "No hay encuestas disponibles",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      )
                    ],
                  );
                }
              } else {
                print("else");
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: () {}, child: Text("asdasd")),
                    Text(
                      "No hay encuestas disponibles",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                );
              }
            } catch (e) {
              return Text("Problemas tecnicos");
            }
          },
        ));
  }

  Future VoteUsers({dynamic fieldWhere, dynamic field, dynamic value}) async {
    switch (field as String) {
      case 'inFavor':
        users
            .where(
              'inFavor',
              isEqualTo: fieldWhere,
            )
            .limit(1)
            .get()
            .then((_) async {
          final result = _.docs.single.id;

          users.doc(result).update({
            'inFavor': FieldValue.arrayUnion(value),
            'abstain': [],
            'against': []
          }).then((value) {});
        });
        break;
      case 'abstain':
        users
            .where(
              'abstain',
              isEqualTo: fieldWhere,
            )
            .limit(1)
            .get()
            .then((_) {
          print("clicked: ${_.docs}");
          final result = _.docs.single.id;
          users.doc(result).update({
            'abstain': FieldValue.arrayUnion(value),
          }).then((value) {});
        });
        break;
      case 'against':
        users
            .where(
              'against',
              isEqualTo: fieldWhere,
            )
            .limit(1)
            .get()
            .then((_) {
          print("clicked: ${_.docs}");
          final result = _.docs.single.id;

          users.doc(result).update(
              {'against': FieldValue.arrayUnion(value)}).then((value) {});
        });
        break;
      default:
    }
  }
}
