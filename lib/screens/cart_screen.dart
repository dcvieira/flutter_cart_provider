import 'package:flutter/material.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/order_summary_card.dart';

/// Tela do Carrinho de Compras.
///
/// 🎓 CONCEITOS IMPORTANTES PARA SALA DE AULA:
/// 1. **`context.watch<T>()`**: Usamos `context.watch<CartProvider>()` no método `build`.
///    Isso registra este widget como ouvinte do `CartProvider`. Sempre que qualquer
///    operação (`addItem`, `removeSingleItem`, `removeItem`, `clear`) chamar
///    `notifyListeners()`, este `build` será executado novamente, atualizando a lista
///    e o valor total instantaneamente.
/// 2. **Renderização Condicional**: Se a lista estiver vazia, exibimos uma tela simpática
///    de estado vazio convidando o usuário a explorar os produtos.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎓 DIDÁTICA: context.watch escuta mudanças no CartProvider.
    // Sempre que o carrinho mudar, a tela se reconstrói com os novos totais.
    // final cart = context.watch<CartProvider>();
    final items = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Carrinho'),
        actions: [
          if (items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Esvaziar carrinho',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Esvaziar carrinho?'),
                    content: const Text(
                      'Tem certeza de que deseja remover todos os produtos do carrinho?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancelar'),
                      ),
                      FilledButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Esvaziar'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: items.isEmpty
          ? _buildEmptyState(context)
          : Column(
              children: [
                // Dica didática / informativa
                Container(
                  width: double.infinity,
                  color: Colors.blue.shade50,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Dica: Deslize um item para a esquerda para removê-lo.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Lista de produtos no carrinho
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return CartItemTile(item: item);
                    },
                  ),
                ),
              ],
            ),
      bottomSheet: items.isEmpty ? null : const OrderSummaryCard(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.remove_shopping_cart_outlined,
                size: 80,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Seu carrinho está vazio',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Navegue pelo nosso catálogo e adicione seus produtos favoritos para vê-los aqui!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              icon: const Icon(Icons.storefront_outlined),
              label: const Text('Explorar Catálogo'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
