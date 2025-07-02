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
  Widget build(BuildContext context) {
    if (items == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: PageView.builder(
        controller: _pc,
        itemCount: items!.length,
        itemBuilder: (context, index) {
          final it = items![index];
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(it.image, height: 200),
                  const SizedBox(height: 20),
                  Text(it.title, style: Theme.of(context).textTheme.headlineSmall),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(it.desc, textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 24),
                  if (index == items!.length - 1)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // cor verde para o botão
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text('Começar'),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}