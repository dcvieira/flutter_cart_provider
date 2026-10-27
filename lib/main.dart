import 'package:aula_provider/providers/product_provider.dart';
import 'package:aula_provider/services/product_service.dart'
    show ProductService;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/product_list_screen.dart';

void main() {
  runApp(const AulaProviderApp());
}

/// Ponto de entrada do aplicativo.
///
/// 🎓 CONCEITOS IMPORTANTES PARA SALA DE AULA:
/// 1. **MultiProvider**:
///    Em aplicativos reais com Provider, é comum termos mais de um estado gerenciado
///    (ex: catálogo de produtos + carrinho de compras + autenticação de usuário).
///    O `MultiProvider` melhora a legibilidade e evita o aninhamento excessivo ("Pyramid of Doom")
///    que ocorreria se colocássemos um `ChangeNotifierProvider` dentro de outro.
///
/// 2. **Por que registrar no topo da árvore (acima do MaterialApp)?**:
///    Quando um Provider está acima do `MaterialApp`, o seu estado fica acessível para
///    QUALQUER rota aberta pelo `Navigator` (como `ProductDetailScreen` e `CartScreen`),
///    pois todas as telas são filhas do `MaterialApp` na hierarquia de contexto!
///
/// 3. **ChangeNotifierProvider**:
///    Cria uma instância do nosso `ChangeNotifier` quando necessário e descarta (`dispose`)
///    automaticamente quando não for mais necessária, evitando vazamento de memória.
class AulaProviderApp extends StatelessWidget {
  const AulaProviderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provedor responsável pelo catálogo de produtos e requisições HTTP
        ChangeNotifierProvider(
          create: (_) => ProductProvider(ProductService()),
        ),
      ],
      child: MaterialApp(
        title: 'FIAP E-Commerce - Provider',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF673AB7), // Deep Purple elegante
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            elevation: 0,
            scrolledUnderElevation: 2,
          ),
          cardTheme: const CardThemeData(elevation: 1, margin: EdgeInsets.zero),
        ),
        home: const ProductListScreen(),
      ),
    );
  }
}
