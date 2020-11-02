import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/Api.dart';
import 'package:flutter_app/models/ListFilmModel.dart';
import 'package:flutter_app/models/ListTVModel.dart';

import 'PageDetailsMovie.dart';
import 'PageDetailsTv.dart';
import 'main.dart';

class PageHome extends StatelessWidget {
  // Déclaration API
  Api futureFilm = new Api();
  Future<ListFilmModel> fetchMovieList;
  Future<ListTvModel> fetchTVPopular;
  Future<ListFilmModel> fetchMovieBest;
  UserCredential user;
  FirebaseAuth auth;

  PageHome(UserCredential user, FirebaseAuth auth) {
    this.user = user;
    this.auth = auth;
  }

  @override
  Widget build(BuildContext context) {
    const color = const Color(0xFF383838);
    const colorBarApp = const Color(0xFF212121);
    Api api = new Api();
    fetchMovieList = api.fetchMovieList();
    fetchTVPopular = api.fetchTVPopular();
    fetchMovieBest = api.fetchMovieBest();

    return Scaffold(
        appBar: AppBar(
          title: Text(user.user.email),
          backgroundColor: colorBarApp,
          actions: <Widget>[
            Builder(builder: (BuildContext context) {
//5
              return FlatButton(
                child: Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                  size: 24.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
                textColor: Theme
                    .of(context)
                    .buttonColor,
                onPressed: () async {
                  final User user = await auth.currentUser;
                  if (user == null) {
//6
                    Scaffold.of(context).showSnackBar(const SnackBar(
                      content: Text('No one has signed in.'),
                    ));
                    return;
                  }
                  await auth.signOut();

                  Navigator.of(context).push(_createRouteLOGIN());
                },
              );
            })
          ],
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: color,
        body: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10.0, top: 20, bottom: 10),
                          child: Text("Popular Movies", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30)),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          child: Expanded(
                            child: SizedBox(
                              height: 200.0,
                              child: FutureBuilder<ListFilmModel>(
                                future: fetchMovieList,
                                builder: (context, moviePopular) {
                                  if (moviePopular.hasData) {
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: moviePopular.data.results.length,
                                      itemBuilder: (context, index) {
                                        Film film = moviePopular.data.results[index];
                                        return Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(left: 10.0, right: 20.0),
                                              width: 120.0,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(_createRoute(film.id));
                                                },
                                                child: Image.network(
                                                  'https://image.tmdb.org/t/p/w185${film.posterPath}',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  } else if (moviePopular.hasError) {

                                    return Text("${moviePopular.error}");
                                  }

                                  return CircularProgressIndicator();
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10.0, top: 40, bottom: 10),
                          child: Text("Popular TV Shows", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30)),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          child: Expanded(
                            child: SizedBox(
                              height: 200.0,
                              child: FutureBuilder<ListTvModel>(
                                future: fetchTVPopular,
                                builder: (context, tvPopular) {
                                  if (tvPopular.hasData) {
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: tvPopular.data.results.length,
                                      itemBuilder: (context, index) {
                                        Tv tv = tvPopular.data.results[index];
                                        return Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(left: 10.0, right: 20.0),
                                              width: 120.0,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(_createRouteTV(tv.id, tv));
                                                },
                                                child: Image.network(
                                                  'https://image.tmdb.org/t/p/w185${tv.posterPath}',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  } else if (tvPopular.hasError) {

                                    return Text("${tvPopular.error}");
                                  }

                                  // By default, show a loading spinner.
                                  return CircularProgressIndicator();
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10.0, top: 40, bottom: 10),
                          child: Text("Best Movies", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30)),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          child: Expanded(
                            child: SizedBox(
                              height: 200.0,
                              child: FutureBuilder<ListFilmModel>(
                                future: fetchMovieBest,
                                builder: (context, movieBest) {
                                  if (movieBest.hasData) {
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: movieBest.data.results.length,
                                      itemBuilder: (context, index) {
                                        Film film = movieBest.data.results[index];
                                        return Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(left: 10.0, right: 20.0),
                                              width: 120.0,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(_createRoute(film.id));
                                                },
                                                child: Image.network(
                                                  'https://image.tmdb.org/t/p/w185${film.posterPath}',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  } else if (movieBest.hasError) {

                                    return Text("${movieBest.error}");
                                  }

                                  // By default, show a loading spinner.
                                  return CircularProgressIndicator();
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ]
              )
            ]
        )
    );
  }
}

// ROUTES pour les détails:

Route _createRoute(int idFilm) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => PageDetailsMovie(idFilm),
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

Route _createRouteTV(int idTv, Tv tv) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => PageDetailsTv(idTv, tv),
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

Route _createRouteLOGIN() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Login(),
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
