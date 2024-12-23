import 'package:flutter/material.dart';
import 'package:website/models/MetaKeys.dart';
import 'package:website/pages/home_page.dart';
import 'package:website/services/api_manager.dart';
import 'package:website/services/api_query.dart';
import '../models/MetaInfo.dart';
import '../services/utils_functions.dart';
import '../widgets/navigation_widgets/nav_button.dart';

class RegistrationPage extends StatefulWidget {
  String get title => 'Registration page';

  NavigationOptions get page => NavigationOptions.registration;
  final BuildContext context;

  const RegistrationPage(this.context, {super.key});

  void changePage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _telegramController = TextEditingController();
  String _errorMessage = '';

  Future<void> _handleRegistration() async {
    if (_formKey.currentState!.validate()) {
      final String hashedPassword = hashPassword(_passwordController.text);

      final ApiQuery query = ApiQueryBuilder()
          .path(QueryPaths.register)
          .addParameter('name', _nameController.text)
          .addParameter('login', _usernameController.text)
          .addParameter('password', hashedPassword)
          .addParameter('tg_nick', _telegramController.text)
          .build();
      final apiManager = MetaInfo.getApiManager();
      ApiResponse response = await apiManager.post(query);
      if (response.success) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Регистрация успешно завершена! Теперь вы можете войти в систему.'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        });

        final metaInfo = MetaInfo.instance;
        metaInfo.set(MetaKeys.userId, response.body['id']);
        widget.changePage();
      } else {
        setState(() {
          _errorMessage = 'Ошибка при регистрации';
        });
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
                        addTextFormField('Имя', _nameController, usernameValidator()),
                        const SizedBox(height: 16),
                        addTextFormField('Логин', _usernameController, loginValidator()),
                        const SizedBox(height: 16),
                        addTextFormField('Пароль', _passwordController, passwordValidator(), obscureText: true),
                        const SizedBox(height: 16),
                        addTextFormField('Ник в Telegram', _telegramController, telegramValidator()),
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

  FormFieldValidator passwordValidator() {
    return ((value) {
      if (value.isEmpty) {
        return 'Пожалуйста, введите пароль';
      }
      if (value.length < 6) {
        return 'Пароль должен содержать минимум 6 символов';
      }
      return null;
    });
  }

  FormFieldValidator usernameValidator() {
    return ((value) {
      if (value == null || value.isEmpty) {
        return 'Пожалуйста, введите имя';
      }
      return null;
    });
  }

  FormFieldValidator loginValidator() {
    return ((value) {
      if (value == null || value.isEmpty) {
        return 'Пожалуйста, введите логин';
      }
      return null;
    });
  }

  FormFieldValidator telegramValidator() {
    return ((value) {
      if (value == null || value.isEmpty) {
        return 'Пожалуйста, введите ник в Telegram';
      }
      return null;
    });
  }

  TextFormField addTextFormField(String label, TextEditingController controller, FormFieldValidator validator,
      {bool obscureText = false}) {
    return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.lock),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        obscureText: obscureText,
        validator: validator);
  }
}
