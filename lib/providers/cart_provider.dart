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
  /// Retorna a lista de itens do carrinho.
  List<CartItem> get items => [];

  /// Valor total a pagar somando o subtotal de todos os itens.
  double get totalAmount {
    return 0;
  }

  /// Quantidade total de unidades somadas no carrinho (ex: 2 shampoos + 3 sabonetes = 5).
  int get totalItemCount {
    return 0;
  }

  /// Verifica se um determinado produto já está no carrinho.
  bool contains(int productId) => false;

  /// Retorna a quantidade de um produto específico no carrinho (0 se não estiver).
  int getQuantity(int productId) => 0;

  /// Adiciona um produto ao carrinho.
  /// Se o produto já existir no carrinho, apenas incrementa a sua quantidade.
  void addItem(Product product) {}

  /// Decrementa em 1 a quantidade de um item.
  /// Se a quantidade for 1, remove o produto completamente do carrinho.
  void removeSingleItem(int productId) {}

  /// Remove completamente um item do carrinho, independentemente da quantidade.
  void removeItem(int productId) {}

  /// Atualiza a quantidade exata de um produto. Se for <= 0, remove o item.
  void setQuantity(int productId, int quantity) {}

  /// Limpa todos os itens do carrinho (usado ao finalizar compra).
  void clear() {}
}
