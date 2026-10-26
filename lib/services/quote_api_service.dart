import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/quote.dart';

class QuoteApiService {
  static const _url = 'https://dummyjson.com/quotes?limit=5';
  final http.Client _client = http.Client();

  Future<List<Quote>> getQuotes() async {
    final res = await _client
        .get(Uri.parse(_url))
        .timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat kutipan (kode ${res.statusCode})');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final list = (body['quotes'] as List?) ?? [];
    return list.map((e) => Quote.fromJson(e as Map<String, dynamic>)).toList();
  }
}
