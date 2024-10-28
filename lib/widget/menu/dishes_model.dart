import 'package:pizza_and_flutter/api_clients/api_client.dart';
import 'package:pizza_and_flutter/domain/entity/post.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:pizza_and_flutter/widget/menu/menu.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class CartItem {
  final String dish_name;
  final int price;
  final String weight;
  int quantity;
  String description;
  final String picture;
  final List<String> additional_filling;
  final String filling;

  CartItem({
    required this.dish_name,
    required this.price,
    required this.weight,
    this.quantity = 1,
    required this.description,
    required this.picture,
    required this.filling,
    required this.additional_filling, // Убираем значение по умолчанию
  });// Инициализируем с помощью значения по умолчанию
}

class CartProvider with ChangeNotifier {

  final List<CartItem> _items = [];
  double discountPercent = 10.0; // Скидка в процентах
  double discountInRubles = 0.0; // Скидка в рублях
  double totalToPay = 0.0; // Всего к оплате
  int _TypeOfOrder = 0;
  String _AddressForPickUp = "Выберете адрес ресторана"; 
  // bool _isLoading = true;

  List<CartItem> get items => _items;

  // void setLoading(isLoading){
  //   _isLoading = isLoading;
  //   notifyListeners();
  // }

  // bool get isLoading => _isLoading;

  void setTypeOfOrder(TypeOfOrder){
    _TypeOfOrder = TypeOfOrder;
    notifyListeners();
  }

  int get TypeOfOrder => _TypeOfOrder;

  void setAddressForPickUp(AddressForPickUp){
    _AddressForPickUp = AddressForPickUp;
    notifyListeners();
  }

  String get AddressForPickUp => _AddressForPickUp;

  void addItem(String name, int price, String weight, String picture, String description, String filling, List<String> adding) {
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