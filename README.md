# test3
![home](./assets/accounts.png)

This Flutter-based mobile banking app allows users to view account details and transactions. 
It has three main screens: the Welcome Screen, Account List Screen, and Transaction Details Screen.
The app loads data from a JSON file that contains account and transaction information.

The Welcome Screen displays the bank's logo, a welcome message, and today's date. 
It allows users to navigate to the Account List. 

The Account List Screen shows a list of accounts with details like account holder name, account ID,
and balance, and lets users select an account to view its transactions.

The Transaction Details Screen displays the transactions of the selected account, including 
transaction ID, date, amount, and type (Deposit/Withdrawal). Navigation is restricted: users can 
only navigate back from the Transaction Details to the Account List, and from the Account List to 
the Welcome Screen.

The app is built using Flutter, and the account and transaction data is stored in a accounts.json 
file. The file structure includes models for accounts and transactions, along with screen files for
each UI component.

To run the app, clone the repository, install dependencies with flutter pub get, and use flutter run
to launch the app.

In this project we have add a  dependency in pubspec.yaml
- assets/accounts.json and install pub get to install the dependency in our flutter project.
We have make a assets directory in our flutter project and inside that we have created a accounts.json directory 
- for the transcation, and account holder details.



- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
