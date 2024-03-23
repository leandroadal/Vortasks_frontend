import 'package:flutter/material.dart';
import 'package:flutter_test_application/pages/auth/login.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.account_circle,
                  size: 50,
                ),
                onPressed: () {
                  // Navegar para a página de login
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginForm()),
                  );
                },
              ),
              const SizedBox(
                width: 5,
              ),
              const Text(
                'Usuário',
                style: TextStyle(fontSize: 20),
              ),
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  size: 30,
                ),
                onPressed: () {
                  // Navegar para a página de amigos
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginForm()),
                  );
                },
              ),
            ],
          ),
          ListTile(
            title: const Text('Item 1'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
