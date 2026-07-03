class Income {
  final String id;
  final String source;
  final double amount;
  final DateTime date;
  final String description;

  Income({
    required this.id,
    required this.source,
    required this.amount,
    required this.date,
    this.description = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'source': source,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
      id: map['id'] ?? '',
      source: map['source'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date']),
      description: map['description'] ?? '',
    );
  }
}
