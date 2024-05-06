import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Pokemon_List/constants/constants.dart';
import 'Pokemon_List/models/pokemon_list_model.dart';
import 'Pokemon_List/view_models/pokemon_view_model.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PokemonViewModel pokemonViewModel = context.watch<PokemonViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.blue,
        title: const Row(
          children: [
            Icon(Icons.sports_baseball, size: 40, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Pokédex',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Pokemon',
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: _ui(pokemonViewModel),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context,pokemonViewModel);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue, // Change the button's color if needed
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Align to bottom left
    );
  }

  _ui(PokemonViewModel pokemonViewModel) {
    if (pokemonViewModel.loading) {
      return Container();
    } else if (!pokemonViewModel.getStatus) {
      return Container();
    } else {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: pokemonViewModel.pokemonListModel.length,
            itemBuilder: (context, index) {
              PokemonModel pokemonModel = pokemonViewModel.pokemonListModel[index];
              return GestureDetector(
                onTap: () {
                  // Handle tapping on a Pokémon
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        pokemonModel.imgUrl,
                        width: 120,
                        height: 95,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        pokemonModel.name,
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        pokemonModel.pokemonType,
                        style: const TextStyle(color: Colors.black),
                      ),
                      // Add description here
                      Text(
                        pokemonModel.description,
                        style: const TextStyle(color: Colors.black),
                      ),
                      // Add buttons here
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Handle edit button press
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Adjust padding as needed
                            ),
                            child: const Text(
                              'Edit',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              pokemonViewModel.deletePokemon(pokemonModel.id);
                              if(pokemonViewModel.isLoading){
                                if(pokemonViewModel.deleteStatus){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Pokemon deleted successfully'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Failed to delete Pokemon'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text(
                                'Delete',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }


  void _showFormDialog(BuildContext context, PokemonViewModel pokemonViewModel) {
    // Controllers to hold the values of the form fields
    TextEditingController nameController = TextEditingController();
    TextEditingController infoUrlController = TextEditingController();
    TextEditingController typeController = TextEditingController();
    TextEditingController imageUrlController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add a Pokémon"),
          content: SingleChildScrollView(
            child: Form(
              child: _buildForm(
                nameController,
                infoUrlController,
                typeController,
                imageUrlController,
                descriptionController,
                context,
                pokemonViewModel
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildForm(
      TextEditingController nameController,
      TextEditingController infoUrlController,
      TextEditingController typeController,
      TextEditingController imageUrlController,
      TextEditingController descriptionController,
      BuildContext context,
      PokemonViewModel pokemonViewModel
      ) {
    final _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Pokemon Name'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a Pokemon Name';
              }
              return null;
            },
          ),
          const SizedBox(height: 10), // Adding margin
          TextFormField(
            controller: infoUrlController,
            decoration: const InputDecoration(labelText: 'Pokemon Info Url'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a Pokemon Info Url';
              } else if (!validatePokemonUrl(value)) {
                return 'Please enter a valid Pokemon Info Url';
              }
              return null;
            },
          ),
          const SizedBox(height: 10), // Adding margin
          TextFormField(
            controller: typeController,
            decoration: const InputDecoration(labelText: 'Pokemon Type'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a Pokemon Type';
              }
              return null;
            },
          ),
          const SizedBox(height: 10), // Adding margin
          TextFormField(
            controller: imageUrlController,
            decoration: const InputDecoration(labelText: 'Pokemon Image url'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a Pokemon Image url';
              } else if (!validatePokemonImageUrl(value)) {
                return 'Please enter a valid Pokemon Image url';
              }
              return null;
            },
          ),
          const SizedBox(height: 10), // Adding margin
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: "Pokemon Description"),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a Pokemon Description';
              }
              return null;
            },
          ),
          const SizedBox(height: 20), // Adding more margin
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Add cancel logic here
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, proceed with submission
                    // Save form data
                    String name = nameController.text;
                    String infoUrl = infoUrlController.text;
                    String type = typeController.text;
                    String imageUrl = imageUrlController.text;
                    String description = descriptionController.text;
                    String id = extractIdFromUrl(imageUrl);
                    PokemonModel pokemonModel = PokemonModel(
                      id: id,
                      name: name,
                      url: infoUrl,
                      imgUrl: imageUrl,
                      pokemonType: type,
                      description: description,
                    );
                    pokemonViewModel.postPokemon(pokemonModel);
                    if(pokemonViewModel.isLoading){
                      if(pokemonViewModel.uploadStatus){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pokemon Added successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to Add Pokemon'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }


  String extractIdFromUrl(String imgUrl){
    // Find the index of "png" in the string
    int pngIndex = imgUrl.indexOf("png");

    // If "png" is found, find the last occurrence of "/" before "png"
    if (pngIndex != -1) {
      int lastSlashIndex = imgUrl.lastIndexOf("/", pngIndex);
      // Extract the substring between the last "/" and "png"
      if (lastSlashIndex != -1) {
      String numberString = imgUrl.substring(lastSlashIndex + 1, pngIndex);

      // Print the extracted number as a string
        return numberString;
      }
      return "invalid";
    }
    return "Invalid";
  }

  bool validatePokemonUrl(String url) {
    // Define the regex pattern for the URL
    RegExp regex = RegExp(r'https://pokeapi.co/api/v2/pokemon/\d{1,5}/');

    // Check if the URL matches the pattern
    return regex.hasMatch(url);
  }

  bool validatePokemonImageUrl(String imageUrl) {
    // Define the regex pattern for the image URL
    RegExp regex = RegExp(r'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/[1-9]\d{0,2}\.png');

    // Check if the URL matches the pattern
    return regex.hasMatch(imageUrl);
  }
}


