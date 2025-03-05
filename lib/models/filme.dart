class Filme {
  int? id;
  String titulo;
  int ano;
  String direcao;
  String resumo;
  String urlCartaz;
  double nota;

  Filme({
    this.id,
    required this.titulo,
    required this.ano,
    required this.direcao,
    required this.resumo,
    required this.urlCartaz,
    required this.nota,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'ano': ano,
      'direcao': direcao,
      'resumo': resumo,
      'urlCartaz': urlCartaz,
      'nota': nota,
    };
  }

  factory Filme.fromMap(Map<String, dynamic> map) {
    return Filme(
      id: map['id'],
      titulo: map['titulo'],
      ano: map['ano'],
      direcao: map['direcao'],
      resumo: map['resumo'],
      urlCartaz: map['urlCartaz'],
      nota: map['nota'],
    );
  }
}
