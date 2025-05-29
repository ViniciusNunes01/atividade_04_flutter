# Auth App - Atividade 04: Flutter Login

**Aplicativo Flutter que simula o fluxo de autenticação de um app real, com Splash Screen, Onboarding, Login e suporte a temas claros e escuros.**

---
## 📋 Integrantes:
- Kauan Lopes
- Matheus Castilho 
- Vinícius Nunes 

## 📋 Funcionalidades

* **Splash Screen Nativa:** configurada com `flutter_native_splash`, aparece antes da inicialização Flutter.
* **Splash Animada:** logo entra com fade-in via `AnimationController` e depois redireciona ao Onboarding.
* **Onboarding Dinâmico:** mínimo de 3 telas carregadas de `assets/onboarding.json` usando `PageView`.
* **Tela de Login Funcional:** campos de e-mail e senha com validação, botões “Entrar”, “Registrar-se” e “Esqueci minha senha”.
* **Temas:** light e dark (`light_theme.dart` / `dark_theme.dart`), alternados em tempo real via `ThemeController` e `ValueNotifier`.
* **Widgets Customizados:**

  * `LoginTextFormField` (campo de texto com validação e estilo)
  * `InfoCard` (card reutilizável para renderizar informações dinâmicas a partir de `assets/cards.json`).

---

## 📁 Estrutura do Projeto

```
auth_app/
├─ assets/
│  ├─ images/
│  │  └─ logo.png, step1.png, step2.png, step3.png
│  ├─ onboarding.json
│  └─ cards.json
├─ lib/
│  ├─ controllers/
│  │  └─ theme_controller.dart
│  ├─ models/
│  │  └─ onboard_item.dart
│  ├─ themes/
│  │  ├─ light_theme.dart
│  │  └─ dark_theme.dart
│  ├─ widgets/
│  │  ├─ login_text_field.dart
│  │  └─ info_card.dart
│  ├─ splash_page.dart
│  ├─ onboarding_page.dart
│  ├─ login_page.dart
│  └─ main.dart
└─ pubspec.yaml
```

---

## 🚀 Como Executar

1. **Instale as dependências:**

   ```bash
   flutter pub get
   ```
2. **Gere a Splash nativa:**

   ```bash
   flutter pub run flutter_native_splash:create
   ```
3. **Execute o app:**

   ```bash
   flutter run
   ```
4. **Hot Reload / Restart:**

   * `r` → hot reload
   * `R` → hot restart

---

## 🌿 Branch de Desenvolvimento

Criamos a branch `feature/add-onboarding-assets` para isolar a inclusão de assets e configuração de Onboarding:

```bash
git checkout -b feature/add-onboarding-assets
# adicionar assets e pubspec.yaml
git commit -m "feat(onboarding): include onboarding JSON and step images"
git push -u origin feature/add-onboarding-assets
```

---

## 🛠️ Dependências Principais

* `flutter_native_splash` para splash nativa.
* `cupertino_icons` para ícones básicos.

---

## 📚 Recursos e Referências

* [unDraw](https://undraw.co) – ilustrações gratuitas para onboarding.
* Flutter docs – animações, temas e assets.

---

