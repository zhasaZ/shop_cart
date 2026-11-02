import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_cart/main.dart';

void main() {
  testWidgets('Главный экран: заголовок, кнопки, пустая корзина',
      (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Корзина покупок'), findsOneWidget);
    expect(find.text('Корзина пуста'), findsOneWidget);
    expect(find.text('Итого: 0.00 ₸'), findsOneWidget);
    expect(find.text('Добавить товар'), findsOneWidget);
    expect(find.text('Оформить заказ'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });

  testWidgets('Нажатие на кнопку добавляет товар и меняет сумму',
      (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Добавить товар'));
    await tester.pump();

    expect(find.text('Хлеб'), findsOneWidget);
    expect(find.text('Корзина пуста'), findsNothing);
    expect(find.text('Итого: 50.00 ₸'), findsOneWidget);
  });

  testWidgets('Взаимодействие нескольких элементов: два товара',
      (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Добавить товар'));
    await tester.pump();
    await tester.tap(find.text('Добавить товар'));
    await tester.pump();

    expect(find.text('Хлеб'), findsOneWidget);
    expect(find.text('Молоко'), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsNWidgets(2));
    expect(find.text('Итого: 130.00 ₸'), findsOneWidget);
  });

  testWidgets('Кнопка удаления убирает товар', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Добавить товар'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();

    expect(find.text('Хлеб'), findsNothing);
    expect(find.text('Корзина пуста'), findsOneWidget);
    expect(find.text('Итого: 0.00 ₸'), findsOneWidget);
  });

  testWidgets('Оформление пустой корзины показывает предупреждение',
      (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Оформить заказ'));
    await tester.pump();

    expect(find.text('Добавьте товары перед оформлением'), findsOneWidget);
    expect(find.text('Оформление заказа'), findsNothing);
  });

  testWidgets('Переход на экран оформления и возврат назад', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Добавить товар'));
    await tester.pump();
    await tester.tap(find.text('Оформить заказ'));
    await tester.pumpAndSettle();

    expect(find.text('Оформление заказа'), findsOneWidget);
    expect(find.text('Сумма заказа: 50.00 ₸'), findsOneWidget);

    await tester.tap(find.text('Назад'));
    await tester.pumpAndSettle();

    expect(find.text('Корзина покупок'), findsOneWidget);
    expect(find.text('Оформление заказа'), findsNothing);
  });
}
