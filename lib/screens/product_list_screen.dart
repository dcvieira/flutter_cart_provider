import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/cart_badge.dart';
import '../widgets/product_card.dart';

/// Tela principal do aplicativo exibindo o catálogo de produtos.
///
/// 🎓 CONCEITOS IMPORTANTES PARA SALA DE AULA:
/// 1. **addPostFrameCallback**: Disparamos `loadInitialData()` após o primeiro frame da tela
///    ser desenhado, evitando que `notifyListeners()` seja disparado enquanto a árvore
///    de widgets ainda está sendo montada no `initState`.
/// 2. **context.watch vs context.read**:
///    - `context.watch<ProductProvider>()` no `build` para que a tela reconstrua quando os produtos chegarem.
///    - `context.read<ProductProvider>()` nos eventos de clique (filtros, busca, refresh).
/// 3. **LayoutBuilder / Grid Responsivo**: Adapta automaticamente a quantidade de colunas
///    se o aplicativo estiver rodando em celular (2 colunas) ou tablet/web (3 a 4 colunas).
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // 🎓 DIDÁTICA: Agendamos o carregamento inicial para logo após o primeiro frame.
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
    final selectedCategory = productProvider.selectedCategory;

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Buscar produtos...',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context.read<ProductProvider>().clearFilters();
                    },
                  ),
                ),
                onSubmitted: (value) {
                  context.read<ProductProvider>().search(value);
                },
              )
            : const Row(
                children: [
                  Icon(Icons.storefront_rounded),
                  SizedBox(width: 8),
                  Text(
                    'FIAP Store',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            tooltip: _isSearching ? 'Fechar busca' : 'Buscar',
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<ProductProvider>().clearFilters();
                }
              });
            },
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                      isAll ? 'Todos' : category!.replaceAll('-', ' ').toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) {
                      context
                          .read<ProductProvider>()
                          .filterByCategory(category);
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

                // 3. Estado de Lista Vazia
                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Nenhum produto encontrado',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Tente buscar por outro termo ou categoria.'),
                        const SizedBox(height: 20),
                        OutlinedButton(
                          onPressed: () {
                            _searchController.clear();
                            context.read<ProductProvider>().clearFilters();
                          },
                          child: const Text('Limpar Filtros'),
                        ),
                      ],
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
