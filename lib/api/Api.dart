import 'dart:async';
import 'dart:convert';

import 'package:flutter_app/models/CastModel.dart';
import 'package:flutter_app/models/GenreModel.dart';
import 'package:flutter_app/models/ListFilmModel.dart';
import 'package:flutter_app/models/ListTVModel.dart';
import 'package:http/http.dart' as http;

class Api {
  static const urlDetail = "https://api.themoviedb.org/3/movie/";
  static const urlDetailTV = "https://api.themoviedb.org/3/tv/";
  static const urlPopular = "https://api.themoviedb.org/3/movie/popular?language=fr&api_key=";
  static const urlPopularTV = "https://api.themoviedb.org/3/tv/popular?language=fr&api_key=";
  static const urlCast = "http://api.themoviedb.org/3/movie/";
  static const urlCastTV = "http://api.themoviedb.org/3/tv/";
  static const urlMovieBest = "https://api.themoviedb.org/3/movie/top_rated?api_key=";
  static const apiKey = "d2c777dc786704288223d189cc78bbba";

  Future<ListTvModel> fetchTVPopular() async{
    final response = await await http.get(urlPopularTV + apiKey);

    if(response.statusCode == 200){
      return ListTvModel.fromJSON(json.decode(response.body));
    }
    else{
      throw Exception('failed to laod data');
    }
  }

  Future<ListFilmModel> fetchMovieList() async{
    final response = await await http.get(urlPopular + apiKey);

    if(response.statusCode == 200){
      return ListFilmModel.fromJSON(json.decode(response.body));
    }
    else{
      throw Exception('failed to laod data');
    }
  }

  Future<Film> fetchMovieDetails(int idFilm) async{
    final response = await http.get(urlDetail + idFilm.toString() + "?language=fr&append_to_response=release_dates&api_key=" + apiKey);
    print(urlDetail + idFilm.toString() + "?language=fr&append_to_response=release_dates&api_key=" + apiKey);
    // print(response.body);
    if(response.statusCode == 200){
      return Film.fromJSON(json.decode(response.body));
    }
    else{
      throw Exception('failed to laod data');
    }
  }


  Future<Tv> fetchTVDetails(int idTv) async{
    final response = await http.get(urlDetailTV + idTv.toString() + "?language=fr&api_key=" + apiKey);

    if(response.statusCode == 200){
      return Tv.fromJSON(json.decode(response.body));
    }
    else{
      throw Exception('failed to laod data');
    }
  }

  Future<ListCasts> fetchMovieCast(int idFilm) async{
    final response = await http.get(urlCast + idFilm.toString() + "/casts?language=fr&api_key=" + apiKey);

    if(response.statusCode == 200){
      return ListCasts.fromJSON(json.decode(response.body));
    }
    else{
      throw Exception('failed to laod data');
    }
  }

  Future<ListFilmModel> fetchMovieBest() async{
    final response = await http.get(urlMovieBest + apiKey + "&language=fr&page=1");

    if(response.statusCode == 200){
      return ListFilmModel.fromJSON(json.decode(response.body));
    }
    else{
      throw Exception('failed to laod data');
    }
  }

  Future<ListCasts> fetchTvCast(int idTv) async{
    final response = await http.get(urlCastTV + idTv.toString() + "/credits?language=fr&api_key=" + apiKey);

    if(response.statusCode == 200){
      return ListCasts.fromJSON(json.decode(response.body));
    }
    else{
      throw Exception('failed to laod data');
    }
  }

  Future getGenreList() async {
    final response = await http.get('$urlPopular/genre/movie/list?api_key=$apiKey');

    if (response.statusCode == 200) {
      final parsed =
          json.decode(response.body)['genres'].cast>(Genre);

      return parsed
          .map((json) => Genre.fromJson(json))
          .toList();
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}

// Future<Film> fetchAlbum() {
//   return http.get('https://jsonplaceholder.typicode.com/albums/1');
// }

