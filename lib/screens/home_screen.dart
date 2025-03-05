import 'package:flutter/material.dart';
import '../models/filme.dart';
import '../database/database_helper.dart';
import 'form_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Filme> filmes = [];

  @override
  void initState() {
    super.initState();
    carregarFilmes();
  }

  Future<void> carregarFilmes() async {
    filmes = await DatabaseHelper.instance.getFilmes();
    setState(() {});
  }

  void removerFilme(int id) async {
    await DatabaseHelper.instance.deleteFilme(id);
    carregarFilmes();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Filme removido!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meus Filmes')),
      body: ListView.builder(
        itemCount: filmes.length,
        itemBuilder: (context, index) {
          final filme = filmes[index];
          return ListTile(
            leading: Image.network(filme.urlCartaz, width: 50, height: 50, fit: BoxFit.cover),
            title: Text(filme.titulo),
            subtitle: Text('${filme.ano} - ${filme.direcao}'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FormScreen(filme: filme, onSave: carregarFilmes)),
            ),
            onLongPress: () => removerFilme(filme.id!),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FormScreen(onSave: carregarFilmes)),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
