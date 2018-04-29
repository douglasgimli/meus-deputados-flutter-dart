import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List> fetchDeputies() async {
  final response = await http.get('https://dadosabertos.camara.leg.br/api/v2/deputados?ordenarPor=nome&itens=9999999');
  final responseJson = json.decode(response.body);
  final deputies = responseJson['dados'].map((deputyData) => new Deputy.fromJson(deputyData)).toList();
  return deputies;
}

class Deputy {
  final int id;
  final String name;
  final String picture;
  final String url;
  final String urlPoliticalParty;
  final String politicalPartyInitials;
  final String stateInitials;

  Deputy({this.id, this.name, this.picture, this.url, this.urlPoliticalParty, this.politicalPartyInitials, this.stateInitials});

  factory Deputy.fromJson(Map<String, dynamic> json) {
    return new Deputy(
      id: json['id'],
      name: json['nome'],
      picture: json['urlFoto'],
      url: json['uri'],
      urlPoliticalParty: json['uriPartido'],
      politicalPartyInitials: json['siglaPartido'],
      stateInitials: json['siglaUf'],
    );
  }
}