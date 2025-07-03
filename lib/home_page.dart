import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _disciplinaSelecionada;
  final Map<String, List<String>> _disciplinasComAnotacoes = {
    'DM': [],
    'POO': [],
  };

  final ConfettiController _confettiController = ConfettiController(
    duration: const Duration(seconds: 2),
  );

  void _adicionarAnotacao(String anotacao) {
    if (_disciplinaSelecionada != null) {
      setState(() {
        _disciplinasComAnotacoes[_disciplinaSelecionada]!.add(anotacao);
      });

      _verificarConquista();
    }
  }

  void _adicionarDisciplina(String disciplina) {
    setState(() {
      _disciplinasComAnotacoes[disciplina] = [];
    });

    _verificarConquista();
  }

  void _verificarConquista() {
    double progresso = _calcularProgresso();
    if (progresso == 1.0) {
      _confettiController.play();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '🎉 Parabéns! Seu engajamento nos estudos está incrível! Continue assim!',
            style: TextStyle(fontSize: 16),
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _mostrarAdicionarAnotacao() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: 'Nova anotação'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    _adicionarAnotacao(controller.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Adicionar'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _mostrarAdicionarDisciplina() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: 'Nova disciplina'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    _adicionarDisciplina(controller.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Adicionar'),
              ),
            ],
          ),
        );
      },
    );
  }

  double _calcularProgresso() {
    int totalDisciplinas = _disciplinasComAnotacoes.length;
    int totalAnotacoes = _disciplinasComAnotacoes.values.fold(
      0,
      (sum, list) => sum + list.length,
    );

    double progressoDisciplinas = (totalDisciplinas / 3).clamp(0.0, 1.0);
    double progressoAnotacoes = (totalAnotacoes / 5).clamp(0.0, 1.0);

    return ((progressoDisciplinas + progressoAnotacoes) / 2).clamp(0.0, 1.0);
  }

  String _mensagemGamificada() {
    double progresso = _calcularProgresso();

    if (progresso == 1.0) {
      return '🎉 Parabéns! Você está mandando muito bem!';
    } else if (progresso >= 0.6) {
      return '🚀 Continue assim! Está indo muito bem!';
    } else if (progresso >= 0.3) {
      return '💡 Que tal adicionar mais anotações?';
    } else {
      return '📝 Faça mais anotações para aprender mais!';
    }
  }

  Color _corProgresso(double valor) {
    if (valor >= 0.6) return Colors.green;
    if (valor >= 0.3) return Colors.orange;
    return Colors.red;
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progresso = _calcularProgresso();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 237, 136, 149),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/kawaii_note_icon.jpg'),
                    radius: 40,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Disciplinas',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ..._disciplinasComAnotacoes.keys.map(
              (disciplina) => ListTile(
                title: Text(disciplina),
                onTap: () {
                  setState(() {
                    _disciplinaSelecionada = disciplina;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(widget.title),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _mostrarAdicionarDisciplina,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                  child: const Text('Adicionar Disciplina'),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // MENSAGEM DE OBJETIVO NO TOPO
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: const Text(
                      '⭐ Cadastre ao menos 3 disciplinas e 5 anotações para receber um prêmio de engajamento!',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // CONTEÚDO PRINCIPAL DEPENDENDO DE DISCIPLINA SELECIONADA
                  _disciplinaSelecionada != null
                      ? Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Progresso de Engajamento:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            LinearProgressIndicator(
                              value: progresso,
                              minHeight: 10,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _corProgresso(progresso),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _mensagemGamificada(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Anotações para ${_disciplinaSelecionada!}:',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: ListView.builder(
                                itemCount:
                                    _disciplinasComAnotacoes[_disciplinaSelecionada!]!
                                        .length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      _disciplinasComAnotacoes[_disciplinaSelecionada!]![index],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          _disciplinasComAnotacoes[_disciplinaSelecionada!]!
                                              .removeAt(index);
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _disciplinasComAnotacoes[_disciplinaSelecionada!]!
                                      .clear();
                                });
                              },
                              child: const Text('Remover todas as anotações'),
                            ),
                          ],
                        ),
                      )
                      : const Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: Center(
                          child: Text(
                            'Selecione uma disciplina no menu lateral.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),

          // Confetti widget alinhado no topo (caso use a animação de confetes)
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 20,
              minBlastForce: 10,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.2,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_disciplinaSelecionada != null) {
            _mostrarAdicionarAnotacao();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Selecione uma disciplina primeiro!'),
              ),
            );
          }
        },
        tooltip: 'Adicionar Anotação',
        child: const Icon(Icons.note_add),
      ),
    );
  }
}
