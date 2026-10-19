import 'product.dart';

/// Representa um item adicionado ao carrinho de compras.
///
/// Encapsula a referência ao [Product] e a quantidade desejada,
/// fornecendo o cálculo do subtotal do item.
class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  /// Retorna o valor subtotal deste item (preço unitário * quantidade).
  double get subtotal => product.price * quantity;

  /// Cria uma cópia com a quantidade atualizada.
  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}
