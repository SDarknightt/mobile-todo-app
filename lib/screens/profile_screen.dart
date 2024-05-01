import 'package:flutter/material.dart';
import 'package:client/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authService.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar os dados do usuário'));
        } else {
          final user = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text('Perfil', textAlign: TextAlign.center),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nome: ${user?.name}', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 16),
                  Text('Email: ${user?.email}', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await authService.logOut();
                      Navigator.pushReplacementNamed(context, "/");
                    },
                    child: Text('Sair'),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'Tarefas',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Perfil',
                ),
              ],
              currentIndex: 1, // Perfil é a tab ativa
              onTap: (index) {
                if (index == 0) { // Se a tab de tarefas for selecionada
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
            ),
          );
        }
      },
    );
  }
}