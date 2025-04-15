class UserModel {
  final String uid;
  final String name;
  final String email;
  final double balance;
  final double totalIncome;
  final double totalExpenses;
  final String? profileImageUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.balance = 0.0,
    this.totalIncome = 0.0,
    this.totalExpenses = 0.0,
    this.profileImageUrl,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'balance': balance,
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
      'profileImageUrl': profileImageUrl,
    };
  }

  // Factory constructor to create UserModel from Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      balance: (map['balance'] ?? 0).toDouble(),
      totalIncome: (map['totalIncome'] ?? 0).toDouble(),
      totalExpenses: (map['totalExpenses'] ?? 0).toDouble(),
      profileImageUrl: map['profileImageUrl'],
    );
  }
} 