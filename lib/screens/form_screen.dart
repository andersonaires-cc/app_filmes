import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FormScreen extends StatefulWidget {
  final String? filme;

  FormScreen({this.filme});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _anoController = TextEditingController();
  TextEditingController _direcaoController = TextEditingController();
  TextEditingController _resumoController = TextEditingController();
  TextEditingController _urlCartazController = TextEditingController();
  double _nota = 1;

  File? _imagem;

  @override
  void initState() {
    super.initState();
    if (widget.filme != null) {
      // Carregar os dados do filme para edição, se necessário
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagem = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.filme == null ? 'Novo Filme' : 'Editar Filme')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o título do filme';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _anoController,
                decoration: InputDecoration(labelText: 'Ano'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _direcaoController,
                decoration: InputDecoration(labelText: 'Direção'),
              ),
              TextFormField(
                controller: _resumoController,
                decoration: InputDecoration(labelText: 'Resumo'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _urlCartazController,
                decoration: InputDecoration(labelText: 'URL Cartaz'),
              ),
              Row(
                children: <Widget>[
                  Text('Nota:'),
                  RatingBar.builder(
                    initialRating: _nota,
                    minRating: 1,
                    itemCount: 5,
                    itemSize: 40.0,
                    onRatingUpdate: (rating) {
                      setState(() {
                        _nota = rating;
                      });
                    },
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _imagem == null
                  ? ElevatedButton.icon(
                icon: Icon(Icons.add_a_photo),
                label: Text('Escolher Cartaz'),
                onPressed: _pickImage,
              )
                  : Image.file(
                _imagem!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Filme salvo com sucesso!')));
                    Navigator.pop(context); // Volta para a tela anterior
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
