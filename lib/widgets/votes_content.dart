import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference users = FirebaseFirestore.instance.collection('votes');

class VoteCard extends StatelessWidget {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('votes')
      .snapshots(includeMetadataChanges: true);
  @override
  Widget build(BuildContext build) {
    Future getAllVotes() async {
      await users.get().then((value) {});
    }

    return Container(
        child: StreamBuilder(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("No se ecuentran encuestas disponibles"));
        }
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot<Object?>>? items = snapshot.data?.docs;
          print(items?.first);
          final parse =
              snapshot.data?.docs.map((e) => e.data()).toList().asMap();
          var user =
              jsonDecode("{'a': '0', 'b': '0'}", reviver: (object1, object2) {
            return Object();
          });
          print(user);
          return ListView.builder(
            itemCount: items?.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${items?[index]}'),
              );
            },
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          print(snapshot.data?.docs);
          print(_usersStream.first);
          return Text("${snapshot.data?.docs.length}");
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }
}
