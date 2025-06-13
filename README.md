# Miner's Descent

Um jogo 2D de Ação e Exploração com elementos de RPG, desenvolvido com o Godot Engine. Explore diferentes mundos, minere recursos, enfrente inimigos perigosos e melhore seu personagem para desvendar os segredos de cada fase.

## 📜 Índice

- [Sobre o Jogo](#-sobre-o-jogo)
- [✨ Funcionalidades Principais](#-funcionalidades-principais)
- [🎮 Como Jogar (Controlos)](#-como-jogar-controlos)
- [🔧 Tecnologias Utilizadas](#-tecnologias-utilizadas)
- [🚀 Começando](#-começando)
- [🤝 Como Contribuir](#-como-contribuir)
- [📄 Licença](#-licença)

## 📖 Sobre o Jogo

Neste jogo, você assume o papel de um aventureiro que explora ambientes perigosos, desde cavernas escuras a vulcões ardentes. Para progredir, é necessário minerar, combater monstros e usar os recursos obtidos para comprar upgrades e chaves que dão acesso a novos desafios. O jogo combina ação rápida com uma progressão estratégica de personagem.

## ✨ Funcionalidades Principais

- **Combate e Mineração:** Sistemas de ação distintos para atacar inimigos e minerar recursos, com animações e sons sincronizados.
- **Progressão de Personagem:** Melhore seu personagem através de uma loja de upgrades, aumentando o dano de ataque, o dano de mineração e a vida máxima.
- **Lojas no Jogo:** Interaja com NPCs como o Ferreiro (loja de upgrades) e um vendedor de chaves para adquirir itens essenciais.
- **Múltiplos Níveis:** Explore diferentes mundos, cada um acessível através de uma chave específica, incentivando a exploração e o acúmulo de riqueza.
- **Inimigos Diversificados:** Enfrente inimigos com comportamentos únicos, como o Slime e o Esqueleto, cada um com sua própria IA de perseguição e ataque.
- **Feedback Audiovisual:** Efeitos sonoros para ações (compra, mineração, ataque, morte) e áudio posicional para dar vida ao ambiente.
- **HUD Dinâmica:** Uma interface de utilizador que exibe a quantidade de dinheiro, formatando números grandes de forma compacta para uma visualização limpa.
- **Sistema de Save/Load:** O progresso do jogador (dinheiro, chaves, upgrades) é guardado automaticamente.

## 🎮 Como Jogar (Controlos)

- **Movimento:** Setas Direcionais (Cima, Baixo, Esquerda, Direita)
- **Ataque:** `[Tecla de Ataque]` (Ex: Espaço, Z) - _Defina a tecla correspondente em "Mapa de Entrada"_
- **Mineração:** `[Tecla de Mineração]` (Ex: X) - _Defina a tecla correspondente em "Mapa de Entrada"_
- **Interação:** `[Tecla de Interação]` (Ex: E) - _Para abrir lojas ao estar perto de NPCs_

## 🔧 Tecnologias Utilizadas

- **Motor de Jogo:** [Godot Engine](https://godotengine.org/) (Versão 4.x)
- **Linguagem:** GDScript

## 🚀 Começando

Para executar este projeto localmente, siga estes passos:

1.  **Instale o Godot Engine:** Certifique-se de que tem o [Godot Engine (versão 4.x ou superior)](https://godotengine.org/download) instalado.
2.  **Clone o Repositório:**
    ```sh
    git clone [https://github.com/PaulinhoLaniusJunior/MinersDescent.git](https://github.com/PaulinhoLaniusJunior/MinersDescent.git)
    ```
3.  **Abra o Projeto no Godot:**
    - Abra o Godot Engine.
    - Na tela do Gerenciador de Projetos, clique em "Importar".
    - Navegue até a pasta do projeto que você clonou e selecione o ficheiro `project.godot`.
4.  **Execute o Jogo:** Pressione `F5` para iniciar a cena principal.

## 🤝 Como Contribuir

Contribuições são bem-vindas! Se você tiver ideias para novas funcionalidades, melhorias ou correções de bugs, sinta-se à vontade para:

1.  Fazer um "Fork" do projeto.
2.  Criar uma nova "Branch" para a sua funcionalidade (`git checkout -b feature/NovaFuncionalidade`).
3.  Fazer "Commit" das suas alterações (`git commit -m 'Adiciona NovaFuncionalidade'`).
4.  Fazer "Push" para a sua Branch (`git push origin feature/NovaFuncionalidade`).
5.  Abrir um "Pull Request".

## 📄 Licença

Este projeto está licenciado sob a Licença MIT. Veja o ficheiro `LICENSE` para mais detalhes.
