import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem{
  final String dish_name;
  final int price;
  final int weight;
  int quantity;
  final dynamic picture;

  CartItem ({required this.dish_name, required this.price, required this.weight, this.quantity = 1, required this.picture});
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  double discountPercent = 10.0; // Скидка в процентах
  double discountInRubles = 0.0; // Скидка в рублях
  double totalToPay = 0.0; // Всего к оплате

  List<CartItem> get items => _items;

  void addItem(String name, int price, int weight, dynamic picture) {
    // Проверка, есть ли уже такой товар в корзине
    final index = _items.indexWhere((item) => item.dish_name == name);
    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(CartItem(dish_name: name, price: price, weight: weight, picture: picture));
    }
    notifyListeners();  // Обновляем UI
  }

  void plusItem(String name) {
    final index = _items.indexWhere((item) => item.dish_name == name);
    _items[index].quantity++;
    notifyListeners();  // Обновляем UI
  }

  void minusItem(String name) {
    final index = _items.indexWhere((item) => item.dish_name == name);
    if(_items[index].quantity - 1 == 0){_items.removeWhere((item) => item.dish_name == name);}
    else{_items[index].quantity--;}
    notifyListeners();  // Обновляем UI
  }

  void removeItem(String name) {
    _items.removeWhere((item) => item.dish_name == name);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  int count(String name) {
    final index = _items.indexWhere((item) => item.dish_name == name);
    return _items[index].quantity;
    }

  int totalAmount() {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }
  
  double calculatediscountInRublesTotal() {
    return discountInRubles = totalAmount() * (discountPercent / 100);
  }

  double calctotalToPay(){
    return totalToPay = totalAmount() - discountInRubles;
  }

  int get positionsAmount {
    return _items.length;
  }
}

class Dishes extends StatelessWidget {
  final String dish_name;
  final int price;
  final int weight;
  final dynamic picture;

  Dishes({
    required this.dish_name,
    required this.price,
    required this.weight,
    required this.picture,
  });

  @override
  Widget build(BuildContext context) {
    // Получаем провайдер корзины
    final cart = Provider.of<CartProvider>(context);
    // Проверяем, есть ли этот товар в корзине
    final index = cart.items.indexWhere((item) => item.dish_name == dish_name);
    final bool isInCart = index >= 0;

    return Container(
      color: Colors.amber,
      child: Column(
        children: [
          Container(
            height: 130,
            color: Colors.green,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dish_name),
                Text("${weight.toString()} г"),
                SizedBox(height: 10),
                if (isInCart)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          cart.minusItem(dish_name);
                        },
                        child: Text("-"),
                      ),
                      Text("${cart.items[index].quantity}"), // Количество товара
                      ElevatedButton(
                        onPressed: () {
                          cart.plusItem(dish_name);
                        },
                        child: Text("+"),
                      ),
                    ],
                  )
                else
                  // Если товара нет в корзине, показываем кнопку с ценой
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        cart.addItem(dish_name, price, weight, picture);
                      },
                      child: Text("${price} р"),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
