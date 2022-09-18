// To parse this JSON data, do
//
//     final placesResponse = placesResponseFromMap(jsonString);

import 'dart:convert';

class PlacesResponse {
  PlacesResponse({
    required this.type,
    required this.query,
    required this.features,
    required this.attribution,
  });

  final String type;
  final List<String> query;
  final List<Feature> features;
  final String attribution;

  factory PlacesResponse.fromJson(String str) => PlacesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PlacesResponse.fromMap(Map<String, dynamic> json) => PlacesResponse(
    type: json["type"],
    query: List<String>.from(json["query"].map((x) => x)),
    features: List<Feature>.from(json["features"].map((x) => Feature.fromMap(x))),
    attribution: json["attribution"],
  );

  Map<String, dynamic> toMap() => {
    "type": type,
    "query": List<dynamic>.from(query.map((x) => x)),
    "features": List<dynamic>.from(features.map((x) => x.toMap())),
    "attribution": attribution,
  };
}

class Feature {
  Feature({
    this.id,
    this.type,
    required this.placeType,
    required this.properties,
    this.textEs,
    this.placeNameEs,
    this.text,
    this.placeName,
    required this.center,
    required this.geometry,
    required this.context,
  });

  final String? id;
  final String? type;
  final List<String> placeType;
  final Properties properties;
  final String? textEs;
  final String? placeNameEs;
  final String? text;
  final String? placeName;
  final List<double> center;
  final Geometry geometry;
  final List<Context> context;

  factory Feature.fromJson(String str) => Feature.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Feature.fromMap(Map<String, dynamic> json) => Feature(
    id: json["id"],
    type: json["type"],
    placeType: List<String>.from(json["place_type"].map((x) => x)),
    properties: Properties.fromMap(json["properties"]),
    textEs: json["text_es"],
    placeNameEs: json["place_name_es"],
    text: json["text"],
    placeName: json["place_name"],
    center: List<double>.from(json["center"].map((x) => x.toDouble())),
    geometry: Geometry.fromMap(json["geometry"]),
    context: List<Context>.from(json["context"].map((x) => Context.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "type": type,
    "place_type": List<dynamic>.from(placeType.map((x) => x)),
    "properties": properties.toMap(),
    "text_es": textEs,
    "place_name_es": placeNameEs,
    "text": text,
    "place_name": placeName,
    "center": List<dynamic>.from(center.map((x) => x)),
    "geometry": geometry.toMap(),
    "context": List<dynamic>.from(context.map((x) => x.toMap())),
  };
}

class Context {
  Context({
    this.id,
    this.textEs,
    this.text,
    this.wikidata,
    this.languageEs,
    this.language,
    this.shortCode,
  });

  final String? id;
  final String? textEs;
  final String? text;
  final String? wikidata;
  final Language? languageEs;
  final Language? language;
  final String? shortCode;

  factory Context.fromJson(String str) => Context.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Context.fromMap(Map<String, dynamic> json) => Context(
    id: json["id"],
    textEs: json["text_es"],
    text: json["text"],
    wikidata: json["wikidata"] ?? json["wikidata"],
    languageEs: json["language_es"] == null ? null : languageValues.map[json["language_es"]],
    language: json["language"] == null ? null : languageValues.map[json["language"]],
    shortCode: json["short_code"]?? json["short_code"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "text_es": textEs,
    "text": text,
    "wikidata": wikidata ?? wikidata,
    "language_es": languageEs == null ? null : languageValues.reverse[languageEs],
    "language": language == null ? null : languageValues.reverse[language],
    "short_code": shortCode ?? shortCode,
  };
}

enum Language { ES, NL }

final languageValues = EnumValues({
  "es": Language.ES,
  "nl": Language.NL
});

class Geometry {
  Geometry({
   required this.type,
   required this.coordinates,
  });

  final String type;
  final List<double> coordinates;

  factory Geometry.fromJson(String str) => Geometry.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Geometry.fromMap(Map<String, dynamic> json) => Geometry(
    type: json["type"],
    coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
  );

  Map<String, dynamic> toMap() => {
    "type": type,
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };
}

class Properties {
  Properties({
    this.accuracy,
    this.overridePostcode,
  });

  final String? accuracy;
  final String? overridePostcode;

  factory Properties.fromJson(String str) => Properties.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Properties.fromMap(Map<String, dynamic> json) => Properties(
    accuracy: json["accuracy"],
    overridePostcode: json["override:postcode"] ?? json["override:postcode"],
  );

  Map<String, dynamic> toMap() => {
    "accuracy": accuracy,
    "override:postcode": overridePostcode ?? overridePostcode,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
      reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap!;
  }
}
