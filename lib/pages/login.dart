import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:votaapp/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:votaapp/widgets/votes_content.dart';
import '../utils/validatos.dart';
import '../utils/fireauth.dart';

class HomeLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Login();
  }
}

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyHomePage(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
  }

  @override
  void initState() {
    _initializeFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        extendBody: true,
        appBar: AppBar(
          primary: true,
          systemOverlayStyle: null,
          toolbarHeight: 40,
          elevation: 5,
          title: Text(
            "Sign in",
          ),
          backgroundColor: Colors.blueAccent,
        ),
        body: FutureBuilder(
            future: _initializeFirebase(),
            builder: (context, snapshot) {
              return SingleChildScrollView(
                primary: true,
                scrollDirection: Axis.vertical,
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 800,
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.all(30),
                              child: Icon(
                                Icons.account_box,
                                color: Colors.blueAccent,
                                size: 50,
                              )),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: usernameController,
                            validator: (value) =>
                                Validator.validateEmail(email: value),
                            decoration: InputDecoration(
                              hintText: 'Email',
                            ),
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            validator: (value) =>
                                Validator.validatePassword(password: value),
                            decoration: InputDecoration(
                              hintText: 'Password',
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ButtonTheme(
                            child: ElevatedButton(
                                onPressed: () async {
                                  User? user =
                                      await FireAuth.signInUsingEmailPassword(
                                          email: usernameController.text,
                                          password: passwordController.text,
                                          context: context);
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isProcessing = true;
                                    });
                                  }
                                  if (user != null) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage(
                                                user: user,
                                              )),
                                    );
                                  }
                                },
                                child: Column(children: [
                                  _isProcessing
                                      ? CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text("Iniciar session")
                                ]),
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.only(
                                            bottom: 10,
                                            top: 10,
                                            left: 50,
                                            right: 50)),
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.blueAccent))),
                            buttonColor: Colors.amber,
                            splashColor: Colors.black26,
                            padding: EdgeInsets.all(30),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextButton(
                              onPressed: () async {
                                var user = await FirebaseAuth.instance
                                    .signInAnonymously();

                                if (user != null) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePage(
                                              user: user.user,
                                            )),
                                  );
                                }
                              },
                              child: Text("Iniciar como usario anonimo")),
                          SizedBox(
                            height: 30,
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => Register()),
                                );
                              },
                              child: Text("No tienes una cuenta? Registrate"))
                        ],
                      )),
                ),
              );
            }));
  }
}

class Register extends StatefulWidget {
  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  final _registerFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          primary: true,
          systemOverlayStyle: null,
          toolbarHeight: 40,
          elevation: 5,
          title: Text(
            "Sign up",
          ),
          backgroundColor: Colors.blueAccent,
        ),
        body: SingleChildScrollView(
          primary: true,
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.all(10),
            height: 800,
            child: Form(
                key: _registerFormKey,
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(30),
                        child: Icon(
                          Icons.app_registration,
                          color: Colors.blueAccent,
                          size: 50,
                        )),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: nameController,
                      validator: (value) => Validator.validateName(name: value),
                      decoration: InputDecoration(
                          hintText: 'Nombre', helperText: "Su nombre!"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: (value) =>
                          Validator.validateEmail(email: value),
                      decoration: InputDecoration(
                          hintText: 'Email', helperText: "Aqui va su email"),
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      validator: (value) =>
                          Validator.validatePassword(password: value),
                      decoration: InputDecoration(
                          hintText: 'Password',
                          helperText: "Here your password"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ButtonTheme(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_registerFormKey.currentState!.validate()) {
                            User? user =
                                await FireAuth.registerUsingEmailPassword(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                            );

                            if (user != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green[400],
                                  content: Text(
                                      "Cuenta creada con exito, regresa al inicio para iniciar"),
                                  onVisible: () {
                                    nameController.text = "";
                                    emailController.text = "";
                                    passwordController.text = "";
                                  },
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red[400],
                                  content: Text(
                                      "Esta cuenta ya existe, intente creando otra"),
                                  onVisible: () {
                                    nameController.text = "";
                                    emailController.text = "";
                                    passwordController.text = "";
                                  },
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          }
                        },
                        child: Text("Crear cuenta"),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.blueAccent)),
                      ),
                      buttonColor: Colors.amber,
                      splashColor: Colors.black26,
                      padding: EdgeInsets.all(30),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                )),
          ),
        ));
  }
}
