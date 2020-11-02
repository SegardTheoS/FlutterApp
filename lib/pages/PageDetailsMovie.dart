import 'package:flutter/material.dart';
import 'package:flutter_app/api/Api.dart';
import 'package:flutter_app/models/CastModel.dart';
import 'package:flutter_app/models/GenreModel.dart';
import 'package:flutter_app/models/ListFilmModel.dart';

void main(int idFilm) {
  runApp(PageDetailsMovie(idFilm));
}

class PageDetailsMovie extends StatelessWidget {
  // Déclaration API
  int idFilm;
  Api api = new Api();
  Future<Film> fetchMovieDetail;
  Future<ListCasts> fetchMovieCast;

  PageDetailsMovie(int idFilm){
    this.idFilm = idFilm;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    fetchMovieDetail = api.fetchMovieDetails(idFilm);
    fetchMovieCast = api.fetchMovieCast(idFilm);

    const color = const Color(0xFF383838);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: color,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('', style: TextStyle(color: Colors.amber)),
        backgroundColor: Colors.transparent,
        // elevation: 0.0
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: FutureBuilder<Film>(
              future: fetchMovieDetail,
              builder: (context, film) {
                if (film.hasData) {
                  Film filmModel = film.data;
                  return Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: [
                          AspectRatio(
                              aspectRatio: 350 / 450,
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
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w185${filmModel.posterPath}',
                                      fit: BoxFit.fill,
                                    ),
                                )
                              )
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 390, left: 15),
                            child: Text(filmModel.title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26)),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 450.0, left: 15, right: 200),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(filmModel.certificationAge.toString(), style: TextStyle(color: Colors.white)),
                                Spacer(),
                                Text("-", style: TextStyle(color: Colors.white)),
                                Spacer(),
                                Text(filmModel.releasDate, style: TextStyle(color: Colors.white)),
                                Spacer(),
                                Text("-", style: TextStyle(color: Colors.white)),
                                Spacer(),
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 15.0,
                                  semanticLabel: 'note',
                                ),
                                Spacer(),
                                Text(filmModel.voteAverage.toString(), style: TextStyle(color: Colors.yellow))
                              ],
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(
                                  top: 480.0, left: 15),
                            height: 40,
                            child:  ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: filmModel.genres.length,
                                itemBuilder: (context, index) {
                                  Genre genre = filmModel.genres[index];
                                  return new Container(
                                    margin: const EdgeInsets.all(5.0),
                                    padding: const EdgeInsets.all(4.0),
                                    // backgroundColor: Colors.white,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.white),
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(5.0))),
                                    child: Text(genre.name,
                                        style: TextStyle(
                                            color: color, fontWeight: FontWeight.bold)),
                                  );
                                }
                            )
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                new Container(
                                  margin: const EdgeInsets.only(top: 25.0),
                                  child: Text("Cast : ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 41.0,
                                  child: Container(
                                      margin: const EdgeInsets.only(top: 25.0),
                                      child:  FutureBuilder<ListCasts>(
                                        future: fetchMovieCast,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: snapshot.data.listCast.length,
                                              itemBuilder: (context, index) {
                                                Cast cast = snapshot.data.listCast[index];
                                                return Column(
                                                  children: <Widget>[
                                                    Text(cast.name+", ", style: TextStyle(
                                                        color: Colors.white))
                                                  ],
                                                );
                                              },
                                            );
                                          } else if (snapshot.hasError) {

                                            return Text("${snapshot.error}");
                                          }

                                          // By default, show a loading spinner.
                                          return CircularProgressIndicator();
                                        },
                                      ),
                                  ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 25.0),
                                child: (Row(children: [
                                  new Container(
                                      child: Text("Summary",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)))
                                ]))),
                            Container(
                                margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                                child: (Row(children: [
                                  new Expanded(
                                      child: Text(filmModel.overview, style: TextStyle(color: Colors.white)))
                                ])))
                          ],
                        ),
                      )
                    ],
                  );
                } else if (film.hasError) {

                  return Center(child: Text("${film.error}"));
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}
