import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(BankingApp());
}

class BankingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Banking App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String currentDate = DateTime.now().toLocal().toString().split(' ')[0];

    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance, size: 100, color: Colors.blue),
            Text("Welcome to Your Bank", style: TextStyle(fontSize: 22)),
            Text("Today's Date: $currentDate", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AccountListScreen()));
              },
              child: Text('View Accounts'),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountListScreen extends StatefulWidget {
  @override
  _AccountListScreenState createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  List accounts = [];

  @override
  void initState() {
    super.initState();
    loadAccounts();
  }

  Future<void> loadAccounts() async {
    String data = await rootBundle.loadString('assets/accounts.json');
    setState(() {
      accounts = json.decode(data)['accounts'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account List')),
      body: accounts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          var account = accounts[index];
          return Card(
            child: ListTile(
              title: Text(account['type']),
              subtitle: Text('Balance: \$${account['balance']}'),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionDetailsScreen(accountType: account['type']),
                    ),
                  );
                },
                child: Text('View Transactions'),
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

  TransactionDetailsScreen({required this.accountType});

  @override
  _TransactionDetailsScreenState createState() => _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  List transactions = [];

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    String data = await rootBundle.loadString('assets/transactions.json');
    Map<String, dynamic> transactionsData = json.decode(data)['transactions'];

    setState(() {
      transactions = transactionsData[widget.accountType] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.accountType} Transactions')),
      body: transactions.isEmpty
          ? Center(child: Text('No transactions available'))
          : ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          var transaction = transactions[index];
          return ListTile(
            title: Text(transaction['description']),
            subtitle: Text(transaction['date']),
            trailing: Text(
              '\$${transaction['amount']}',
              style: TextStyle(color: transaction['amount'] < 0 ? Colors.red : Colors.green),
            ),
          );
        },
      ),
    );
  }
}
