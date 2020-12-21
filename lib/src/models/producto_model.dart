// To parse this JSON data, do
//
//     final client = clientFromJson(jsonString);

import 'dart:convert';

Producto productoFromJson(String str) => Producto.fromJson(json.decode(str));

String productoToJson(Producto data) => json.encode(data.toJson());

class Producto {
  Producto({
    this.id,
    this.titulo = "",
    this.valor = 0.0,
    this.disponible = true,
    this.fotoUrl,
  });

  int id;
  String titulo;
  double valor;
  bool disponible;
  String fotoUrl;

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
    id: json["id"],
    titulo: json["titulo"],
    valor: double.parse(json["valor"]),
    disponible: json["disponible"],
    fotoUrl: json["fotoUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "titulo": titulo,
    "valor": valor,
    "disponible": disponible,
    "fotoUrl": fotoUrl,
  };
}
