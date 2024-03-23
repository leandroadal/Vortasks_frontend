import 'package:flutter/material.dart';
import 'package:flutter_test_application/entities/user/dto/register_dto.dart';
import 'package:flutter_test_application/services/api/api_service.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _user = RegisterDTO(name: '', username: '', email: '', password: '');

  void register() async {
    try {
      var response = await ApiService.post('/auth/register', _user.toJson());

      if (response.statusCode == 200) {
        print('Sucesso: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conta criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print('Erro: ${response.statusCode}');
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao criar a conta!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
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
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _user.name = value!;
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Nome de Usuário'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _user.username = value!;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        if (!value.contains('@')) {
                          return 'Email inválido';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _user.email = value!;
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Senha'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        if (value.length < 6 || value.length > 40) {
                          return 'A senha deve ter entre 6 e 40 caracteres';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _user.password = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          register();
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Registrar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
