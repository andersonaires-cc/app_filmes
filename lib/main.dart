import 'package:flutter/material.dart';
import 'package:app_filmes/db/database_helper.dart';
import 'package:app_filmes/models/filme.dart';
import 'package:app_filmes/screens/cadastro_filme_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meus Filmes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Filme>> filmes;

  @override
  void initState() {
    super.initState();
    filmes = DatabaseHelper.instance.getAllFilmes();
  }

  void _refreshList() {
    setState(() {
      filmes = DatabaseHelper.instance.getAllFilmes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meus Filmes')),
      body: FutureBuilder<List<Filme>>(
        future: filmes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum filme cadastrado'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final filme = snapshot.data![index];
              return ListTile(
                title: Text(filme.titulo),
                subtitle: Text(filme.direcao),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await DatabaseHelper.instance.deleteFilme(filme.id!);
                    _refreshList();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Filme removido com sucesso')),
                    );
                  },
                ),
                onTap: () async {
                  final editedFilme = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CadastroFilmeScreen(filme: filme),
                    ),
                  );
                  if (editedFilme != null) {
                    _refreshList();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Filme atualizado com sucesso')),
                    );
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newFilme = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CadastroFilmeScreen()),
          );
          if (newFilme != null) {
            _refreshList();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Filme adicionado com sucesso')),
            );
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
