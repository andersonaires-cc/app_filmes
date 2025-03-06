import 'dart:io';
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

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Column(
                  children: [
                    // Exibição da Imagem do Filme
                    if (filme.urlCartaz != null && filme.urlCartaz!.isNotEmpty)
                      ClipRRect(
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                        child: filme.urlCartaz!.startsWith('http')
                            ? Image.network(
                          filme.urlCartaz!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 200,
                                color: Colors.grey[300],
                                child: Icon(Icons.broken_image, size: 80),
                              ),
                        )
                            : Image.file(
                          File(filme.urlCartaz!),
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 200,
                                color: Colors.grey[300],
                                child: Icon(Icons.broken_image, size: 80),
                              ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            filme.titulo,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Direção: ${filme.direcao}',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () async {
                                  final editedFilme = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CadastroFilmeScreen(filme: filme),
                                    ),
                                  );
                                  if (editedFilme != null) {
                                    _refreshList();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                          Text('Filme atualizado com sucesso')),
                                    );
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await DatabaseHelper.instance
                                      .deleteFilme(filme.id!);
                                  _refreshList();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                        Text('Filme removido com sucesso')),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
