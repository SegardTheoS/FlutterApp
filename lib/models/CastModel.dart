import 'dart:convert' show json;

class Cast {
  int id;
  String character;
  String name;

  Cast(result){
    id = result['id'];
    character = result['character'];
    name = result['name'];
  }

  Cast.fromParams({this.id, this.character, this.name});

  Cast.fromJSON(parsedJson) {
    id = parsedJson['id'];
    character = parsedJson['character'];
    name = parsedJson['name'];
  }

  @override
  String toString() {
    return '{"id": $id,"name": ${name != null ? '${json.encode(name)}' : 'null'}}';
  }
}

class ListCasts {
  List<Cast> listCast=[];

  ListCasts.fromParams({this.listCast});

  ListCasts.fromJSON(parsedJson) {
    for (int i=0; i< parsedJson['cast'].length; i++) {
      Cast result = Cast(parsedJson['cast'][i]);
      listCast.add(result);
    }
  }
}