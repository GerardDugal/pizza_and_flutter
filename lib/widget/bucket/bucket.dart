import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/widget/bucket/order_registration_delivery.dart';
import 'package:pizza_and_flutter/widget/bucket/order_registration_pick_up.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('В корзине ${cart.items.length} позиции на ${cart.totalToPay} Р'),
      ),
      body: cart.items.isEmpty
          ? Center(child: Text("Корзина пуста"))
          : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return BucketMenu(
                  dish_name: item.dish_name,
                  price: item.price,
                  weight: item.weight,
                  quantity: item.quantity,
                  picture: item.picture,
                  additional_filling: item.additional_filling,
                  filling: item.filling,
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Легкая тень
              offset: Offset(0, -2), // Тень наверх
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Текст "Всего к оплате" серым, а цена больше
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Всего к оплате: ',
                    style: TextStyle(
                      color: Colors.grey, // Серый цвет для текста
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: '${cart.totalAmount()} ₽',
                    style: TextStyle(
                      color: Colors.black, // Стандартный цвет для цены
                      fontSize: 20, // Увеличенный размер шрифта для цены
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Проверка суммы для кнопки
            cart.totalAmount() < 1000
                ? ElevatedButton.icon(
                    onPressed: null, // Кнопка неактивна
                    icon: Icon(Icons.shopping_cart, color: Colors.red), // Красная иконка корзины
                    label: Text(
                      '${1000 - cart.totalAmount()}₽ до заказа',
                      style: TextStyle(color: Colors.red, fontSize: 16), // Красный текст
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey, // Серая кнопка
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Размер кнопки
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Закругленные углы
                      ),
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreenDeliv(),
                        ),
                      );
                    },
                    icon: Icon(Icons.shopping_cart, color: Colors.white), // Иконка корзины
                    label: Text('Заказ', style: TextStyle(color: Colors.white, fontSize: 18)), // Текст "Заказ"
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Красная кнопка
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Размер кнопки
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Закругленные углы
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class BucketMenu extends StatelessWidget {
  final String dish_name;
  final int price;
  final int weight;
  final int quantity;
  final dynamic picture;
  final List<String> additional_filling;
  final String filling;

  BucketMenu({
    required this.dish_name,
    required this.price,
    required this.weight,
    required this.quantity,
    required this.picture,
    required this.additional_filling,
    required this.filling,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final index = cart.items.indexWhere((item) => item.dish_name == dish_name);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4, // Небольшая тень для карточки
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Картинка слева
            Container(
              width: 120,
              height: 120,
              child: picture,
            ),
            SizedBox(width: 10),
            // Описание позиции
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish_name,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text("Цена: $price руб."),
                  Text("$filling, ${additional_filling.join(", ")}"),
                  // Кнопки для изменения количества
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Кнопка уменьшения количества
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Одинаковый размер для кнопок
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: () {
            cart.minusItem(dish_name);
          },
          child: Text(
            "-", 
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900), // Увеличенный текст "-"
          ),
        ),
        SizedBox(width: 5), // Отступ между кнопками и количеством
        // Текущее количество
        Text(
          "${cart.items[index].quantity}",
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(width: 5), // Отступ между кнопками и количеством
        // Кнопка увеличения количества
        
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: () {
            cart.plusItem(dish_name);
          },
          child: Text(
            "+", 
           style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900), // Увеличенный текст "+"
          ),
        ),
        IconButton(
      icon: Icon(Icons.delete, color: Colors.red),
      onPressed: () {
        cart.removeItem(dish_name);
      },
    ),
      ],
    ),
  ],
),
            ),
          ],
        ),
      ),
    );
  }
}
