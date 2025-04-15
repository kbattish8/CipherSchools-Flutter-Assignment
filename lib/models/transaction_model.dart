class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final String category;
  final bool isExpense;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.isExpense,
    required this.date,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'isExpense': isExpense,
      'date': date,
    };
  }

  // Factory constructor to create TransactionModel from Map
  factory TransactionModel.fromMap(String id, Map<String, dynamic> map) {
    return TransactionModel(
      id: id,
      title: map['title'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      category: map['category'] ?? '',
      isExpense: map['isExpense'] ?? true,
      date: map['date'].toDate(),
    );
  }
} 