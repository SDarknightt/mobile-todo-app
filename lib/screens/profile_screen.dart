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
            body: Column(
              children: [
                Container(
                  color: Colors.green,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Perfil',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(user!.name, style: TextStyle(fontSize: 20)),
                          SizedBox(height: 16),
                          Text(user!.email, style: TextStyle(fontSize: 20)),
                          SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white, backgroundColor: Colors.green, // foreground color
                              ),
                              onPressed: () async {
                                await authService.logOut();
                                Navigator.pushReplacementNamed(context, "/");
                              },
                              child: Text('Sair'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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