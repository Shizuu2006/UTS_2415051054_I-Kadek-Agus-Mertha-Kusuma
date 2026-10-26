class Quote {
  final int id;
  final String text;
  final String author;

  const Quote({required this.id, required this.text, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
    id: (json['id'] as num?)?.toInt() ?? 0,
    text: (json['quote'] ?? '').toString(),
    author: (json['author'] ?? 'Anonim').toString(),
  );
}
