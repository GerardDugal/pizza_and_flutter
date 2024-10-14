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
        title: Text('Корзина'),
      ),
      body: cart.items.isEmpty
          ? Center(child: Text("Корзина пуста"))
          : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return BucketMenu(dish_name: item.dish_name,
                price: item.price,
                weight: item.weight,
                quantity: item.quantity,
                picture: item.picture,
                additional_filling: item.additional_filling,
                filling: item.filling,);
              },
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Итого: ${cart.totalAmount()} руб.'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutScreenDeliv(), // Создайте свой экран HomeScreen
                  ),
                );
              },
              child: Text('Купить'),
            ),
          ],
        ),
      ),
    );
  }
}

class BucketMenu extends StatelessWidget{
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
                Text("${filling}, ${additional_filling.join(", ")}"),
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
