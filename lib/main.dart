import 'package:client/screens/login_screen.dart';
import 'package:client/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:your_project/ui/screens/login_screen.dart';
import 'package:your_project/ui/screens/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Define a rota inicial
      routes: {
        '/': (context) => LoginScreen(), // Rota para a tela de login
        '/register': (context) => RegisterScreen(), // Rota para a tela de registro
      },
    );
  }
}