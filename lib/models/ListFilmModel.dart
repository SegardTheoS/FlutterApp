import 'GenreModel.dart';

class ListFilmModel{
  int _page;
  int _totalResults;
  int _totalPages;
  List<Film> _films = [];

  ListFilmModel.fromJSON(Map<String, dynamic> parsedJson) {
    _page = parsedJson['page'];
    _totalPages = parsedJson['total_pages'];
    _totalResults = parsedJson['total_results'];
    List<Film> temp = [];

    for(int i=0; i< parsedJson['results'].length; i++){
      Film result = Film(parsedJson['results'][i]);
      temp.add(result);
    }

    _films = temp;
  }

  List<Film> get results => _films;

  int get totalPages => _totalPages;

  int get totalResults => _totalResults;

  int get page => _page;

}


class Film {
  int _voteCount;
  int _id;
  bool _video;
  var _voteAverage;
  String _title;
  double _popularity;
  String _posterPath;
  String _originalLanguage;
  String _originalTitle;
  List<Genre> _genres;
  String _backdropPath;
  bool _adult;
  String _overview;
  String _releaseDate;
  String _certificationAge = "?";

  Film(result) {
    _voteCount = result['vote_count'];
    _id = result['id'];
    _video = result['video'];
    _voteAverage = result['vote_average'];
    _title = result['title'];
    _popularity = result['popularity'];
    _posterPath = result['poster_path'];
    _originalLanguage = result['original_language'];
    _originalTitle = result['original_title'];

    _backdropPath = result['backdrop_path'];
    _adult = result['adult'];
    _overview = result['overview'];
    _releaseDate = result['release_date'];

    if(result['release_dates'] != null) {
      for(int i=0; i< result['release_dates']["results"].length; i++){
        if(result['release_dates']["results"][i]['iso_3166_1'] == 'RU') {
          if(result['release_dates']["results"][i]["release_dates"][0]['certification'] != "") {
            _certificationAge = result['release_dates']["results"][i]["release_dates"][0]['certification'];
          }
        } else if(result['release_dates']["results"][i]['iso_3166_1'] == 'TR') {
          if(result['release_dates']["results"][i]["release_dates"][0]['certification'] != "") {
            _certificationAge = result['release_dates']["results"][i]["release_dates"][0]['certification'];
          }
        }
      }
    }
  }

  Film.fromJSON(Map<String, dynamic> parsedJson) {
    _voteCount = parsedJson['vote_count'];
    _id = parsedJson['id'];
    _video = parsedJson['video'];
    _voteAverage = parsedJson['vote_average'];
    _title = parsedJson['title'];
    _popularity = parsedJson['popularity'];
    _posterPath = parsedJson['poster_path'];
    _originalLanguage = parsedJson['original_language'];
    _originalTitle = parsedJson['original_title'];

    _genres = parsedJson['genres'] == null ? null : [];

    for (var genresItem in _genres == null ? [] : parsedJson['genres']) {
      _genres.add(genresItem == null ? null : new Genre.fromJson(genresItem));
    }

    _backdropPath = parsedJson['backdrop_path'];
    _adult = parsedJson['adult'];
    _overview = parsedJson['overview'];
    _releaseDate = parsedJson['release_date'];

    if(parsedJson['release_dates'] != null) {
      for(int i=0; i< parsedJson['release_dates']["results"].length; i++){
        if(parsedJson['release_dates']["results"][i]['iso_3166_1'] == 'RU') {
          if(parsedJson['release_dates']["results"][i]["release_dates"][0]['certification'] != "") {
            _certificationAge = parsedJson['release_dates']["results"][i]["release_dates"][0]['certification'];
          }
        } else if(parsedJson['release_dates']["results"][i]['iso_3166_1'] == 'TR') {
          if(parsedJson['release_dates']["results"][i]["release_dates"][0]['certification'] != "") {
            _certificationAge = parsedJson['release_dates']["results"][i]["release_dates"][0]['certification'];
          }
        }
      }
    }
  }

  String get releasDate =>_releaseDate;

  String get certificationAge =>_certificationAge;

  String get overview => _overview;

  bool get adult => _adult;

  String get backdropPath => _backdropPath;

  List<Genre> get genres => _genres;

  String get originalTitle => _originalTitle;

  String get originalLanguage => _originalLanguage;

  String get posterPath => _posterPath;

  double get popularity => _popularity;

  String get title => _title;

  double get voteAverage => _voteAverage.toDouble();

  bool get video => _video;

  int get id => _id;

  int get voteCount => _voteCount;
}