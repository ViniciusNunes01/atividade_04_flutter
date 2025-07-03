import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/onboard_item.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  List<OnboardItem>? items;
  final PageController _pc = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/onboarding.json').then((jsonStr) {
      final list = json.decode(jsonStr) as List;
      setState(() {
        items = list.map((e) => OnboardItem.fromJson(e)).toList();
      });
    });
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // PageView com o conteúdo de cada tela
            PageView.builder(
              controller: _pc,
              itemCount: items!.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                final it = items![index];
                // Conteúdo centralizado para cada página
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(it.image, height: 280),
                      const SizedBox(height: 40),
                      Text(
                        it.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        it.desc,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Botão "Pular"
            if (_currentPage != items!.length - 1)
              Positioned(
                top: 16.0,
                right: 16.0,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('Pular'),
                ),
              ),

            // Indicadores de página e botão de navegação
            Positioned(
              bottom: 30.0,
              left: 24.0,
              right: 24.0,
              child: Column(
                children: [
                  // Indicadores (pontos)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(items!.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 30),

                  // Botão "Próximo" / "Começar"
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentPage == items!.length - 1
                            ? Colors.green // Cor verde no último botão
                            : Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        if (_currentPage == items!.length - 1) {
                          Navigator.pushReplacementNamed(context, '/login');
                        } else {
                          _pc.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                          _currentPage == items!.length - 1 ? 'Começar' : 'Próximo'),
                    ),
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