import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';

/// [ProductProvider] é uma classe de gerenciamento de estado que estende [ChangeNotifier].
///
/// 🎓 CONCEITOS IMPORTANTES PARA SALA DE AULA:
/// 1. **ChangeNotifier**: É uma classe nativa do Flutter/Foundation que implementa o padrão Observer.
///    Qualquer objeto que estenda [ChangeNotifier] pode notificar seus observadores sobre mudanças.
/// 2. **Encapsulamento**: As variáveis internas (`_products`, `_isLoading`, etc.) são privadas.
///    A UI acessa o estado apenas através de getters públicos imutáveis.
/// 3. **notifyListeners()**: É o método que avisa todos os widgets inscritos (via `context.watch`,
///    `Consumer` ou `Provider.of`) que o estado mudou e que eles precisam ser redesenhados.
class ProductProvider extends ChangeNotifier {
  final ProductService _service;

  ProductProvider(this._service);

  // Estados privados
  List<Product> _products = [];
  List<String> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters públicos para acesso pela interface gráfica
  List<Product> get products => List.unmodifiable(_products);
  List<String> get categories => List.unmodifiable(_categories);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Carrega os produtos iniciais e a lista de categorias da API.
  Future<void> loadInitialData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notifica a UI para exibir o indicador de carregamento (Spinner)

    try {
      final results = await Future.wait([
        _service.fetchProducts(limit: 60),
        _service.fetchCategories(),
      ]);

      _products = results[0] as List<Product>;
      _categories = results[1] as List<String>;
      _errorMessage = null;
    } catch (e) {
      _errorMessage =
          'Não foi possível carregar os produtos. Verifique sua conexão.';
    } finally {
      _isLoading = false;
      notifyListeners(); // Notifica a UI que o carregamento terminou (com sucesso ou com erro)
    }
  }

  /// Filtra a lista de produtos por uma categoria específica.
  /// Passar `null` limpa o filtro e recarrega todos os produtos.
  Future<void> filterByCategory(String? category) async {}
}
