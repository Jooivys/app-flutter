# 🎲 Dice Combat Game

Um jogo de combate por turnos baseado em texto, desenvolvido com Flutter e Dart. Teste sua sorte em batalhas estratégicas onde cada rolagem de dado D6 pode decidir seu destino!

## 🎮 Sobre o Jogo

Dice Combat Game é um RPG minimalista de turnos onde você escolhe uma classe, enfrenta inimigos aleatórios e rola um dado D6 para determinar o dano causado. O combate é simples mas emocionante: cada ataque depende da sorte do dado somado ao seu ataque base.

## ⚔️ Classes

### Guerreiro
- **HP:** 25
- **Ataque Base:** 3
- **Estilo:** Equilibrado entre ataque e defesa

### Tanque
- **HP:** 35
- **Ataque Base:** 2
- **Estilo:** Alta resistência, baixo ataque

### Mago
- **HP:** 18
- **Ataque Base:** 4
- **Estilo:** Baixa vida, alto dano

## 👹 Inimigos

| Inimigo | HP | Ataque Base |
|---------|----|-------------| 
| Goblin  | 15 |      3      |
| Orc     | 20 |      4      |
| Espectro| 18 |      5      |

## 🎯 Como Jogar

1. **Escolha sua classe** na tela inicial
2. Um **inimigo aleatório** aparece para combate
3. Aperte **"ATACAR"** para rolar o dado D6 (1-6)
4. O dano total é: `Ataque Base + valor do dado`
5. O inimigo responde com seu próprio ataque
6. Continue até alguém chegar a 0 HP
7. Vence o último com HP acima de zero!

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK instalado
- Dart SDK

### Instalação

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/dice_game.git
cd dice_game

# Instale as dependências
flutter pub get

# Execute o jogo
flutter run
```

### Plataformas Suportadas

- 📱 **Android** - Executar em dispositivo Android ou emulador
- 🍎 **iOS** - Executar em dispositivo iOS ou simulador
- 🌐 **Web** - Executar no navegador

Para executar em uma plataforma específica:

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web
flutter run -d chrome
```

## 💻 Tecnologias

- **Flutter** - Framework multiplataforma
- **Dart** - Linguagem de programação
- **dart:math** - Geração de números aleatórios para os dados
- **shared_preferences** - Persistência de dados (moedas)

## 🎨 Características

- ✅ Interface minimalista e retrô
- ✅ Combate por turnos
- ✅ Três classes diferentes
- ✅ Três tipos de inimigos
- ✅ Sistema de HP com barras de progresso
- ✅ Mensagens narrativas de combate
- ✅ **Sistema de log de combate com histórico de jogadas**
- ✅ **Sistema de moedas com persistência** (+10 por vitória, perde todas na derrota)
- ✅ Compatível com Android, iOS e Web
- ✅ Design responsivo

## 🪙 Sistema de Moedas

### Como Funciona
- **Vitória**: Ganhe 10 moedas por combate vencido
- **Derrota**: Perda todas as suas moedas
- **Persistência**: Moedas são salvas automaticamente entre sessões
- **Display**: Visualize suas moedas no menu e durante o combate

### Estratégia
Cada vitória acumula mais moedas, tornando cada batalha importante! Cuide bem do seu HP para não perder todo o seu progresso.

## 📁 Estrutura do Projeto

O código está modularizado em uma arquitetura limpa:

```
lib/
├── main.dart                  # Ponto de entrada do app
├── models/                    # Modelos de dados
│   ├── player_class.dart      # Classes do jogador
│   ├── enemy_type.dart        # Tipos de inimigos
│   ├── game_state.dart        # Estado do jogo (HP, turno, mensagens)
│   └── battle_log.dart        # Sistema de log de combate
│   └── item.dart              # Modelo para itens da loja
├── screens/                    # Telas do aplicativo
│   ├── main_menu_screen.dart  # Tela de seleção de classe
│   └── game_screen.dart       # Tela de combate
│   └── shop_screen.dart       # Tela da loja
├── services/                  # Lógica de negócio
│   ├── game_logic.dart        # Regras do jogo (dados, cálculos)
│   └── currency_service.dart  # Gerenciamento de moedas
│   └── progression_service.dart # Gerenciamento de progressão (ondas)
└── widgets/                   # Componentes reutilizáveis
    ├── hp_bar_widget.dart     # Barra de HP
    ├── battle_log_widget.dart # Widget de log de combate
    └── coin_display_widget.dart # Display de moedas
    └── animated_dice_widget.dart # Widget de dado animado
    
```

### Benefícios da Modularização

- ✅ **Separação de responsabilidades** - Cada módulo tem uma função específica
- ✅ **Reutilização** - Componentes podem ser facilmente reutilizados
- ✅ **Manutenibilidade** - Mais fácil de encontrar e modificar código
- ✅ **Testabilidade** - Módulos podem ser testados independentemente
- ✅ **Escalabilidade** - Facilita adicionar novas features

## 👨‍💻 Desenvolvimento

Desenvolvido com Flutter e Dart para demonstrar conceitos de:
- **Programação orientada a objetos** - Classes e enums bem definidas
- **Gerenciamento de estado** - StatefulWidget com lógica modular
- **Arquitetura modular** - Separação de concerns (models, screens, services, widgets)
- **Design de interfaces** - UI responsiva para Android, iOS e Web

## 👨‍💻 Autores

Este projeto foi desenvolvido por:

- **[ianbrunini](https://github.com/ianbrunini)**
- **[Jooivys](https://github.com/Jooivys)**

---

**Divirta-se rolando os dados! 🎲**
