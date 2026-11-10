import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:conociendo_imc/main.dart';

void main() {
  group('Lógica del IMC', () {
    test('calcula el IMC con un decimal (cm a m)', () {
      expect(calcularImc(45, 160), 17.6);
      expect(calcularImc(70, 175), 22.9);
      expect(calcularImc(75, 165), 27.5);
      expect(calcularImc(100, 170), 34.6);
    });

    test('clasifica incluyendo los límites', () {
      expect(obtenerCategoria(17.6), 'Bajo peso');
      expect(obtenerCategoria(18.5), 'Peso normal'); // límite
      expect(obtenerCategoria(24.9), 'Peso normal');
      expect(obtenerCategoria(25.0), 'Sobrepeso'); // límite
      expect(obtenerCategoria(29.9), 'Sobrepeso');
      expect(obtenerCategoria(30.0), 'Obesidad'); // límite
    });

    test('redondea antes de clasificar', () {
      // 72.13 kg y 170 cm dan 24.96...: se redondea a 25.0 -> sobrepeso.
      final imc = calcularImc(72.13, 170);
      expect(imc, 25.0);
      expect(obtenerCategoria(imc), 'Sobrepeso');
    });

    test('casos de prueba de los límites del planteamiento', () {
      expect(calcularImc(60, 180), 18.5);
      expect(calcularImc(73, 170), 25.3);
      expect(calcularImc(87, 170), 30.1);
    });
  });

  group('Pantalla', () {
    testWidgets('Calcular muestra el resultado y Limpiar lo borra',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MyApp());
      expect(find.text('Conociendo tu IMC'), findsOneWidget);
      expect(find.text('Aquí aparecerá el resultado'), findsOneWidget);

      await tester.enterText(find.byType(TextField).at(0), 'Ana');
      await tester.enterText(find.byType(TextField).at(1), '45');
      await tester.enterText(find.byType(TextField).at(2), '160');
      await tester.tap(find.text('Calcular IMC'));
      await tester.pumpAndSettle();

      // El mensaje aparece en el diálogo y en la etiqueta.
      expect(find.textContaining('Tu IMC es 17.6.'), findsNWidgets(2));
      expect(find.textContaining('Bajo peso'), findsNWidgets(2));

      await tester.tap(find.text('Aceptar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Limpiar datos'));
      await tester.pump();
      expect(find.text('Aquí aparecerá el resultado'), findsOneWidget);
    });

    testWidgets('Campos vacíos muestran «Datos incompletos»',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Calcular IMC'));
      await tester.pumpAndSettle();
      expect(find.text('Datos incompletos'), findsOneWidget);
    });
  });
}
