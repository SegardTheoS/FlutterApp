import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class PageConnexion extends StatefulWidget {

  @override
  _PageConnexionState createState() => _PageConnexionState();
}

class _PageConnexionState extends State<PageConnexion> {
  Color color = const Color(0xFF383838);
  Color bgColor = Colors.red;
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  Function validator;

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text(snapshot.error.toString(), style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 27));

        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
              backgroundColor: color,
              body: Stack(
                children: [
                  AspectRatio(
                      aspectRatio: 500 / 500,
                      child: Container(
                          margin: const EdgeInsets.only(top: 0),
                          child: ShaderMask(
                              shaderCallback: (rect) {
                                return LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.black, Colors.transparent],
                                ).createShader(Rect.fromLTRB(
                                    0, 125, rect.width, rect.height));
                              },
                              blendMode: BlendMode.dstIn,
                              child:  Image.asset("assets/images/image2.jpeg",
                                fit: BoxFit.cover,)
                          )
                      )
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 30),
                            child: Text("Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 27)),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10, left: 30, right: 30),
                            child: TextFormField(
                                autofocus: true,
                                // controller: controller,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  focusColor: Colors.white,
                                  hoverColor: Colors.white,
                                  hintText: "username",
                                  contentPadding: const EdgeInsets.all(20.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white30,
                                    ),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  disabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white30,
                                    ),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  focusedErrorBorder: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.white24,
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter some text';
                                  } else if (!EmailValidator.validate(value)) {

                                    return 'l\'email est mal écrit';
                                  }
                                  return null;
                                },
                                onSaved: (String value) => value.trim(),
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.emailAddress
                            ),
                          ),

                          Container(
                              margin: const EdgeInsets.only(bottom: 10, left: 30, right: 30),
                              child: TextFormField(
                                // controller: controller,
                                focusNode: focusNode,
                                obscureText: true,
                                decoration: InputDecoration(
                                  focusColor: Colors.white,
                                  hoverColor: Colors.white,
                                  hintText: "password",
                                  contentPadding: const EdgeInsets.all(20.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white30,
                                    ),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  disabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white30,
                                    ),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  focusedErrorBorder: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.white24,
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {

                                    return 'Please enter some text';
                                  } else if (value.length != 8) {

                                    return 'le mot de passe doit contenir 8 caratères min';
                                  }
                                  return null;
                                },
                                onSaved: (String value) => value.trim(),
                                style: TextStyle(color: Colors.white),
                              )
                          ),
                          Container(
                              child:  Builder(
                                  builder: (context) =>
                                      Center(
                                          child:  FlatButton(
                                            color: Colors.redAccent,
                                            textColor: Colors.white,
                                            onPressed: () {
                                              if (_formKey.currentState.validate()) {
                                                Scaffold
                                                    .of(context)
                                                    .showSnackBar(SnackBar(content: Text('Processing Data')));
                                              }
                                            },
                                            child: Text('Submit'),
                                          )
                                      )
                              )
                          )
                        ],
                      )
                  )
                ],
              )
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Text('LOADING');
      },
    );
  }
}