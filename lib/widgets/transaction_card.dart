import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    // Get category icon
    IconData categoryIcon = _getCategoryIcon(transaction.category);
    
    // Format date
    final dateFormat = DateFormat('MMM d, yyyy');
    final formattedDate = dateFormat.format(transaction.date);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Category icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: transaction.isExpense
                    ? Colors.red.withOpacity(0.1)
                    : Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                categoryIcon,
                color: transaction.isExpense ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            // Transaction details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Amount
            Text(
              '${transaction.isExpense ? '-' : '+'}₱${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: transaction.isExpense ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transportation':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.movie;
      case 'utilities':
        return Icons.lightbulb;
      case 'housing':
        return Icons.home;
      case 'salary':
        return Icons.work;
      case 'investment':
        return Icons.trending_up;
      case 'gift':
        return Icons.card_giftcard;
      default:
        return Icons.attach_money;
    }
  }
} 