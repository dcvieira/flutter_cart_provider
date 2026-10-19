import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aula_provider/main.dart';

void main() {
  testWidgets('AulaProviderApp smoke test - inicializa tela principal e AppBar', (WidgetTester tester) async {
    // Renderiza a aplicação completa com MultiProvider
    await tester.pumpWidget(const AulaProviderApp());

    // Verifica se os elementos essenciais da AppBar estão presentes
    expect(find.text('FIAP Store'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
  });
}
