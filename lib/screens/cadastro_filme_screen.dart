import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:app_filmes/db/database_helper.dart';
import 'package:app_filmes/models/filme.dart';

class CadastroFilmeScreen extends StatefulWidget {
  final Filme? filme;

  CadastroFilmeScreen({this.filme});

  @override
  _CadastroFilmeScreenState createState() => _CadastroFilmeScreenState();
}

class _CadastroFilmeScreenState extends State<CadastroFilmeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _anoController;
  late TextEditingController _direcaoController;
  late TextEditingController _resumoController;
  late TextEditingController _urlCartazController;
  double _nota = 1.0;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.filme?.titulo ?? '');
    _anoController = TextEditingController(text: widget.filme?.ano.toString() ?? '');
    _direcaoController = TextEditingController(text: widget.filme?.direcao ?? '');
    _resumoController = TextEditingController(text: widget.filme?.resumo ?? '');
    _urlCartazController = TextEditingController(text: widget.filme?.urlCartaz ?? '');
    if (widget.filme != null) {
      _nota = widget.filme!.nota;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _urlCartazController.text = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.filme == null ? 'Cadastrar Filme' : 'Editar Filme')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O título é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _anoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Ano'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O ano é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _direcaoController,
                decoration: InputDecoration(labelText: 'Direção'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A direção é obrigatória';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _resumoController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Resumo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O resumo é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _urlCartazController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Cartaz (URL)'),
                onTap: _pickImage,
              ),
              RatingBar.builder(
                initialRating: _nota,
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                itemSize: 40.0,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final filme = Filme(
                      id: widget.filme?.id,
                      titulo: _tituloController.text,
                      ano: int.parse(_anoController.text),
                      direcao: _direcaoController.text,
                      resumo: _resumoController.text,
                      urlCartaz: _urlCartazController.text,
                      nota: _nota,
                    );
                    if (widget.filme == null) {
                      DatabaseHelper.instance.insertFilme(filme);
                    } else {
                      DatabaseHelper.instance.updateFilme(filme);
                    }
                    Navigator.pop(context, filme);
                  }
                },
                child: Text(widget.filme == null ? 'Adicionar' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
