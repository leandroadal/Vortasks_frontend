import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test_application/pages/auth/register.dart';
import 'package:flutter_test_application/services/api/api_service.dart';
import 'package:http/http.dart' as http;

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // URL da API de login
    String loginUrl = '/auth/login';
    final headers = {'Content-Type': 'application/json'};

    try {
      var response = await http.post(
        Uri.parse('${ApiService.baseUrl}$loginUrl'),
        headers: headers,
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        ApiService.token = jsonDecode(response.body)['token'];
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login bem-sucedido!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Falha no login. Por favor, verifique suas credenciais.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Erro ao conectar à API. Por favor, tente novamente mais tarde.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3100a7),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Usuário',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegistrationPage()),
                          );
                        },
                        child: const Text('Registrar'),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: _login,
                        child: const Text('Entrar'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha a tela atual
              },
              icon: const Icon(Icons.close),
              iconSize: 35,
            ),
          ),
        ],
      ),
    );
  }
}
