import '../models/quote.dart';
import '../services/quote_api_service.dart';

class QuoteRepository {
  final QuoteApiService _api;
  QuoteRepository(this._api);

  Future<List<Quote>> getQuotes() => _api.getQuotes();
}
