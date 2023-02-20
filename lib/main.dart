import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/grocery_list_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const GroceryListPage(),
    );
  }

  ThemeData _buildTheme() {
    var baseTheme = ThemeData();
    return baseTheme.copyWith(
      textTheme: GoogleFonts.nunitoTextTheme(baseTheme.textTheme),
    );
  }
}

