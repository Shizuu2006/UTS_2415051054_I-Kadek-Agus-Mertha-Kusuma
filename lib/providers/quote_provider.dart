import 'package:flutter/foundation.dart';

import '../models/quote.dart';
import '../repositories/quote_repository.dart';

class QuoteProvider extends ChangeNotifier {
  final QuoteRepository _repo;
  QuoteProvider(this._repo);

  List<Quote> quotes = [];
  bool isLoading = false;
  String? error;

  bool get isEmpty => !isLoading && error == null && quotes.isEmpty;

  Future<void> loadQuotes() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      quotes = await _repo.getQuotes();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    }
    isLoading = false;
    notifyListeners();
  }
}
