import 'package:aula_provider/providers/product_provider.dart';
import 'package:aula_provider/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_badge.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<String> categories = [
    'eletronicos',
    'roupas',
    'calçados',
    'acessorios',
  ];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    // Agendamos o carregamento inicial para logo após o primeiro frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadInitialData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🎓 DIDÁTICA: context.watch escuta as alterações no ProductProvider
    final productProvider = context.watch<ProductProvider>();
    final products = productProvider.products;
    final categories = productProvider.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.storefront_rounded),
            SizedBox(width: 8),
            Text('FIAP Store', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Buscar',
            onPressed: () {},
          ),
          const CartBadge(),
        ],
      ),
      body: Column(
        children: [
          // Barra de categorias horizontal
          if (categories.isNotEmpty && !_isSearching)
            SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isAll = index == 0;
                  final category = isAll ? null : categories[index - 1];
                  final isSelected = isAll
                      ? selectedCategory == null
                      : selectedCategory == category;

                  return FilterChip(
                    label: Text(
                      isAll
                          ? 'Todos'
                          : category!.replaceAll('-', ' ').toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) {
                 
                    },
                  );
                },
              ),
            ),

          // Área de conteúdo principal
          Expanded(
            child: Builder(
              builder: (context) {
                // 1. Estado de Carregamento
                if (productProvider.isLoading) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Carregando produtos da API...',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                // 2. Estado de Erro
                if (productProvider.errorMessage != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            size: 64,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            productProvider.errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            icon: const Icon(Icons.refresh),
                            label: const Text('Tentar novamente'),
                            onPressed: () {
                              context.read<ProductProvider>().loadInitialData();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // 4. Catálogo com GridView Responsivo
                return RefreshIndicator(
                  onRefresh: () =>
                      context.read<ProductProvider>().loadInitialData(),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = constraints.maxWidth > 900
                          ? 4
                          : (constraints.maxWidth > 600 ? 3 : 2);

                      return GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductCard(product: product);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
