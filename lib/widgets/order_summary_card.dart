import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../utils/currency_formatter.dart';

/// Card fixo na parte inferior da tela do carrinho com o resumo financeiro.
///
/// 🎓 CONCEITOS IMPORTANTES PARA SALA DE AULA:
/// O resumo utiliza `context.watch<CartProvider>()` ou é inserido em uma tela
/// observadora para refletir instantaneamente qualquer alteração de preços ou quantidades.
class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = context.watch<CartProvider>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Linha de quantidade de itens
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total de itens:',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                Text(
                  '${cart.totalItemCount} unidades',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Linha de Frete
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Frete:',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                const Text(
                  'GRÁTIS',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),

            // Linha do Valor Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total a Pagar:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  CurrencyFormatter.format(cart.totalAmount),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Botão de Finalizar Compra
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text(
                  'Finalizar Compra',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: cart.items.isEmpty
                    ? null
                    : () => _showCheckoutSuccessDialog(context, cart),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCheckoutSuccessDialog(BuildContext context, CartProvider cart) {
    final totalAmount = cart.totalAmount;
    final totalItems = cart.totalItemCount;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(
          Icons.celebration_rounded,
          color: Colors.green,
          size: 54,
        ),
        title: const Text('Pedido Realizado com Sucesso!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Obrigado pela sua compra! Os conceitos de gerenciamento de estado foram aplicados com sucesso.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total de itens:'),
                      Text('$totalItems', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Valor Total:'),
                      Text(
                        CurrencyFormatter.format(totalAmount),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              // Limpa o carrinho e fecha a tela
              cart.clear();
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(); // Volta para a tela inicial
            },
            child: const Text('Voltar à Loja'),
          ),
        ],
      ),
    );
  }
}
