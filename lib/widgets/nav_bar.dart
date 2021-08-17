import 'dart:io';
import 'package:flutter/material.dart';
import 'package:votaapp/utils/get_device_info.dart';
import 'package:device_information/device_information.dart';

PreferredSizeWidget Appbar(BuildContext context) {
  getInfo().then((value) {
    print(value);
  });
  return AppBar(
    bottomOpacity: .0,
    brightness: Brightness.dark,
    backgroundColor: Colors.red[800],
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
                        backgroundColor: Colors.red[800],
                      ),
                      body: FutureBuilder<Map<String, dynamic>>(
                          future: getInfo(),
                          builder: (BuildContext context,
                              AsyncSnapshot<Map<String, dynamic>> snapshot) {
                            List<Widget> children;

                            if (snapshot.hasData) {
                              dynamic names = snapshot.data?.values;

                              children = <Widget>[
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Text('Result: ${names}'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Text('Result: ${names}'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Text('Result: ${names}'),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text('Result: ${names}'),
                                )
                              ];
                            } else if (snapshot.hasError) {
                              children = <Widget>[
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 60,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text('Error: ${snapshot.error}'),
                                )
                              ];
                            } else {
                              children = const <Widget>[
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
                              ];
                            }
                            return Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                textBaseline: TextBaseline.ideographic,
                                textDirection: TextDirection.ltr,
                                children: children,
                              ),
                            );
                          }),
                    )),
          );
        },
        icon: Icon(Icons.info),
      )
    ],
  );
}
