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

  // Convertendo o objeto para um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'ano': ano,
      'direcao': direcao,
      'resumo': resumo,
      'url_cartaz': urlCartaz,
      'nota': nota,
    };
  }

  // Convertendo um mapa para um objeto Filme
  factory Filme.fromMap(Map<String, dynamic> map) {
    return Filme(
      id: map['id'],
      titulo: map['titulo'],
      ano: map['ano'],
      direcao: map['direcao'],
      resumo: map['resumo'],
      urlCartaz: map['url_cartaz'],
      nota: map['nota'],
    );
  }
}
