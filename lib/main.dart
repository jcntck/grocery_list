import 'package:flutter/material.dart';

import 'pages/grocery_list_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GroceryListPage(),
    );
  }
}

