# 🛍️ FIAP E-Commerce - Demonstração Prática de Provider no Flutter

Aplicativo de e-commerce completo e didático desenvolvido para o ensino de gerenciamento de estado com a biblioteca [`provider`](https://pub.dev/packages/provider) no Flutter. O aplicativo consome produtos reais com imagens da API pública [DummyJSON](https://dummyjson.com/docs/products), permitindo explorar catálogo por categorias, buscar produtos, adicionar itens ao carrinho, controlar quantidades e calcular dinamicamente o valor total para pagamento.

---

## 🎯 Conceitos de Provider Ensinados neste Projeto

| Conceito | Descrição | Onde encontrar no projeto |
| :--- | :--- | :--- |
| **`ChangeNotifier`** | Classe observável que armazena estado e dispara notificações aos ouvintes. | [`ProductProvider`](file:///c:/dev/repos/fiap/aula_provider/lib/providers/product_provider.dart) e [`CartProvider`](file:///c:/dev/repos/fiap/aula_provider/lib/providers/cart_provider.dart) |
| **`notifyListeners()`** | Notifica a árvore de widgets quando os dados internos foram alterados. | Chamado nos métodos `addItem()`, `removeItem()`, `loadInitialData()`, etc. |
| **`MultiProvider`** | Agrupa múltiplos provedores no nó raiz da aplicação, evitando o aninhamento excessivo. | [`main.dart`](file:///c:/dev/repos/fiap/aula_provider/lib/main.dart) |
| **`Consumer<T>`** | Reconstrói cirurgicamente apenas o nó da árvore onde está envelopado, otimizando performance. | [`CartBadge`](file:///c:/dev/repos/fiap/aula_provider/lib/widgets/cart_badge.dart) (Ícone da AppBar) |
| **`context.watch<T>()`** | Inscreve o widget inteiro para reconstruir sempre que o estado mudar. | [`CartScreen`](file:///c:/dev/repos/fiap/aula_provider/lib/screens/cart_screen.dart) e [`ProductListScreen`](file:///c:/dev/repos/fiap/aula_provider/lib/screens/product_list_screen.dart) |
| **`context.read<T>()`** | Acessa métodos do provider sem assinar mudanças (ideal para eventos de clique). | Botões de adicionar no [`ProductCard`](file:///c:/dev/repos/fiap/aula_provider/lib/widgets/product_card.dart) e [`ProductDetailScreen`](file:///c:/dev/repos/fiap/aula_provider/lib/screens/product_detail_screen.dart) |

---

## 🏛️ Estrutura de Pastas do Projeto

```text
lib/
├── models/
│   ├── product.dart               # Modelo de dados do produto (JSON parsing)
│   └── cart_item.dart             # Modelo do item no carrinho (produto + quantidade + subtotal)
├── services/
│   └── product_service.dart       # Serviço HTTP que consome a API DummyJSON
├── providers/
│   ├── product_provider.dart      # Gerenciamento de estado do catálogo, busca e filtros
│   └── cart_provider.dart         # Gerenciamento de estado do carrinho e cálculo de totais
├── screens/
│   ├── product_list_screen.dart   # Catálogo com GridView responsivo e filtros
│   ├── product_detail_screen.dart # Tela com galeria de imagens e detalhes
│   └── cart_screen.dart          # Carrinho interativo, controle de quantidade e checkout
├── widgets/
│   ├── cart_badge.dart            # Ícone de carrinho reativo na AppBar (usando Consumer)
│   ├── product_card.dart          # Card do produto com imagem, preço e botão de adicionar
│   ├── cart_item_tile.dart        # Item do carrinho com botões (+ / - / deslizar para excluir)
│   └── order_summary_card.dart    # Resumo com total calculado e botão de finalizar compra
├── utils/
│   └── currency_formatter.dart    # Utilitário para formatação monetária padrão BRL (R$)
└── main.dart                      # Configuração do MultiProvider e tema Material 3
```

---

## 🚀 Como Executar o Projeto

### Pré-requisitos
- Flutter SDK instalado (versão 3.x ou superior)
- Navegador Google Chrome, emulador Android ou simulador iOS

### 1. Obter dependências
```bash
flutter pub get
```

### 2. Executar testes automatizados
```bash
flutter test
```

### 3. Rodar a aplicação
```bash
# Para rodar no Chrome (Web):
flutter run -d chrome

# Para rodar no emulador/dispositivo conectado:
flutter run
```

---

## 🧪 Testes Unitários de Estado

O projeto inclui testes unitários no diretório `test/cart_provider_test.dart` comprovando a facilidade de testar classes que herdam de `ChangeNotifier` sem precisar inflar widgets:
- Adição de novos produtos.
- Incremento de quantidade para produtos existentes.
- Cálculo correto de subtotais e valor total a pagar.
- Decremento de quantidade e remoção automática ao atingir 0.
- Esvaziamento completo do carrinho (`clear()`).
