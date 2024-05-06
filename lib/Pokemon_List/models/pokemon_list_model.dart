import 'dart:convert';

List<PokemonModel> pokemonListModelFromJson(String str) => List<PokemonModel>.from(json.decode(str).map((x) => PokemonModel.fromJson(x)));

String pokemonListModelToJson(List<PokemonModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PokemonModel {
  String id;
  String name;
  String url;
  String imgUrl;
  String pokemonType;
  String description;

  PokemonModel({
    required this.id,
    required this.name,
    required this.url,
    required this.imgUrl,
    required this.pokemonType,
    required this.description
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) => PokemonModel(
    id : json["PokemonId"],
    name: json["Pokemon_Name"],
    url: json["Pokemon_Url"],
    imgUrl: json["Pokemon_Imgurl"],
    pokemonType: json["Pokemon_Type"],
    description: json["Pokemon_Description"]
  );

  Map<String, dynamic> toJson() => {
    "PokemonId" :  id,
    "Pokemon_Name": name,
    "Pokemon_Url": url,
    "Pokemon_Imgurl": imgUrl,
    "Pokemon_Type" : pokemonType,
    "Pokemon_Description" : description
  };
}
