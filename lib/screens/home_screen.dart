import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction_model.dart';
import '../widgets/transaction_card.dart';
import '../widgets/add_transaction_sheet.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, double> _monthlyTotals = {'income': 0.0, 'expense': 0.0};
  bool _isLoadingTotals = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Get the auth provider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.isAuthenticated && authProvider.user != null) {
      // Get the transaction provider and load transactions
      final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
      await transactionProvider.fetchRecentTransactions(authProvider.user!.uid);
      
      // Load monthly totals
      setState(() {
        _isLoadingTotals = true;
      });
      
      try {
        final totals = await transactionProvider.fetchMonthlyTotals(authProvider.user!.uid);
        if (mounted) {
          setState(() {
            _monthlyTotals = totals;
            _isLoadingTotals = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoadingTotals = false;
          });
        }
      }
    } else {
      // No user is logged in, redirect to login
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);
    
    // If authentication is still loading, show loading indicator
    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    // If not authenticated, redirect to login
    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
      
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    final user = authProvider.user;
    final transactions = transactionProvider.recentTransactions;
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Hello, ${user?.displayName ?? "User"}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6A11CB),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: transactionProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Purple gradient container for balance
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF6A11CB),
                          Color(0xFF2575FC),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Current Balance',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _isLoadingTotals
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Column(
                                children: [
                                  Text(
                                    '\$${(_monthlyTotals['income']! - _monthlyTotals['expense']!).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Income and Expense indicators
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 40),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Income
                                        Column(
                                          children: [
                                            const Row(
                                              children: [
                                                Icon(Icons.arrow_downward, color: Colors.green),
                                                SizedBox(width: 4),
                                                Text(
                                                  'Income',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '\$${_monthlyTotals['income']!.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Expense
                                        Column(
                                          children: [
                                            const Row(
                                              children: [
                                                Icon(Icons.arrow_upward, color: Colors.red),
                                                SizedBox(width: 4),
                                                Text(
                                                  'Expenses',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '\$${_monthlyTotals['expense']!.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                  
                  // Transaction History header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Transaction History',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (transactions.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              // View all transactions functionality
                            },
                            child: const Text(
                              'See All',
                              style: TextStyle(
                                color: Color(0xFF6A11CB),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  // Recent transactions
                  transactions.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(height: 40),
                                Icon(
                                  Icons.account_balance_wallet_outlined,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No transactions yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Add your income and expenses to start tracking',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = transactions[index];
                            return TransactionCard(transaction: transaction);
                          },
                        ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open income/expense add menu
          showModalBottomSheet(
            context: context,
            builder: (context) => const AddTransactionSheet(),
          );
        },
        backgroundColor: const Color(0xFF6A11CB),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
} 