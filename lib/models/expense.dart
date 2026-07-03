class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String description;
  final String? receiptPath; // local path or S3 url

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.description = '',
    this.receiptPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'description': description,
      'receiptPath': receiptPath,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] ?? 'General',
      date: DateTime.parse(map['date']),
      description: map['description'] ?? '',
      receiptPath: map['receiptPath'],
    );
  }
}
