import 'package:flutter/material.dart';

import 'cart.dart';
import 'checkout_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Корзина покупок',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _products = [
    ('Хлеб', 50.0),
    ('Молоко', 80.0),
    ('Сыр', 300.0),
  ];

  final Cart _cart = Cart();
  int _tapCount = 0;

  void _addProduct() {
    final product = _products[_tapCount % _products.length];
    setState(() {
      _cart.add(product.$1, product.$2);
      _tapCount++;
    });
  }

  void _openCheckout() {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Добавьте товары перед оформлением')),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CheckoutScreen(cart: _cart)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Корзина покупок')),
      body: Column(
        children: [
          Expanded(
            child: _cart.isEmpty
                ? const Center(child: Text('Корзина пуста'))
                : ListView(
                    children: [
                      for (final item in _cart.items)
                        ListTile(
                          title: Text(item.name),
                          subtitle: Text('x${item.quantity}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                setState(() => _cart.remove(item.name)),
                          ),
                        ),
                    ],
                  ),
          ),
          Text(
            'Итого: ${_cart.total.toStringAsFixed(2)} ₸',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _addProduct,
            child: const Text('Добавить товар'),
          ),
          ElevatedButton(
            onPressed: _openCheckout,
            child: const Text('Оформить заказ'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
