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
                    padding: const EdgeInsets.all(50),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Text(
                            user!.name[0].toUpperCase(),
                            style: TextStyle(fontSize: 60, color: Colors.green),
                          ),
                        ),
                        Text(
                          'Perfil',
                          style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
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
                          Text(user!.name, style: TextStyle(fontSize: 40)),
                          SizedBox(height: 16),
                          Text(user!.email, style: TextStyle(fontSize: 20)),
                          SizedBox(height: 16),
                          Container(
                            width: 200,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white, backgroundColor: Colors.green,
                              ),
                              onPressed: () async {
                                await authService.logOut();
                                Navigator.pushReplacementNamed(context, "/");
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.logout),
                                  SizedBox(width: 10),
                                  Text('Sair', style: TextStyle(fontSize: 20)),
                                ],
                              ),
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
              currentIndex: 1,
              onTap: (index) {
                if (index == 0) {
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