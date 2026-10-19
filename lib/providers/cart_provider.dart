import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

/// [CartProvider] gerencia todo o estado do carrinho de compras do aplicativo.
///
/// 🎓 CONCEITOS IMPORTANTES PARA SALA DE AULA:
/// 1. **Estado Centralizado (Single Source of Truth)**: O carrinho é acessado tanto
///    pela listagem (para exibir o badge com o total de itens), quanto pelo card do produto
///    (para adicionar itens) e pela tela de checkout. O Provider evita o "prop drilling"
///    (passar callbacks e listas de pai para filho manualmente).
/// 2. **Estrutura de Dados Eficiente**: Usamos um `Map<int, CartItem>` indexado pelo ID
///    do produto para operações com complexidade O(1) na checagem e atualização.
/// 3. **Cálculo Derivado (Computed State)**: O valor total e a quantidade total de itens
///    são getters calculados na hora, garantindo que nunca fiquem desincronizados.
class CartProvider extends ChangeNotifier {
  // Mapa de itens no carrinho: chave = id do produto, valor = CartItem
  final Map<int, CartItem> _items = {};

  /// Retorna a lista de itens do carrinho.
  List<CartItem> get items => _items.values.toList();

  /// Quantidade de produtos distintos no carrinho.
  int get uniqueItemCount => _items.length;

  /// Quantidade total de unidades somadas no carrinho (ex: 2 shampoos + 3 sabonetes = 5).
  int get totalItemCount {
    int count = 0;
    _items.forEach((key, item) {
      count += item.quantity;
    });
    return count;
  }

  /// Valor total a pagar somando o subtotal de todos os itens.
  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, item) {
      total += item.subtotal;
    });
    return total;
  }

  /// Verifica se um determinado produto já está no carrinho.
  bool contains(int productId) => _items.containsKey(productId);

  /// Retorna a quantidade de um produto específico no carrinho (0 se não estiver).
  int getQuantity(int productId) => _items[productId]?.quantity ?? 0;

  /// Adiciona um produto ao carrinho.
  /// Se o produto já existir no carrinho, apenas incrementa a sua quantidade.
  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += 1;
    } else {
      _items[product.id] = CartItem(product: product, quantity: 1);
    }

    // Notifica os widgets que estão escutando o CartProvider
    // Ex: O badge na AppBar e a tela de carrinho serão reconstruídos automaticamente!
    notifyListeners();
  }

  /// Decrementa em 1 a quantidade de um item.
  /// Se a quantidade for 1, remove o produto completamente do carrinho.
  void removeSingleItem(int productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity -= 1;
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }

  /// Remove completamente um item do carrinho, independentemente da quantidade.
  void removeItem(int productId) {
    if (_items.remove(productId) != null) {
      notifyListeners();
    }
  }

  /// Atualiza a quantidade exata de um produto. Se for <= 0, remove o item.
  void setQuantity(int productId, int quantity) {
    if (!_items.containsKey(productId)) return;

    if (quantity <= 0) {
      _items.remove(productId);
    } else {
      _items[productId]!.quantity = quantity;
    }

    notifyListeners();
  }

  /// Limpa todos os itens do carrinho (usado ao finalizar compra).
  void clear() {
    if (_items.isNotEmpty) {
      _items.clear();
      notifyListeners();
    }
  }
}


