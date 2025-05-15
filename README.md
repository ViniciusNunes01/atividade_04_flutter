Descrição:
  Esta branch adiciona um fluxo completo de onboarding ao aplicativo Flutter, incluindo:
    -Splash Screen customizada;
    -Página de Onboarding com carrossel de três passos;
    -Gerenciamento de temas (claro/escuro);
    -Persistência de estado para pular onboarding após o primeiro uso;
    Após o onboarding, o usuário é direcionado para a tela de login.

Funcionalidades:
  -Splash Screen: Tela inicial com logo e background customizados, usando flutter_native_splash;
  -Onboarding: Carrossel de três etapas com animações Lottie e texto explicativo;
  -Persistência: Uso de shared_preferences para armazenar flag de primeira execução;
  -Temas Dinâmicos: Alternância entre tema claro e escuro via ThemeController;
  -Login: Campo de entrada confeccionado com widgets personalizados.

Pacotes Utilizados:
  Pacote                            Descrição
  -flutter_native_splash   ---->    Gera automaticamente as configurações de splash para Android/iOS.
  -lottie                  ---->    Referencia e reproduz animações JSON criadas no After Effects.
  -shared_preferences      ---->    Persiste dados simples (flag de "já visualizado onboarding").
  -provider                ---->    Gerencia estado (tema e progresso de onboarding).
  -flutter_svg             ---->    Renderiza imagens SVG nos cards de onboarding.

Fluxo do Aplicativo:
  1.Splash Screen (lib/splash_page.dart)
    -Exibe imagem e background customizados definidos em flutter_native_splash;
    -Aguarda 2 segundos ou até preload de assets, então verifica a flag em SharedPreferences;
    -Se for primeira execução, navega para OnboardingPage; caso contrário, vai direto ao login.
  2.Onboarding (lib/onboarding_page.dart)
    -Carrega assets/onboarding.json, que contém 3 itens (OnboardItem);
    -Exibe cada passo em um PageView: Imagem (PNG ou SVG), título e descrição, indicadores de página e botão “Próximo” / “Começar” no último passo;
    -Ao concluir, salva flag em SharedPreferences e direciona para LoginPage.
  3.Login (lib/login_page.dart)
    -Formulário simples com campos customizados (login_text_field.dart);
    -Botão de login sem integração real (template para futuras implementações).

Estrutura de pastas:
    ├── assets/
    │   ├── images/              # PNGs e SVGs do onboarding
    │   └── onboarding.json      # Dados do fluxo de onboarding
    ├── lib/
    │   ├── controllers/
    │   │   └── theme_controller.dart
    │   ├── models/
    │   │   └── onboard_item.dart
    │   ├── widgets/
    │   │   ├── info_card.dart
    │   │   └── login_text_field.dart
    │   ├── splash_page.dart
    │   ├── onboarding_page.dart
    │   ├── login_page.dart
    │   ├── dark_theme.dart
    │   ├── light_theme.dart
    │   └── main.dart
    ├── android/                  # Configurações Android (inclui launch_background.xml)
    ├── ios/                      # Configurações iOS
    ├── pubspec.yaml              # Declaração de dependências e assets
    └── README.md
