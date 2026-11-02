import 'package:flutter_test/flutter_test.dart';
import 'package:shop_cart/cart.dart';

void main() {
  group('Cart Unit Tests', () {
    late Cart cart;

    setUp(() {
      cart = Cart();
    });

    test('Новая корзина пуста и сумма равна 0', () {
      expect(cart.isEmpty, true);
      expect(cart.total, 0.0);
    });

    test('Добавление товара увеличивает сумму', () {
      cart.add('Хлеб', 50.0);
      expect(cart.items.length, 1);
      expect(cart.total, 50.0);
    });

    test('Повторное добавление увеличивает количество, а не строки', () {
      cart.add('Хлеб', 50.0);
      cart.add('Хлеб', 50.0, quantity: 2);
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 3);
      expect(cart.total, 150.0);
    });

    test('Общая стоимость нескольких товаров', () {
      cart.add('Хлеб', 50.0, quantity: 2);
      cart.add('Сыр', 300.0);
      expect(cart.total, 400.0);
      expect(cart.totalCount, 3);
    });

    test('Удаление существующего товара', () {
      cart.add('Хлеб', 50.0);
      expect(cart.remove('Хлеб'), true);
      expect(cart.isEmpty, true);
    });

    test('Удаление несуществующего товара возвращает false', () {
      expect(cart.remove('Нет такого'), false);
    });

    test('Скидка 10% считается правильно', () {
      cart.add('Сыр', 200.0);
      expect(cart.totalWithDiscount(10), 180.0);
    });

    test('Некорректная скидка выбрасывает ошибку', () {
      expect(() => cart.totalWithDiscount(-5), throwsArgumentError);
      expect(() => cart.totalWithDiscount(101), throwsArgumentError);
    });

    test('Некорректные данные товара выбрасывают ошибку', () {
      expect(() => cart.add('', 10.0), throwsArgumentError);
      expect(() => cart.add('Хлеб', -1.0), throwsArgumentError);
      expect(() => cart.add('Хлеб', 10.0, quantity: 0), throwsArgumentError);
    });

    test('Очистка корзины', () {
      cart.add('Хлеб', 50.0);
      cart.clear();
      expect(cart.isEmpty, true);
      expect(cart.total, 0.0);
    });
  });
}
