import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database_service.dart';
import '../models/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<TransactionModel> _recentTransactions = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<TransactionModel> get recentTransactions => _recentTransactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Set error
  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  // Add a new transaction
  Future<bool> addTransaction(
    String userId,
    String title,
    double amount,
    String category,
    bool isExpense,
    DateTime date,
  ) async {
    _setLoading(true);
    _setError(null);
    
    try {
      await _databaseService.addTransaction(
        userId,
        title,
        amount,
        category,
        isExpense,
        date,
      );
      
      // Refresh transactions after adding a new one
      await fetchRecentTransactions(userId);
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError('Failed to add transaction: ${e.toString()}');
      return false;
    }
  }

  // Fetch recent transactions
  Future<void> fetchRecentTransactions(String userId) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final snapshot = await _databaseService.getRecentTransactions(userId);
      _recentTransactions = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return TransactionModel(
          id: doc.id,
          title: data['title'] ?? '',
          amount: (data['amount'] ?? 0).toDouble(),
          category: data['category'] ?? '',
          isExpense: data['isExpense'] ?? true,
          date: (data['date'] as Timestamp).toDate(),
        );
      }).toList();
      
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      _setError('Failed to fetch transactions: ${e.toString()}');
    }
  }

  // Fetch monthly totals
  Future<Map<String, double>> fetchMonthlyTotals(String userId) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final result = await _databaseService.getMonthlyTotals(userId);
      _setLoading(false);
      return result;
    } catch (e) {
      _setLoading(false);
      _setError('Failed to fetch monthly totals: ${e.toString()}');
      return {'income': 0.0, 'expense': 0.0};
    }
  }
} 