import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/api_clients/api_client.dart';
import 'package:pizza_and_flutter/widget/menu/detailed_dish.dart';
import 'package:pizza_and_flutter/widget/menu/menu.dart';
import 'package:provider/provider.dart';


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

// Создать список предприятий с присвоением индивидуального номера
// Создать список с дополнениями

class CartProvider with ChangeNotifier {
  final apiclient = ApiClient();
  Future<void> addDishes() async{

    
    Map<String, dynamic>? getCategoryById(int id) {
      return categorizedMenu.firstWhere(
        (category) => category['category_id'] == id,
      );}

    final post = await apiclient.getPosts();
    for (var i = 0; i < 300; i++) {
      final dish_name = post.positions[i].title;
      final price = post.prices[post.positions[i].id];
      final weight = post.positions[i].weight;
      final picture = post.positions[i].image_url;
      final description = post.positions[i].descr;

      // final index1 = categorizedMenu[1]['items'].indexWhere((item) => item.dish_name == post.positions[i].title);
      // final index2 = categorizedMenu[2]['items'].indexWhere((item) => item.dish_name == post.positions[i].title);
      bool flag = false;
      for (var j = 0; j < categorizedMenu.length; j++) {
        final index = categorizedMenu[j]['items'].indexWhere((item) => item.dish_name == post.positions[i].title);
        if(index >= 0){flag = true; break;}
      }
      if (flag || post.positions[i].menu_cat_id == 10953 || post.positions[i].menu_cat_id == 11381 || post.positions[i].menu_cat_id == 11861 || post.positions[i].menu_cat_id == 11862 || post.positions[i].menu_cat_id == 11943 || post.positions[i].menu_cat_id == 12146) {
      print("Элемент уже есть в  меню либо не должен отображаться в меню");
      } else {
      getCategoryById(post.positions[i].menu_cat_id)!['items'].add(Dishes(dish_name: dish_name, price: price![0], weight: weight, picture: picture, description: description, filling: [{"хуй" : 0}], additional_filling: []));
      }
    }
    notifyListeners();
  }

  final List<CartItem> _items = [];
  double discountPercent = 10.0; // Скидка в процентах
  double discountInRubles = 0.0; // Скидка в рублях
  double totalToPay = 0.0; // Всего к оплате

  List<CartItem> get items => _items;

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

class Dishes extends StatelessWidget {
  final String dish_name;
  final int price;
  final String weight;
  final dynamic picture;
  final String description;
  bool with_fillings;
  final List<Map<String, int>> additional_filling;
  final List<Map<String, int>> filling;

  Dishes({
    required this.dish_name,
    required this.price,
    required this.weight,
    required this.picture,
    required this.description,
    this.with_fillings = false,
    required this.filling ,
    required this.additional_filling
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    // Проверяем, есть ли этот товар в корзине
    final index = cart.items.indexWhere((item, ) => item.dish_name == dish_name);
    final bool isInCart = index >= 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Цвет контейнера
        borderRadius: BorderRadius.circular(10), // Закругление углов на 10
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Цвет тени с прозрачностью
            offset: Offset(0, 4), // Смещение тени по горизонтали и вертикали
            blurRadius: 10, // Радиус размытия тени
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(10), // Закругление углов на 10
          //   child: picture // Масштабирование изображения
          // ),
          picture == null ? Container(color: Colors.green, height: 120,) 
          :  ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
                picture, 
                height: 135,
                fit: BoxFit.cover,
                width: double.infinity,
                ),
          ),
          Container(
            height: 120,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dish_name, style: TextStyle(fontFamily: "Inter", fontSize: 16, fontWeight: FontWeight.w500)),
                    Text("${weight.toString()} г", style: TextStyle(fontFamily: "Inter", fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black45)),
                  ],
                ),
                // SizedBox(height: 20),
                if (isInCart)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                      onPressed: () {
                        cart.minusItem(dish_name);
                      },
                      child: Text(
                        "-",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900), // Белый текст
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Красный фон кнопки
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Небольшое закругление
                        ),
                      ),
                    ),
                    Text("${cart.items[index].quantity}", style: TextStyle(fontSize: 20),), // Количество товара
                    ElevatedButton(
                      onPressed: () {
                        cart.plusItem(dish_name);
                      },
                      child: Text(
                        "+",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900), // Белый текст
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Красный фон кнопки
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Небольшое закругление
                        ),
                      ),
                    ),
                    ],
                  )
                else
                  // Если товара нет в корзине, показываем кнопку с ценой
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      with_fillings
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DishDetailScreen(
                                  dishName: dish_name,
                                  description: description,
                                  image: picture,
                                  basePrice: price,
                                  weight: weight,
                                  fillings: filling,
                                  additionalFillings: additional_filling,
                                ),
                              ),
                            )
                        : cart.addItem(dish_name, price, weight, picture, description, "", []);
                    },
                    child: Text(
                      "${price} р",
                      style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700, fontFamily: "Inter"), // Цвет текста
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Красный фон кнопки
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Небольшое закругление
                      ),
                    ),
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
