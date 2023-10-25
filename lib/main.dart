import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App de Peliculas',
      home: PeliculaAppList(),
    );
  }
}

class PeliculaAppList extends StatefulWidget {
  @override
  _PeliculaAppListState createState() => _PeliculaAppListState();
}

class _PeliculaAppListState extends State<PeliculaAppList> {
  List<PeliculaApp> movies = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final apiKey =
        'a414fbf7aed71ff115a6d64940233dc3'; // Reemplaza con tu API Key de TMDb
    final uri =
        Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=$apiKey');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'];

      setState(() {
        movies = results
            .map<PeliculaApp>((json) => PeliculaApp.fromJson(json))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas Populares'),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(movies[index].title),
            subtitle: Text(movies[index].overview),
          );
        },
      ),
    );
  }
}

class PeliculaApp {
  final String title;
  final String overview;

  PeliculaApp({
    required this.title,
    required this.overview,
  });

  factory PeliculaApp.fromJson(Map<String, dynamic> json) {
    return PeliculaApp(
      title: json['title'],
      overview: json['overview'],
    );
  }
}
