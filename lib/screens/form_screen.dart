import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/filme.dart';
import '../database/database_helper.dart';
import 'dart:io';

class FormScreen extends StatefulWidget {
  final Filme? filme;
  final VoidCallback onSave;

  FormScreen({this.filme, required this.onSave});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  String titulo = '';
  int ano = DateTime.now().year;
  String direcao = '';
  String resumo = '';
  String urlCartaz = '';
  double nota = 3.0;

  @override
  void initState() {
    super.initState();
    if (widget.filme != null) {
      titulo = widget.filme!.titulo;
      ano = widget.filme!.ano;
      direcao = widget.filme!.direcao;
      resumo = widget.filme!.resumo;
      urlCartaz = widget.filme!.urlCartaz;
      nota = widget.filme!.nota;
    }
  }

  Future<void> salvar() async {
    if (_formKey.currentState!.validate()) {
      final filme = Filme(
        id: widget.filme?.id,
        titulo: titulo,
        ano: ano,
        direcao: direcao,
        resumo: resumo,
        urlCartaz: urlCartaz,
        nota: nota,
      );
      if (filme.id == null) {
        await DatabaseHelper.instance.insertFilme(filme);
      } else {
        await DatabaseHelper.instance.updateFilme(filme);
      }
      widget.onSave();
      Navigator.pop(context);
    }
  }

  Future<void> selecionarImagem() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        urlCartaz = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.filme == null ? 'Novo Filme' : 'Editar Filme')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: titulo,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                onChanged: (value) => titulo = value,
              ),
              TextFormField(
                initialValue: ano.toString(),
                decoration: InputDecoration(labelText: 'Ano'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                onChanged: (value) => ano = int.tryParse(value) ?? ano,
              ),
              TextFormField(
                initialValue: direcao,
                decoration: InputDecoration(labelText: 'Direção'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                onChanged: (value) => direcao = value,
              ),
              TextFormField(
                initialValue: resumo,
                decoration: InputDecoration(labelText: 'Resumo'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                onChanged: (value) => resumo = value,
              ),
              SizedBox(height: 10),
              Text("Nota:"),
              RatingBar.builder(
                initialRating: nota,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  setState(() {
                    nota = rating;
                  });
                },
              ),
              SizedBox(height: 10),
              urlCartaz.isEmpty
                  ? ElevatedButton.icon(
                onPressed: selecionarImagem,
                icon: Icon(Icons.image),
                label: Text("Selecionar Cartaz"),
              )
                  : Image.file(
                File(urlCartaz),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: salvar,
                  child: Text('Salvar Filme'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
