import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'widgets/login_text_field.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl  = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Senha')),
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
                hint: 'Nova Senha',
                ctrl: passCtrl,
                obscure: true,
                validator: (v) => v!=null&&v.length>=6 ? null : 'Mínimo 6 caracteres',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final ok = await AuthService()
                        .resetPassword(emailCtrl.text, passCtrl.text);
                    if (ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Senha atualizada!')),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('E-mail não encontrado')),
                      );
                    }
                  }
                },
                child: const Text('Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
