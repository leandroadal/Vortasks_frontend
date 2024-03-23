import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test_application/entities/backup/backup.dart';
import 'package:flutter_test_application/entities/tasks/task.dart';
import 'package:flutter_test_application/pages/friendship/friends_page.dart';
import 'package:flutter_test_application/pages/auth/login.dart';
import 'package:flutter_test_application/services/api/api_service.dart';
import 'package:http/http.dart' as http;

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar(
      {super.key,
      required this.title,
      required this.tasks,
      required this.backup,
      required this.createBackup,
      required this.updateBackup});

  final String title;
  //Backup? backup;
  final List<Task> tasks;
  final Backup Function() createBackup;
  final Backup? backup;
  final void Function(Backup? value) updateBackup;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.sync),
          onPressed: () {
            _syncBackup(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.people),
          onPressed: () {
            // Navegar para a página de amigos
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FriendsPage()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginForm()),
            );
          },
        ),
      ],
      backgroundColor: const Color(0xFF2c00a2), // Color(0xFF2c00a2)
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          title,
        ),
      ),
    );
  }

  Future<void> _syncBackup(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(), // Ícone de sincronização girando
            SizedBox(width: 16),
            Text("Syncing backup..."),
          ],
        ),
      ),
    );

    try {
      if (backup == null) {
        // Caso o backup não exista localmente, faça uma solicitação para o endpoint
        final response = await ApiService.get(
            '/user/backup?lastModified=1022-06-07T12:00:00Z');

        if (response.statusCode == 200) {
          // Se a solicitação for bem-sucedida, atualiza o backup local
          final serverBackup = Backup.fromJson(json.decode(response.body));
          updateBackup(serverBackup);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Backup sincronizado coom sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (response.statusCode == 403 &&
            response.body.contains('Token inválido')) {
          // Caso o acesso seja negado renovar o token
          if (!context.mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginForm()),
          );
        } else if (response.statusCode == 404) {
          Backup b = createBackup();
          if (!context.mounted) return;
          await _sendBackupToAPI(context, b);
        }
      } else {
        // Se o backup existir localmente, verifica se a data do último backup no servidor é maior que a do local na api
        final response = await ApiService.get(
            '/user/backup?lastModified=${backup!.lastModified.toIso8601String()}');

        if (response.statusCode == 200) {
          updateBackup(Backup.fromJson(response.body as Map<String, dynamic>));
        } else if (response.statusCode == 403 &&
            response.body.contains('Token inválido')) {
          // Caso o acesso seja negado renovar o token
          if (!context.mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginForm()),
          );
        } else {
          // Nesse caso a versão local é a mais recente então a envia para a api
          final headers = {
            'Content-Type':
                'application/json', // Definindo o tipo de conteúdo como JSON
            if (ApiService.token != null)
              'Authorization': 'Bearer ${ApiService.token}',
          };

          await http.put(
            Uri.parse('${ApiService.baseUrl}/user/backup/update'),
            headers: headers,
            body: jsonEncode(backup!.toJson()), // Convertendo o corpo para JSON
          );
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Backup ja se encontra na ultima versão!'),
            ),
          );
        }
      }
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
        ),
      );
    }
  }

  Future<void> _sendBackupToAPI(BuildContext context, Backup backup) async {
    // envia o backup para a API
    try {
      final response =
          await ApiService.post('/user/backup/create', backup.toJson());

      if (response.statusCode == 200) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Backup sincronizado com sucesso!'),
          ),
        );
      } else if (response.statusCode == 403 &&
          response.body.contains('Token inválido')) {
        // Caso o acesso seja negado renovar o token
        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginForm()),
        );
      } else {
        throw Exception('Failed to sync backup');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error syncing backup: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
