import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Item {
  final String id;
  final String name;
  final int qty;
  Item({required this.id, required this.name, required this.qty});
  factory Item.fromJson(Map<String, dynamic> j) =>
      Item(id: j['id'] as String, name: j['name'] as String, qty: (j['qty'] as num).toInt());
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'qty': qty};
}

class ItemsApi {
  static const _api = 'ItemsRestApi';

  Future<List<Item>> list() async {
    final r = await Amplify.API.get('/items', apiName: _api).response;
    final raw = jsonDecode(r.decodeBody()) as List<dynamic>;
    return raw.cast<Map<String, dynamic>>().map(Item.fromJson).toList();
  }

  Future<Item> create(Item input) async {
    final r = await Amplify.API
        .post('/items', body: HttpPayload.json(input.toJson()), apiName: _api)
        .response;
    return Item.fromJson(jsonDecode(r.decodeBody()) as Map<String, dynamic>);
  }

  Future<Item> get(String id) async {
    final r = await Amplify.API.get('/items/$id', apiName: _api).response;
    return Item.fromJson(jsonDecode(r.decodeBody()) as Map<String, dynamic>);
  }

  Future<void> delete(String id) async {
    await Amplify.API.delete('/items/$id', apiName: _api).response;
  }
}

final itemsApiProvider = Provider((_) => ItemsApi());
