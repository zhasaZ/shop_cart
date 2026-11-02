class CartItem {
  final String name;
  final double price;
  int quantity;

  CartItem({required this.name, required this.price, this.quantity = 1}) {
    if (name.trim().isEmpty) {
      throw ArgumentError('Name must not be empty');
    }
    if (price < 0) {
      throw ArgumentError('Price must not be negative');
    }
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be positive');
    }
  }

  double get subtotal => price * quantity;
}

class Cart {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  int get totalCount => _items.fold(0, (sum, i) => sum + i.quantity);

  double get total => _items.fold(0.0, (sum, i) => sum + i.subtotal);

  void add(String name, double price, {int quantity = 1}) {
    final index = _items.indexWhere((i) => i.name == name);
    if (index == -1) {
      _items.add(CartItem(name: name, price: price, quantity: quantity));
    } else {
      if (quantity <= 0) {
        throw ArgumentError('Quantity must be positive');
      }
      _items[index].quantity += quantity;
    }
  }

  bool remove(String name) {
    final before = _items.length;
    _items.removeWhere((i) => i.name == name);
    return _items.length < before;
  }

  void clear() => _items.clear();

  double totalWithDiscount(double percent) {
    if (percent < 0 || percent > 100) {
      throw ArgumentError('Discount must be between 0 and 100');
    }
    return total * (100 - percent) / 100;
  }
}
