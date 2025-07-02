import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'widgets/login_text_field.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl  = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar-se')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              LoginTextFormField(
                hint: 'E-mail',
                ctrl: emailCtrl,
                validator: (v) => v!=null&&v.contains('@') ? null : 'E-mail inválido',
              ),
              const SizedBox(height: 12),
              LoginTextFormField(
                hint: 'Senha',
                ctrl: passCtrl,
                obscure: true,
                validator: (v) => v!=null&&v.length>=6 ? null : 'Mínimo 6 caracteres',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final ok = await AuthService()
                        .register(emailCtrl.text, passCtrl.text);
                    if (ok) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          content: const Text('Cadastro realizado!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // fecha diálogo
                                Navigator.pop(context); // volta pro login
                              },
                              child: const Text('OK'),
                            )
                          ],
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('E-mail já cadastrado')),
                      );
                    }
                  }
                },
                child: const Text('Registrar'),
              ),
              const SizedBox(height: 16),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    const TextSpan(text: 'Ao criar sua conta, você concorda com os '),
                    TextSpan(
                      text: 'Termos',
                      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: ' & '),
                    TextSpan(
                      text: 'Condições',
                      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
