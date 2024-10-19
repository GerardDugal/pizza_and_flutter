import 'package:pizza_and_flutter/api_clients/api_client.dart';
import 'package:pizza_and_flutter/domain/entity/post.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


List<Map<String, dynamic>> categorizedMenu = [];


class CartProvider with ChangeNotifier {

  final apiclient = ApiClient();
  
  Future<void> reloadPosts() async{
    final post = await apiclient.getPositons();
  }

  final List<CartItem> _items = [];
  double discountPercent = 10.0; // Скидка в процентах
  double discountInRubles = 0.0; // Скидка в рублях
  double totalToPay = 0.0; // Всего к оплате

  List<CartItem> get items => _items;

  void addItem(String name, int price, int weight, dynamic picture, String description, String filling, List<String> adding) {
    // Проверка, есть ли уже такой товар в корзине
    final index = _items.indexWhere((item) => item.dish_name == name);
    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(CartItem(dish_name: name, price: price, weight: weight, description: description, picture: picture, filling: filling, additional_filling: adding));
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