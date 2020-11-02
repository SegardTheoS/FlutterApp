import 'package:flutter/material.dart';
import 'package:flutter_app/api/Api.dart';
import 'package:flutter_app/models/CastModel.dart';
import 'package:flutter_app/models/GenreModel.dart';
import 'package:flutter_app/models/ListTVModel.dart';

void main(int idFilm, Tv tv) {
  runApp(PageDetailsTv(idFilm, tv));
}

class PageDetailsTv extends StatelessWidget {
  // Déclaration API et récupération objet TV actuel
  int idTv;
  Tv tv;
  Api api = new Api();
  Future<Tv> fetchTvDetail;
  Future<ListCasts> fetchTvCast;

  PageDetailsTv(int idTv, Tv tv){
    this.idTv = idTv;
    this.tv = tv;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    fetchTvDetail = api.fetchTVDetails(idTv);
    fetchTvCast = api.fetchTvCast(idTv);

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
        backgroundColor: Colors.transparent
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: FutureBuilder<Tv>(
              future: fetchTvDetail,
              builder: (context, tvDetails) {
                if (tvDetails.hasData) {
                  Tv tvDetailsModel = tvDetails.data;
                  return Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: [
                          AspectRatio(
                              aspectRatio: 500 / 450,
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
                                      'https://image.tmdb.org/t/p/w185${tvDetailsModel.posterPath}',
                                      fit: BoxFit.cover,
                                    ),
                                  )
                              )
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 305, left: 15),
                            child: Text(tvDetailsModel.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 27)),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 340.0, left: 15, right: 175),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("saison "+ tvDetails.data.numberOfSeasons.toString(), style: TextStyle(color: Colors.white)),
                                Spacer(),
                                Text("-", style: TextStyle(color: Colors.white)),
                                Spacer(),
                                Text(tvDetailsModel.firstAirDate, style: TextStyle(color: Colors.white)),
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
                                Text(tvDetailsModel.voteAverage.toString(), style: TextStyle(color: Colors.yellow))
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 37.0,
                              child: Row(children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: tvDetails.data.genres.length,
                                    itemBuilder: (context, index) {
                                      Genre genre = tvDetails.data.genres[index];
                                      return   new Container(
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
                                                color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                                      );
                                    }
                                )
                              ]),
                            ),

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
                                        future: fetchTvCast,
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
                                      child: Text(tvDetailsModel.overview, style: TextStyle(color: Colors.white)))
                                ])))
                          ],
                        ),
                      )
                    ],
                  );
                } else if (tvDetails.hasError) {

                  return Center(child: Text("${tvDetails.error}"));
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
