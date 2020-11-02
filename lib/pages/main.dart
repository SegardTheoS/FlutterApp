import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/pages/PageHome.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> main() async {
  runApp(Login());
  await Firebase.initializeApp();
}

class Login extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      home: MyHomePage(title: 'Movies App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color color = const Color(0xFF383838);
  Color bgColor = Colors.red;
  final _formKey = GlobalKey<FormState>();
  Function validator;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _userEmail;
  bool _connected;
  FocusNode myFocusNode;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    // Clean up the focus node when the Form is disposed.
    myFocusNode = FocusNode();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color,
      body:
      Stack(
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.transparent],
              ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
            },
            blendMode: BlendMode.dstIn,
            child:Container(
              height: 450,
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      fit: BoxFit.fitWidth,
                      alignment: FractionalOffset.topCenter,
                      image: new AssetImage("assets/images/film_affiche.jpg")
                  )
              ),
            )
          ),
          Container(
            margin: const EdgeInsets.only(top: 350),
            child: Form(
                key: _formKey,
                child: Column(
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
                          controller: _emailController,
                          autofocus: true,
                          focusNode: myFocusNode,
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
                              return 'champ manquant';
                            } else if (!EmailValidator.validate(value)) {

                              return 'l\'email est mal écrit';
                            }
                            return null;
                          },
                          onSaved: (String value) => value.trim(),
                          style: TextStyle(color: Colors.redAccent),
                          keyboardType: TextInputType.emailAddress
                      ),
                    ),

                    Container(
                        margin: const EdgeInsets.only(bottom: 10, left: 30, right: 30),
                        child: TextFormField(
                          controller: _passwordController,
                          focusNode: myFocusNode,
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

                              return 'champ manquant';
                            } else if (value.length < 8) {

                              return 'le mot de passe doit contenir 8 caratères min';
                            }
                            return null;
                          },
                          onSaved: (String value) => value.trim(),
                          style: TextStyle(color: Colors.redAccent),
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
                                          _signInWithEmailAndPassword();
                                        }
                                      },
                                      child: Text('Connexion'),
                                    )
                                )
                        )
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        _connected == null
                            ? ''
                            : (_connected
                            ? 'Successfully signed in, mail : ' + _userEmail
                            : 'Sign in failed'),
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                )
            ),
          )
        ],
      )
    );
  }

  void _register() async {
    print(_emailController.text);
    print(_passwordController.text);
    final FirebaseUser user = (await
    _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )
    ).user;
    if (user != null) {
      setState(() {
        _userEmail = user.email;
      });
    } else {
      setState(() {

      });
    }
  }
  void _signInWithEmailAndPassword() async {
    final UserCredential user = (await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ));

    if (user != null) {
      setState(() {
        _connected = true;
        _userEmail = user.user.email;
        Navigator.of(context).push(_createRouteHOME(user, _auth));
      });
    } else {
      setState(() {
        _connected = false;
      });
    }
  }
}

Route _createRouteHOME(UserCredential user, FirebaseAuth auth) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => PageHome(user, auth),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(5.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}