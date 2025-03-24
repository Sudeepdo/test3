// Import necessary packages
import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart'; // For Flutter widgets and UI components
import 'package:flutter/services.dart'; // For loading assets like JSON files

// Main entry point of the app
void main() {
  runApp(const BankingApp()); // Run the BankingApp widget
}

// BankingApp widget: The root widget of the application
class BankingApp extends StatelessWidget {
  const BankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      title: 'Mobile Banking App', // Set the title of the app
      theme: ThemeData(primarySwatch: Colors.blue), // Set the primary theme color to blue
      home: const AccountListScreen(), // Set the AccountListScreen as the home screen
    );
  }
}

// AccountListScreen widget: Displays the list of bank accounts
class AccountListScreen extends StatefulWidget {
  const AccountListScreen({super.key});

  @override
  _AccountListScreenState createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  List<dynamic> accounts = []; // List to store account data

  @override
  void initState() {
    super.initState();
    loadAccounts(); // Load account data when the screen is initialized
  }

  // Function to load and decode the accounts JSON file from assets
  Future<void> loadAccounts() async {
    try {
      // Load the JSON file from the assets folder
      String data = await rootBundle.loadString('assets/accounts.json');

      // Decode the JSON string into a Map
      Map<String, dynamic> jsonData = json.decode(data);

      // Debugging print statement to check loaded JSON data
      print("Accounts JSON: $jsonData");

      // Update the accounts list using setState to trigger a UI refresh
      setState(() {
        accounts = jsonData['accounts'] ?? []; // Update the accounts list
      });
    } catch (e) {
      print("Error loading accounts: $e"); // Handle errors during JSON loading
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bank Accounts')), // Set app bar title
      body: accounts.isEmpty // Show a loading indicator if no accounts are loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: accounts.length, // Set the number of items in the list
        itemBuilder: (context, index) {
          var account = accounts[index]; // Get the account data for the current index
          return Card(
            child: ListTile(
              title: Text('${account['type']} - ${account['account_number']}'), // Display account type and number
              subtitle: Text('Balance: \$${account['balance']}'), // Display account balance
              trailing: ElevatedButton(
                child: const Text('Transactions'), // Button to view account transactions
                onPressed: () {
                  // Navigate to the transaction details screen for the selected account
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionDetailsScreen(
                        accountType: account['type'], // Pass account type to transaction screen
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

// TransactionDetailsScreen widget: Displays transactions for a specific account
class TransactionDetailsScreen extends StatefulWidget {
  final String accountType; // Account type (e.g., 'Savings', 'Checking')
  const TransactionDetailsScreen({super.key, required this.accountType});

  @override
  _TransactionDetailsScreenState createState() => _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  List<dynamic> transactions = []; // List to store transaction data

  @override
  void initState() {
    super.initState();
    loadTransactions(); // Load transaction data when the screen is initialized
  }

  // Function to load and decode the transactions JSON file from assets
  Future<void> loadTransactions() async {
    try {
      // Load the JSON file from the assets folder
      String data = await rootBundle.loadString('assets/transactions.json');

      // Decode the JSON string into a Map
      Map<String, dynamic> jsonData = json.decode(data);

      // Debugging print statement to check the loaded JSON data for the specific account type
      print("Transactions JSON for ${widget.accountType}: $jsonData");

      // Update the transactions list for the current account type
      setState(() {
        transactions = jsonData['transactions'][widget.accountType] ?? []; // Filter by account type
      });
    } catch (e) {
      print("Error loading transactions: $e"); // Handle errors during JSON loading
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.accountType} Transactions')), // Set the app bar title based on account type
      body: transactions.isEmpty // Show message if no transactions are found
          ? const Center(child: Text('No transactions available'))
          : ListView.builder(
        itemCount: transactions.length, // Set the number of transaction items
        itemBuilder: (context, index) {
          var transaction = transactions[index]; // Get the transaction data for the current index
          return ListTile(
            title: Text(transaction['description']), // Display the transaction description
            subtitle: Text(transaction['date']), // Display the transaction date
            trailing: Text(
              '\$${transaction['amount']}', // Display the transaction amount
              style: TextStyle(
                color: transaction['amount'] < 0 ? Colors.red : Colors.green, // Red for withdrawals, green for deposits
              ),
            ),
          );
        },
      ),
    );
  }
}
