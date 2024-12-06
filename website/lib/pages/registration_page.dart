import 'package:flutter/material.dart';
import 'package:website/services/api_manager.dart';
import 'package:website/services/api_query.dart';
import '../services/auth_service.dart';
import '../services/api_manager.dart';
import '../services/utils_functions.dart';

class RegistrationPage extends StatefulWidget {
  final ApiManager apiManager;

  const RegistrationPage(this.apiManager, {super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState(apiManager);
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _telegramController = TextEditingController();
  String _errorMessage = '';

  final ApiManager apiManager;

  _RegistrationPageState(this.apiManager);

  Future<void> _handleRegistration() async {
    if (_formKey.currentState!.validate()) {
      const String yellow = '\x1B[33m';
      const String reset = '\x1B[0m';
      final String hashedPassword = hashPassword(_passwordController.text);

      final ApiQuery query = ApiQueryBuilder()
          .path('/register')
          .addParameter('name', _nameController.text)
          .addParameter('login', _usernameController.text)
          .addParameter('password', hashedPassword)
          .addParameter('tg_nick', _telegramController.text)
          .build();
      ApiResponse response = await apiManager.post(query);
      if (response.success) {
        print('$yellow Регистрация успешна: ${response.body['answer']} $reset');
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Регистрация успешно завершена! Теперь вы можете войти в систему.'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        });

        //TODO: change_page and save id of user to appdata
      } else {
        setState(() {
          _errorMessage = 'Ошибка при регистрации';
        });
        print('$yellow Ошибка регистрации: ${response.error} $reset');
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _telegramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: rewrite code with OOP
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Создание аккаунта',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Имя',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Пожалуйста, введите имя';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Логин',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.account_circle),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Пожалуйста, введите логин';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Пароль',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Пожалуйста, введите пароль';
                            }
                            if (value.length < 6) {
                              return 'Пароль должен содержать минимум 6 символов';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _telegramController,
                          decoration: const InputDecoration(
                            labelText: 'Ник в Telegram',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.telegram),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Пожалуйста, введите ник в Telegram';
                            }
                            return null;
                          },
                        ),
                        if (_errorMessage.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _handleRegistration,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Зарегистрироваться',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
