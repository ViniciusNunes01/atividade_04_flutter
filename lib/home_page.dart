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
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return Padding(
          padding: const EdgeInsets.all(16.0),
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
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return Padding(
          padding: const EdgeInsets.all(16.0),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: _disciplinaSelecionada != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Anotações para ${_disciplinaSelecionada!}:'),
                Expanded(
                  child: ListView.builder(
                    itemCount: _disciplinasComAnotacoes[_disciplinaSelecionada!]!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_disciplinasComAnotacoes[_disciplinaSelecionada!]![index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _disciplinasComAnotacoes[_disciplinaSelecionada!]!.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_disciplinaSelecionada != null) {
                      setState(() {
                        _disciplinasComAnotacoes[_disciplinaSelecionada]!.clear();
                      });
                    }
                  },
                  child: const Text('Remover todas as anotações'),
                ),
              ],
            )
          : const Center(
              child: Text(
                'Selecione uma disciplina no menu.',
                style: TextStyle(fontSize: 16),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_disciplinaSelecionada != null) {
            _mostrarAdicionarAnotacao();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Selecione uma disciplina primeiro!')),
            );
          }
        },
        tooltip: 'Adicionar Anotação',
        child: const Icon(Icons.note_add),
      ),
    );
  }
}