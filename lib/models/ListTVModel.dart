import 'GenreModel.dart';

class ListTvModel{
  int _page;
  int _totalResults;
  int _totalPages;
  List<Tv> _tvs = [];

  ListTvModel.fromJSON(Map<String, dynamic> parsedJson) {
    _page = parsedJson['page'];
    _totalPages = parsedJson['total_pages'];
    _totalResults = parsedJson['total_results'];
    List<Tv> temp = [];

    for(int i=0; i< parsedJson['results'].length; i++){
      Tv result = Tv(parsedJson['results'][i]);
      temp.add(result);
    }

    _tvs = temp;
  }

  List<Tv> get results => _tvs;

  int get totalPages => _totalPages;

  int get totalResults => _totalResults;

  int get page => _page;

}


class Tv {
  int _voteCount;
  int _id;
  var _voteAverage;
  String _name;
  double _popularity;
  String _posterPath;
  String _originalLanguage;
  String _originalName;
  List<Genre> _genres;
  String _backdropPath;
  String _overview;
  String _firstAirdate;
  int _numberOfSeasons;

  Tv(result) {
    _voteCount = result['vote_count'];
    _id = result['id'];
    _voteAverage = result['vote_average'];
    _name = result['name'];
    _popularity = result['popularity'];
    _posterPath = result['poster_path'];
    _originalLanguage = result['original_language'];
    _originalName = result['original_name'];

    _backdropPath = result['backdrop_path'];
    _overview = result['overview'];
    _firstAirdate = result['first_air_date'];
    _numberOfSeasons = result['number_of_seasons'];
  }

  Tv.fromJSON(Map<String, dynamic> parsedJson) {
    _voteCount = parsedJson['vote_count'];
    _id = parsedJson['id'];
    _voteAverage = parsedJson['vote_average'];
    _name = parsedJson['name'];
    _popularity = parsedJson['popularity'];
    _posterPath = parsedJson['poster_path'];
    _originalLanguage = parsedJson['original_language'];
    _originalName = parsedJson['original_name'];

    _genres = parsedJson['genres'] == null ? null : [];

    for (var genresItem in _genres == null ? [] : parsedJson['genres']) {
      _genres.add(genresItem == null ? null : new Genre.fromJson(genresItem));
    }

    _backdropPath = parsedJson['backdrop_path'];
    _overview = parsedJson['overview'];
    _firstAirdate = parsedJson['first_air_date'];
    _numberOfSeasons = parsedJson['number_of_seasons'];
  }

  String get firstAirDate =>_firstAirdate;

  String get overview => _overview;

  String get backdropPath => _backdropPath;

  List<Genre> get genres => _genres;

  String get originalName => _originalName;

  String get originalLanguage => _originalLanguage;

  String get posterPath => _posterPath;

  double get popularity => _popularity;

  String get name => _name;

  int get numberOfSeasons => _numberOfSeasons;

  double get voteAverage => _voteAverage.toDouble();

  int get id => _id;

  int get voteCount => _voteCount;
}