import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const BankingApp());
}

class BankingApp extends StatelessWidget {
  const BankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Banking App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AccountListScreen(),
    );
  }
}

class AccountListScreen extends StatefulWidget {
  const AccountListScreen({super.key});

  @override
  _AccountListScreenState createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  List<dynamic> accounts = [];

  @override
  void initState() {
    super.initState();
    loadAccounts(); // Load accounts on initialization
  }

  // This function loads and decodes the accounts.json file.
  Future<void> loadAccounts() async {
    try {
      // Load the JSON file from assets
      String data = await rootBundle.loadString('assets/accounts.json');

      // Decode the JSON string into a Map
      Map<String, dynamic> jsonData = json.decode(data);

      // Debug Print: Check the loaded JSON data
      print("Accounts JSON: $jsonData");

      // Update the accounts list safely
      setState(() {
        accounts = jsonData['accounts'] ?? [];
      });
    } catch (e) {
      print("Error loading accounts: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bank Accounts')),
      body: accounts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          var account = accounts[index];
          return Card(
            child: ListTile(
              title: Text('${account['type']} - ${account['account_number']}'),
              subtitle: Text('Balance: \$${account['balance']}'),
              trailing: ElevatedButton(
                child: const Text('Transactions'),
                onPressed: () {
                  // Navigate to the transactions screen for the selected account
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionDetailsScreen(
                        accountType: account['type'],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class TransactionDetailsScreen extends StatefulWidget {
  final String accountType;
  const TransactionDetailsScreen({super.key, required this.accountType});

  @override
  _TransactionDetailsScreenState createState() => _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  List<dynamic> transactions = [];

  @override
  void initState() {
    super.initState();
    loadTransactions(); // Load transactions on initialization
  }

  // This function loads and decodes the transactions.json file.
  Future<void> loadTransactions() async {
    try {
      // Load the JSON file from assets
      String data = await rootBundle.loadString('assets/transactions.json');

      // Decode the JSON string into a Map
      Map<String, dynamic> jsonData = json.decode(data);

      // Debug Print: Check the loaded JSON data for the specific account type
      print("Transactions JSON for ${widget.accountType}: $jsonData");

      // Update the transactions list safely for the current account type
      setState(() {
        transactions = jsonData['transactions'][widget.accountType] ?? [];
      });
    } catch (e) {
      print("Error loading transactions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.accountType} Transactions')),
      body: transactions.isEmpty
          ? const Center(child: Text('No transactions available'))
          : ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          var transaction = transactions[index];
          return ListTile(
            title: Text(transaction['description']),
            subtitle: Text(transaction['date']),
            trailing: Text(
              '\$${transaction['amount']}',
              style: TextStyle(
                color: transaction['amount'] < 0 ? Colors.red : Colors.green,
              ),
            ),
          );
        },
      ),
    );
  }
}
