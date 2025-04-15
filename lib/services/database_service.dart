import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/transaction_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Users collection reference
  final CollectionReference usersCollection = 
    FirebaseFirestore.instance.collection('users');
  
  // Transactions collection reference
  final CollectionReference transactionsCollection = 
    FirebaseFirestore.instance.collection('transactions');
  
  // Create user document with initial data when user signs up
  Future<void> createUserDocument(User user, String name) async {
    UserModel newUser = UserModel(
      uid: user.uid,
      name: name,
      email: user.email ?? '',
      balance: 0.0,
      totalIncome: 0.0,
      totalExpenses: 0.0,
    );
    
    await usersCollection.doc(user.uid).set(newUser.toMap());
  }
  
  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    DocumentSnapshot doc = await usersCollection.doc(uid).get();
    
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
  
  // Add a new transaction
  Future<DocumentReference> addTransaction(
    String userId,
    String title,
    double amount,
    String category,
    bool isExpense,
    DateTime date,
  ) async {
    return await _firestore.collection('transactions').add({
      'userId': userId,
      'title': title,
      'amount': amount,
      'category': category,
      'isExpense': isExpense,
      'date': Timestamp.fromDate(date),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  
  // Get recent transactions for a user
  Future<QuerySnapshot> getRecentTransactions(String userId) async {
    return await _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .limit(20)
        .get();
  }
  
  // Get transactions by category
  Future<QuerySnapshot> getTransactionsByCategory(
      String userId, String category) async {
    return await _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .where('category', isEqualTo: category)
        .orderBy('date', descending: true)
        .get();
  }
  
  // Get total income and expense for the month
  Future<Map<String, double>> getMonthlyTotals(String userId) async {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    QuerySnapshot snapshot = await _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(lastDayOfMonth))
        .get();

    double totalIncome = 0;
    double totalExpense = 0;

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      double amount = (data['amount'] ?? 0).toDouble();
      bool isExpense = data['isExpense'] ?? false;

      if (isExpense) {
        totalExpense += amount;
      } else {
        totalIncome += amount;
      }
    }

    return {
      'income': totalIncome,
      'expense': totalExpense,
    };
  }
} 