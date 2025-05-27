import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<Text> _signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (mounted) {
        context.go('/notes');
      }

      return Text('Login realizado com sucesso!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Text('Usuário não encontrado.');
      } else if (e.code == 'wrong-password') {
        return Text('Senha incorreta.');
      } else {
        return Text('Falha de login: ${e.message}');
      }
    }
  }

  Future<Text> _signUp(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (mounted) context.go('/notes');

      return Text('Registro realizado com sucesso!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return Text('Já existe uma conta com o mesmo email.');
      } else if (e.code == 'weak-password') {
        return Text('Senha não atende aos requisitos mínimos.');
      } else {
        return Text('Falha de registro: ${e.message}');
      }
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      Text loginResponse = await _signIn(email, password);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: loginResponse));
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      Text registerResponse = await _signUp(email, password);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: registerResponse));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 40, color: Colors.deepOrange),
                text: 'PDF',
                children: const <TextSpan>[
                  TextSpan(
                    text: 'Scanner',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 60),
                  ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator:
                        (value) =>
                            value!.isEmpty
                                ? 'Por favor, insira o email.'
                                : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                    validator:
                        (value) =>
                            value!.isEmpty
                                ? 'Por favor, insira a senha.'
                                : null,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        Colors.deepOrangeAccent,
                      ),
                    ),
                    onPressed: _login,
                    child: Text('Login'),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        Colors.deepOrangeAccent,
                      ),
                    ),
                    onPressed: _register,
                    child: Text('Registro'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
