import 'package:flutter_test/flutter_test.dart';
import 'package:aula_provider/models/product.dart';
import 'package:aula_provider/providers/cart_provider.dart';

void main() {
  group('CartProvider Tests - Gerenciamento de Estado Reativo', () {
    late CartProvider cart;
    const sampleProduct1 = Product(
      id: 1,
      title: 'Smartphone Pro',
      description: 'Smartphone de alta tecnologia',
      category: 'smartphones',
      price: 1000.0,
      thumbnail: 'https://example.com/phone.jpg',
    );

    const sampleProduct2 = Product(
      id: 2,
      title: 'Fone Bluetooth',
      description: 'Fone com cancelamento de ruído',
      category: 'accessories',
      price: 250.0,
      thumbnail: 'https://example.com/phone2.jpg',
    );

    setUp(() {
      cart = CartProvider();
    });

    test('Deve iniciar com o carrinho vazio e total zerado', () {
      expect(cart.items, isEmpty);
      expect(cart.totalItemCount, equals(0));
      expect(cart.uniqueItemCount, equals(0));
      expect(cart.totalAmount, equals(0.0));
    });

    test('Deve adicionar um novo produto ao carrinho e notificar ouvintes', () {
      var listenerNotified = false;
      cart.addListener(() {
        listenerNotified = true;
      });

      cart.addItem(sampleProduct1);

      expect(listenerNotified, isTrue);
      expect(cart.items.length, equals(1));
      expect(cart.contains(1), isTrue);
      expect(cart.getQuantity(1), equals(1));
      expect(cart.totalItemCount, equals(1));
      expect(cart.totalAmount, equals(1000.0));
    });

    test('Deve incrementar a quantidade ao adicionar o mesmo produto repetidamente', () {
      cart.addItem(sampleProduct1);
      cart.addItem(sampleProduct1);

      expect(cart.uniqueItemCount, equals(1));
      expect(cart.getQuantity(1), equals(2));
      expect(cart.totalItemCount, equals(2));
      expect(cart.totalAmount, equals(2000.0));
    });

    test('Deve calcular corretamente o total com múltiplos produtos distintos e quantidades', () {
      cart.addItem(sampleProduct1); // 1x 1000 = 1000
      cart.addItem(sampleProduct1); // 2x 1000 = 2000
      cart.addItem(sampleProduct2); // 1x 250  = 250
      cart.addItem(sampleProduct2); // 2x 250  = 500

      expect(cart.uniqueItemCount, equals(2));
      expect(cart.totalItemCount, equals(4));
      expect(cart.totalAmount, equals(2500.0));
    });

    test('removeSingleItem deve decrementar a quantidade quando maior que 1', () {
      cart.addItem(sampleProduct1);
      cart.addItem(sampleProduct1);
      expect(cart.getQuantity(1), equals(2));

      cart.removeSingleItem(1);

      expect(cart.contains(1), isTrue);
      expect(cart.getQuantity(1), equals(1));
      expect(cart.totalAmount, equals(1000.0));
    });

    test('removeSingleItem deve remover o item quando a quantidade for 1', () {
      cart.addItem(sampleProduct1);
      expect(cart.contains(1), isTrue);

      cart.removeSingleItem(1);

      expect(cart.contains(1), isFalse);
      expect(cart.items, isEmpty);
      expect(cart.totalAmount, equals(0.0));
    });

    test('removeItem deve remover o item completamente independente da quantidade', () {
      cart.addItem(sampleProduct1);
      cart.addItem(sampleProduct1);
      cart.addItem(sampleProduct1);
      expect(cart.getQuantity(1), equals(3));

      cart.removeItem(1);

      expect(cart.contains(1), isFalse);
      expect(cart.items, isEmpty);
      expect(cart.totalAmount, equals(0.0));
    });

    test('clear deve esvaziar todos os produtos e zerar o total a pagar', () {
      cart.addItem(sampleProduct1);
      cart.addItem(sampleProduct2);
      expect(cart.items.length, equals(2));

      cart.clear();

      expect(cart.items, isEmpty);
      expect(cart.totalItemCount, equals(0));
      expect(cart.totalAmount, equals(0.0));
    });
  });
}
