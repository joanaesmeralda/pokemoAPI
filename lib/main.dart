import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokemonapi/modelo/pokemon.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pokemonapi/pokemon_info.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List nombre = [];
  List img = [];
  List alto = [];
  List tipo = [];
  List<pokemon> pokemones = [];
  late Future<List<pokemon>> listaPokemon;
  List datos = [];
  var url = Uri.https("raw.githubusercontent.com",
      "/Biuni/PokemonGO-Pokedex/master/pokedex.json");
  Future<List<pokemon>> getPokemon() async {
    final respuesta = await http.get(url);

    List datos = [];

    if (respuesta.statusCode == 200) {
      //verificacion codigo de estado de respuesta
      String body = utf8.decode(respuesta.bodyBytes);
      final jsonDatos = jsonDecode(body); //convierte en json los datos de body

      for (var item in jsonDatos["pokemon"]) {
        nombre.add(item["name"]);
        img.add(item["img"]);
        alto.add(item["height"]);
        tipo.add(item["type"]);
      }

      pokemones = List.generate(
          nombre.length,
          (index) => pokemon('${nombre[index]}', '${alto[index]}',
              '${tipo[index]}', '${img[index]}'));

      return pokemones;
    } else {
      throw Exception("Conexión Fallida");
    }
  }

  @override
  void initState() {
    super.initState();
    listaPokemon = getPokemon();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemones',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pokemon'),
          backgroundColor: Color.fromARGB(255, 34, 61, 134),
        ),
        body: FutureBuilder(
          future: listaPokemon,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: _listaPokemon(pokemones),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Text("Error");
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _listaPokemon(List<pokemon> data) {
    List<Widget> pokemon = [];

    for (var p in data) {
      pokemon.add(
        Card(
          child: Column(
            children: [
              Image.network(p.urlImagen),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      p.nombre,
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 6.0,
                      ),
                    ),
                    Text(
                      "Tipo " + p.tipo,
                      style: TextStyle(fontSize: 15.0),
                    ),
                    Text(
                      p.alto,
                      style: TextStyle(fontSize: 10.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return pokemon;
  }
}
