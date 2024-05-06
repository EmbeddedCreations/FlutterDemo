import 'package:flutter/material.dart';
import 'package:flutter_ex/Pokemon_List/constants/constants.dart';
import 'package:flutter_ex/Pokemon_List/repo/api_status.dart';
import 'package:flutter_ex/Pokemon_List/repo/pokemon_services.dart';

import '../models/pokemon_list_model.dart';

class PokemonViewModel extends ChangeNotifier{
  bool _loading = false;
  bool _uploadStatus =false;
  bool _deleteStatus = false;
  bool  _patchStatus = false;
  bool _getStatus = false;
  bool _isLoading = false;
  List<PokemonModel> _pokemonListModel = [];

  bool get loading => _loading;
  List<PokemonModel> get pokemonListModel => _pokemonListModel;
  bool get uploadStatus => _uploadStatus;
  bool get deleteStatus => _deleteStatus;
  bool get patchStatus => _patchStatus;
  bool get getStatus => _getStatus;
  bool get isLoading => _isLoading;

  PokemonViewModel(){
    getPokemons();
  }
  setLoading(bool loading) async{
    _loading = loading;
    notifyListeners();
  }

  setPokemonListModel(List<PokemonModel> pokemonList){
    _pokemonListModel = pokemonList;
  }
  setDeleteStatus(bool status){
    _deleteStatus = status;
  }
  setUploadStatus(bool status){
    _uploadStatus= status;
  }
  setPatchStatus(bool status){
    _patchStatus = status;
  }
  setGetStatus(bool status){
    _getStatus = status;
  }
  setLoadingStatus(bool status){
    _isLoading = status;
  }

  getPokemons() async{
    setLoading(true);
    var response = await PokemonServices.getPokemonList();
    if(response is Success){
      setPokemonListModel(response.resp as List<PokemonModel>);
      setGetStatus(true);
    }
    if(response is Failure){
      print(response);
      setGetStatus(false);
    }
    setLoading(false);
  }

  deletePokemon(String id) async{
    setLoading(true);
    var response = await PokemonServices.deletePokemon(id);
    if(response is Success){
      setDeleteStatus(true);
    }
    if(response is Failure){
      setDeleteStatus(false);
    }
    setLoading(false);
  }

  postPokemon(PokemonModel pokemon) async{
    setLoading(true);
    var response = await PokemonServices.addPokemon(pokemon);
    if(response is Success){
      setUploadStatus(true);
    }
    if(response is Failure){
      setUploadStatus(false);
    }
    setLoading(false);
  }

  patchPokemon(String id,String description) async{
    setLoading(true);
    var response = await PokemonServices.updatePokemonDescription(id, description);
    if(response is Success){
      setPatchStatus(true);
    }
    if(response is Failure){
      setPatchStatus(false);
    }
    setLoading(false);
  }
}