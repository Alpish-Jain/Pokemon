import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon/poke_detail.dart';
import 'dart:convert';

import 'package:pokemon/pokemon.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
    title: 'PokemonApp',
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var url =
      "http://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

  PokeHub pokeHub;

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  void fetchdata() async {
    http.Response res = await http.get(url);

    try {
      var decodedJson = jsonDecode(res.body);
      pokeHub = PokeHub.fromJson(decodedJson);
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokemons!'),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: pokeHub == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.count(
              crossAxisCount: 2,
              children: pokeHub.pokemon
                  .map((poke) => Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PokeDetail(pokemon: poke)));
                          },
                          child: Hero(
                            tag: poke.img,
                            child: Card(
                              elevation: 3.0,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    height: 100.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(poke.img)),
                                    ),
                                  ),
                                  Text(
                                    poke.name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.refresh),
        backgroundColor: Colors.cyan,
      ),
    );
  }
}
