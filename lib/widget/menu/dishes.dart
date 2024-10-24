import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/api_clients/api_client.dart';
import 'package:pizza_and_flutter/widget/menu/detailed_dish.dart';
import 'package:pizza_and_flutter/widget/menu/dishes_model.dart';
import 'package:pizza_and_flutter/widget/menu/menu.dart';
import 'package:provider/provider.dart';

class Dishes extends StatelessWidget {
  final String dish_name;
  final int price;
  final String weight;
  final dynamic picture;
  final String description;
  bool with_fillings;
  // final List<Map<String, int>> additional_filling;
  // final List<Map<String, int>> filling;

  Dishes({
    required this.dish_name,
    required this.price,
    required this.weight,
    required this.picture,
    required this.description,
    this.with_fillings = true,
    // required this.filling ,
    // required this.additional_filling
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
                      child: Icon(Icons.remove, color: Colors.white, size: 30),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Красный фон кнопки
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Небольшое закругление
                        ),
                        padding: EdgeInsets.all(0)
                      ),
                    ),
                    Text("${cart.items[index].quantity}", style: TextStyle(fontSize: 20),), // Количество товара
                    ElevatedButton(
                      onPressed: () {
                        cart.plusItem(dish_name);
                      },
                      child: Icon(Icons.add, color: Colors.white, size: 30),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Красный фон кнопки
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Небольшое закругление
                        ),
                        padding: EdgeInsets.all(0)
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
                                  fillings: listOfAdditionalMenu.firstWhere((category) => category['category_id'] == 11861,)['items'] as List<Map<String, int>>,
                                  additionalFillings: listOfAdditionalMenu.firstWhere((category) => category['category_id'] == 11862,)['items'] as List<Map<String, int>>,
                                ),
                              ),
                            )
                        : cart.addItem(dish_name, price, weight, picture, description, "", []);
                    },
                    child: Text(
                      "${price} ₽",
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
