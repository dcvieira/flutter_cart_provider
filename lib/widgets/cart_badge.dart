import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/cart_screen.dart';

/// [CartBadge] é um componente visual para a AppBar que exibe o ícone de carrinho
/// acompanhado de um indicador numérico (badge) com a quantidade de itens.
///
/// 🎓 CONCEITOS IMPORTANTES PARA SALA DE AULA:
/// 1. **`Consumer<T>`**: Usamos o widget `Consumer<CartProvider>` para escutar o provedor
///    apenas nesta parte específica da árvore de widgets.
/// 2. **Otimização de Performance**: Se usássemos `context.watch<CartProvider>()` no `build`
///    da tela inteira (`ProductListScreen`), a cada item adicionado ao carrinho a tela
///    inteira (incluindo o catálogo com 50+ produtos) seria reconstruída desnecessariamente.
///    Com o `Consumer`, APENAS este ícone é reconstruído!
class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final itemCount = 0;

    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          tooltip: 'Ver carrinho',
          icon: const Icon(Icons.shopping_bag_outlined),
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const CartScreen()));
          },
        ),
        if (itemCount > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                itemCount > 99 ? '99+' : itemCount.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
