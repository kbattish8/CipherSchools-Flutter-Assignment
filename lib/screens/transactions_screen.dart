import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final DatabaseService _db = DatabaseService();
  final AuthService _auth = AuthService();
  
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Income', 'Expense'];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Transactions',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6A11CB),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter options
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filterOptions.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      selected: isSelected,
                      selectedColor: const Color(0xFF6A11CB).withOpacity(0.2),
                      backgroundColor: Colors.white,
                      checkmarkColor: const Color(0xFF6A11CB),
                      label: Text(filter),
                      labelStyle: TextStyle(
                        color: isSelected ? const Color(0xFF6A11CB) : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Transactions list
          Expanded(
            child: StreamBuilder<List<TransactionModel>>(
              stream: _db.getRecentTransactions(_auth.currentUser?.uid ?? '', limit: 50),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No transactions found.'),
                  );
                }
                
                // Filter transactions
                final transactions = snapshot.data!;
                List<TransactionModel> filteredTransactions = transactions;
                
                if (_selectedFilter == 'Income') {
                  filteredTransactions = transactions.where((t) => !t.isExpense).toList();
                } else if (_selectedFilter == 'Expense') {
                  filteredTransactions = transactions.where((t) => t.isExpense).toList();
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = filteredTransactions[index];
                    IconData icon;
                    
                    // Select icon based on category
                    if (transaction.isExpense) {
                      if (transaction.category == 'Food') {
                        icon = Icons.fastfood;
                      } else if (transaction.category == 'Shopping') {
                        icon = Icons.shopping_bag;
                      } else if (transaction.category == 'Transport') {
                        icon = Icons.directions_car;
                      } else if (transaction.category == 'Bills') {
                        icon = Icons.receipt;
                      } else {
                        icon = Icons.money_off;
                      }
                    } else {
                      if (transaction.category == 'Salary') {
                        icon = Icons.work;
                      } else if (transaction.category == 'Gifts') {
                        icon = Icons.card_giftcard;
                      } else if (transaction.category == 'Refunds') {
                        icon = Icons.undo;
                      } else {
                        icon = Icons.attach_money;
                      }
                    }
                    
                    final Color iconColor = transaction.isExpense ? Colors.red : Colors.green;
                    
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: iconColor.withOpacity(0.2),
                                  child: Icon(icon, color: iconColor),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        transaction.category,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('MMM dd, yyyy • hh:mm a').format(transaction.date),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${transaction.isExpense ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: transaction.isExpense ? Colors.red : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            if (transaction.description.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, left: 48),
                                child: Text(
                                  transaction.description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addTransaction');
        },
        backgroundColor: const Color(0xFF6A11CB),
        child: const Icon(Icons.add),
      ),
    );
  }
} 