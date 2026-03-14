import 'package:flutter_test/flutter_test.dart';
import 'package:procafes/main.dart';

void main() {
  testWidgets('La aplicación carga correctamente', (WidgetTester tester) async {
    // Construir la app
    await tester.pumpWidget(const ProcafeApp());

    // Verificar que la app se cargó
    expect(find.byType(ProcafeApp), findsOneWidget);
  });
}
