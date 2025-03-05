import 'package:flutter/material.dart';
import 'package:app_filmes/screens/form_screen.dart';
import 'package:app_filmes/widgets/filme_tile.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meus Filmes')),
      body: ListView.builder(
        itemCount: 10, // Substitua pelo número real de filmes
        itemBuilder: (context, index) {
          return FilmeTile(
            filme: 'Filme $index', // Substitua pelos dados reais do filme
            onTap: () {
              // Navegar para a tela de edição
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormScreen(filme: 'Filme $index')),
              );
            },
            onLongPress: () {
              // Ação para remover o filme
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/cadastro');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
