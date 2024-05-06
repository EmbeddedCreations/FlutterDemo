import 'dart:convert';

import 'package:flutter_ex/Pokemon_List/constants/constants.dart';
import 'package:flutter_ex/Pokemon_List/models/pokemon_list_model.dart';
import 'package:flutter_ex/Pokemon_List/repo/api_status.dart';
import 'package:http/http.dart' as http;

class PokemonServices {
  static Future<Object> getPokemonList() async {
    try {
      var url = Uri.parse(API_URL);
      var resp = await http.get(url);
      if (resp.body != null && resp.body.isNotEmpty) {
        return Success(code: 200, resp: pokemonListModelFromJson(resp.body));
      } else {
        print('Response body is empty or null');
        return Failure(code: 500, errResp: INTERNAL_SERVER_ERROR);
      }
    } catch (e) {
      print('Exception: $e');
      return Failure(code: 500, errResp: INTERNAL_SERVER_ERROR);
    }
  }

  static Future<Object> addPokemon(PokemonModel pokemon) async {
    try {
      var url = Uri.parse(API_URL);
      print(pokemon.toJson());
      var resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(pokemon.toJson()));
      if (resp.statusCode == 200 && resp.body != null && resp.body.isNotEmpty) {
        return Success(code: 200, resp: "Pokemon Added Successfully");
      } else {
        print(resp.body);
        print('Failed to add Pokemon');
        return Failure(code: 500, errResp: INTERNAL_SERVER_ERROR);
      }
    } catch (e) {
      print('Exception: $e');
      return Failure(code: 500, errResp: INTERNAL_SERVER_ERROR);
    }
  }

  static Future<Object> deletePokemon(String pokemonId) async {
    try {
      var url = Uri.parse('$API_URL?id=$pokemonId');
      var resp = await http.delete(url);
      if (resp.statusCode == 200 && resp.body != null && resp.body.isNotEmpty) {
        return Success(code: 200, resp: "Pokemon Deleted Successfully");
      } else {
        print(resp.body);
        print('Failed to delete Pokemon');
        return Failure(code: 500, errResp: INTERNAL_SERVER_ERROR);
      }
    } catch (e) {
      print('Exception: $e');
      return Failure(code: 500, errResp: INTERNAL_SERVER_ERROR);
    }
  }
  static Future<Object> updatePokemonDescription(String pokemonId, String newDescription) async {
    try {
      var url = Uri.parse('$API_URL?&description=$newDescription');
      var resp = await http.patch(url);
      if (resp.statusCode == 200 && resp.body != null && resp.body.isNotEmpty) {
        return Success(code: 200, resp: "Description Updated Successfully");
      } else {
        print('Failed to update Pokemon description');
        return Failure(code: 500, errResp: INTERNAL_SERVER_ERROR);
      }
    } catch (e) {
      print('Exception: $e');
      return Failure(code: 500, errResp: INTERNAL_SERVER_ERROR);
    }
  }
}

