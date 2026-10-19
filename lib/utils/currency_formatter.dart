import 'package:intl/intl.dart';

/// Utilitário para formatação de moeda consistente em todo o aplicativo.
class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: r'R$',
    decimalDigits: 2,
  );

  /// Formata um valor numérico no padrão de moeda brasileiro (Ex: R$ 49,90).
  static String format(double value) {
    try {
      return _formatter.format(value);
    } catch (_) {
      return 'R\$ ${value.toStringAsFixed(2)}';
    }
  }
}
