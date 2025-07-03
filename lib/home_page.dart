import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import 'controllers/theme_controller.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _disciplinaSelecionada;
  final Map<String, List<String>> _disciplinasComAnotacoes = {
    'Desenvolvimento Mobile': [],
    'Programação Orientada a Objetos': [],
  };

  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 2));

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  // --- Funções de Lógica ---
  void _adicionarAnotacao(String anotacao) {
    if (_disciplinaSelecionada != null && anotacao.isNotEmpty) {
      setState(() {
        _disciplinasComAnotacoes[_disciplinaSelecionada]!.add(anotacao);
      });
      _verificarConquista();
    }
  }

  void _adicionarDisciplina(String disciplina) {
    if (disciplina.isNotEmpty &&
        !_disciplinasComAnotacoes.containsKey(disciplina)) {
      setState(() {
        _disciplinasComAnotacoes[disciplina] = [];
      });
      _verificarConquista();
    }
  }

  void _verificarConquista() {
    double progresso = _calcularProgresso();
    if (progresso == 1.0) {
      _confettiController.play();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '🎉 Parabéns! Seu engajamento nos estudos está incrível!',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  double _calcularProgresso() {
    int totalDisciplinas = _disciplinasComAnotacoes.length;
    int totalAnotacoes =
        _disciplinasComAnotacoes.values.fold(0, (sum, list) => sum + list.length);
    double progressoDisciplinas = (totalDisciplinas / 3).clamp(0.0, 1.0);
    double progressoAnotacoes = (totalAnotacoes / 5).clamp(0.0, 1.0);
    return ((progressoDisciplinas + progressoAnotacoes) / 2).clamp(0.0, 1.0);
  }

  String _mensagemGamificada() {
    double progresso = _calcularProgresso();
    if (progresso == 1.0) return '🎉 Meta alcançada! Você é incrível!';
    if (progresso >= 0.7) return '🚀 Quase lá! Continue com o ótimo trabalho!';
    if (progresso >= 0.4) return '💡 Bom começo! Adicione mais notas para avançar.';
    return '📝 Comece adicionando disciplinas e anotações para ver seu progresso.';
  }

  Color _corProgresso(double valor) {
    if (valor >= 0.7) return Colors.green;
    if (valor >= 0.4) return Colors.orange;
    return Theme.of(context).primaryColor;
  }
  // --- Fim das Funções de Lógica ---

  // --- Funções para mostrar diálogos (modais) ---
  void _mostrarAdicionarAnotacao() {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Nova Anotação',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
                controller: controller,
                decoration: InputDecoration(
                    labelText: 'Digite sua anotação',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  _adicionarAnotacao(controller.text);
                  Navigator.pop(context);
                },
                child: const Text('Salvar')),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _mostrarAdicionarDisciplina() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Disciplina'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Nome da disciplina"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () {
                _adicionarDisciplina(controller.text);
                Navigator.pop(context);
              },
              child: const Text('Adicionar')),
        ],
      ),
    );
  }

  // --- Widgets de Construção da UI ---
  Widget _buildDisciplinaCard(String disciplina, int index) {
    final isSelected = _disciplinaSelecionada == disciplina;
    return GestureDetector(
      onTap: () => setState(() => _disciplinaSelecionada = disciplina),
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade300)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AutoSizeText(
                disciplina,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyLarge?.color,
                ),
                minFontSize: 12,
                maxLines: 4,
                wrapWords: false,
              ),
            ),
            Text(
              '${_disciplinasComAnotacoes[disciplina]!.length} notas',
              style: TextStyle(
                color: isSelected ? Colors.white70 : Colors.grey.shade600,
                fontSize: 12,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAdicionarDisciplinaCard() {
    return GestureDetector(
      onTap: _mostrarAdicionarDisciplina,
      child: Container(
        width: 150,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300)),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 32, color: Colors.grey),
              SizedBox(height: 8),
              Text('Adicionar'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotesSliver() {
    if (_disciplinaSelecionada == null) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.menu_book, size: 60, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              const Text('Selecione uma disciplina para ver suas notas.',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
        ),
      );
    }
    final notes = _disciplinasComAnotacoes[_disciplinaSelecionada]!;
    if (notes.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.note_alt_outlined,
                  size: 60, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              const Text('Nenhuma anotação ainda.',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              const Text('Use o botão "+" para adicionar a primeira!',
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                title: Text(notes[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () => setState(() => notes.removeAt(index)),
                ),
              ),
            );
          },
          childCount: notes.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double progresso = _calcularProgresso();

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Stack(
        children: [
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // 1. Cabeçalho
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(widget.title,
                                style: theme.textTheme.headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            const Spacer(),
                            IconButton(
                              tooltip: "Mudar Tema",
                              icon: Icon(ThemeController.notifier.value ==
                                      ThemeMode.light
                                  ? Icons.dark_mode_outlined
                                  : Icons.light_mode_outlined),
                              onPressed: () {
                                final notifier = ThemeController.notifier;
                                notifier.value =
                                    notifier.value == ThemeMode.light
                                        ? ThemeMode.dark
                                        : ThemeMode.light;
                              },
                            ),
                            IconButton(
                              tooltip: "Sair",
                              icon: const Icon(Icons.logout),
                              onPressed: () =>
                                  Navigator.pushReplacementNamed(context, '/login'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: theme.dividerColor.withOpacity(0.1))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Seu Progresso de Engajamento',
                                  style: theme.textTheme.titleMedium),
                              const SizedBox(height: 12),
                              LinearProgressIndicator(
                                value: progresso,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(4),
                                backgroundColor:
                                    theme.dividerColor.withOpacity(0.1),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    _corProgresso(progresso)),
                              ),
                              const SizedBox(height: 8),
                              Text(_mensagemGamificada(),
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey.shade600)),
                              const SizedBox(height: 4),
                              Text(
                                'Meta: 3 disciplinas e 5 anotações.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. Seção de Disciplinas
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text('Disciplinas',
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      itemCount: _disciplinasComAnotacoes.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _disciplinasComAnotacoes.length) {
                          return _buildAdicionarDisciplinaCard();
                        }
                        final disciplina =
                            _disciplinasComAnotacoes.keys.elementAt(index);
                        return _buildDisciplinaCard(disciplina, index);
                      },
                    ),
                  ),
                ),

                // 3. Seção de Anotações
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 32,
                            child: _disciplinaSelecionada == null
                                ? Text(
                                    'Anotações Recentes',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold),
                                  )
                                : Marquee(
                                    text:
                                        'Anotações de $_disciplinaSelecionada',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold),
                                    scrollAxis: Axis.horizontal,
                                    velocity: 50.0,
                                    blankSpace: 20.0,
                                  ),
                          ),
                        ),
                        if (_disciplinaSelecionada != null)
                          IconButton(
                            icon: const Icon(Icons.delete_sweep_outlined,
                                color: Colors.redAccent),
                            tooltip: "Apagar disciplina",
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Apagar Disciplina?'),
                                  content: Text(
                                      'Isso removerá "${_disciplinaSelecionada!}" e todas as suas anotações. Deseja continuar?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancelar')),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _disciplinasComAnotacoes
                                              .remove(_disciplinaSelecionada);
                                          _disciplinaSelecionada = null;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Apagar',
                                          style:
                                              TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                      ],
                    ),
                  ),
                ),
                _buildNotesSliver(),
              ],
            ),
          ),

          // Efeito de Confete
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
      floatingActionButton: _disciplinaSelecionada == null
          ? null
          : FloatingActionButton.extended(
              onPressed: _mostrarAdicionarAnotacao,
              label: const Text('Nova Anotação'),
              icon: const Icon(Icons.add),
            ),
    );
  }
}