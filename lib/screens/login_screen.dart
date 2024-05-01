import 'package:client/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  //pagina contendo a logica de redirecionamento caso token for nulo
  Page(BuildContext context){
    return Container(
      child: FutureBuilder(
          future: authService.getToken(),
          builder: (ctx, snapShot) {
            if(snapShot.hasData){
              return HomeScreen();
            }
            else{
              return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Entrar',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.green),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Senha',
                labelStyle: TextStyle(color: Colors.green),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.green, // foreground color
                ),
                child: Text('Entrar'),
                onPressed: () async {
                  try {
                    final result = await authService.login(
                      emailController.text,
                      passwordController.text,
                    );
                    Navigator.pushReplacementNamed(context, '/home');
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ),            SizedBox(height: 10),
            TextButton(
              child: Text(
                'Não tem uma conta? Cadastre-se',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
            ),
          ],
        ),
      );
            }
          }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Page(context),
      ),
    );
  }
}