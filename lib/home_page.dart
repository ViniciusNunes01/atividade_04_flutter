import 'package:flutter/material.dart';

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

  void _adicionarAnotacao(String anotacao) {
    if (_disciplinaSelecionada != null) {
      setState(() {
        _disciplinasComAnotacoes[_disciplinaSelecionada]!.add(anotacao);
      });
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

  void _adicionarDisciplina(String disciplina) {
    setState(() {
      _disciplinasComAnotacoes[disciplina] = [];
    });
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
    int totalAnotacoes =
        _disciplinasComAnotacoes.values.fold(0, (sum, list) => sum + list.length);

    double progressoDisciplinas = (totalDisciplinas / 5).clamp(0.0, 1.0);
    double progressoAnotacoes = (totalAnotacoes / 10).clamp(0.0, 1.0);

    return ((progressoDisciplinas + progressoAnotacoes) / 2).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
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
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Adicionar Disciplina',
                  onPressed: _mostrarAdicionarDisciplina,
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: _disciplinaSelecionada != null
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Progresso de Engajamento:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: _calcularProgresso(),
                      minHeight: 10,
                      backgroundColor: Colors.grey[300],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Anotações para ${_disciplinaSelecionada!}:',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
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
            : const Center(
                child: Text(
                  'Selecione uma disciplina no menu.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
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
