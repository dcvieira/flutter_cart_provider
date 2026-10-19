import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

/// Serviço responsável pela comunicação HTTP com a API DummyJSON.
///
/// Permite injetar uma instância de [http.Client] para facilitar testes unitários.
class ProductService {
  final http.Client _client;
  static const String _baseUrl = 'https://dummyjson.com';

  ProductService({http.Client? client}) : _client = client ?? http.Client();

  /// Busca a lista de produtos com suporte a paginação e limite.
  Future<List<Product>> fetchProducts({int limit = 50, int skip = 0}) async {
    final uri = Uri.parse('$_baseUrl/products?limit=$limit&skip=$skip');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> productsJson = data['products'] as List<dynamic>? ?? [];
      return productsJson
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Falha ao carregar produtos (Status: ${response.statusCode})');
    }
  }

  /// Busca produtos pelo termo de busca digitado pelo usuário.
  Future<List<Product>> searchProducts(String query) async {
    final uri = Uri.parse('$_baseUrl/products/search?q=${Uri.encodeComponent(query)}');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> productsJson = data['products'] as List<dynamic>? ?? [];
      return productsJson
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Falha ao buscar produtos (Status: ${response.statusCode})');
    }
  }

  /// Busca produtos pertencentes a uma categoria específica.
  Future<List<Product>> fetchProductsByCategory(String category) async {
    final uri = Uri.parse('$_baseUrl/products/category/${Uri.encodeComponent(category)}');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> productsJson = data['products'] as List<dynamic>? ?? [];
      return productsJson
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Falha ao filtrar por categoria (Status: ${response.statusCode})');
    }
  }

  /// Retorna as categorias disponíveis para o filtro.
  Future<List<String>> fetchCategories() async {
    final uri = Uri.parse('$_baseUrl/products/category-list');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> categories = jsonDecode(response.body) as List<dynamic>;
      return categories.map((e) => e.toString()).toList();
    } else {
      throw Exception('Falha ao carregar categorias (Status: ${response.statusCode})');
    }
  }
}
