import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:votaapp/pages/login.dart';
import 'package:votaapp/utils/fireauth.dart';
import 'package:votaapp/utils/get_device_info.dart';
import 'package:device_information/device_information.dart';

PreferredSizeWidget Appbar(BuildContext context, User? currentUser) {
  getInfo().then((value) {
    print(value);
  });
  return AppBar(
    bottomOpacity: .0,
    brightness: Brightness.dark,
    backgroundColor: Colors.indigoAccent,
    primary: true,
    elevation: 3,
    title: Text(
      "VotaAPP",
      style: TextStyle(fontWeight: FontWeight.w600),
    ),
    actions: [
      IconButton(
        hoverColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.indigoAccent,
                        title: Text("Informacion del dispositivo"),
                      ),
                      body: Container(
                        child: Center(
                            child: FutureBuilder<Map<String, dynamic>>(
                                future: getInfo(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<Map<String, dynamic>>
                                        snapshot) {
                                  Widget children;

                                  if (snapshot.hasData) {
                                    dynamic names = snapshot.data?.values;

                                    children = ListView.builder(
                                        itemCount: names.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16),
                                                child: Text('Result: '),
                                              ),
                                            ],
                                          );
                                        });
                                  } else if (snapshot.hasError) {
                                    children = Row(
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                          size: 60,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 16),
                                          child:
                                              Text('Error: ${snapshot.error}'),
                                        )
                                      ],
                                    );
                                  } else {
                                    return Row(
                                      children: [
                                        SizedBox(
                                          child: CircularProgressIndicator(),
                                          width: 60,
                                          height: 60,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 16),
                                          child: Text(
                                            'Cargando datos del usuario',
                                          ),
                                        )
                                      ],
                                    );
                                  }
                                  return Container(
                                    alignment: Alignment.center,
                                    child: Container(
                                      child: children,
                                    ),
                                  );
                                })),
                      ),
                    )),
          );
        },
        icon: Icon(Icons.device_hub),
      ),
      IconButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut().then((value) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Login(),
                ),
              );
            });
          },
          icon: Icon(Icons.logout_outlined)),
    ],
  );
}
