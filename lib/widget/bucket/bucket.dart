import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/api_clients/api_client.dart';
import 'package:pizza_and_flutter/widget/bucket/order_registration_delivery.dart';
import 'package:pizza_and_flutter/widget/bucket/order_registration_pick_up.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:pizza_and_flutter/widget/menu/dishes_model.dart';
import 'package:provider/provider.dart';
import 'package:hugeicons/hugeicons.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Column(
              children: [
                Text('В корзине ${cart.items.length} позиции', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('на ', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19)),
                    Text('${cart.totalAmount()} ₽', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700, fontSize: 19),),
                  ],
                ),
              ],
            ),
            Spacer(flex: 2),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text("Корзина пуста"))
          : ListView.builder(
            padding: EdgeInsets.only(top: 25),
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
      bottomNavigationBar: BottomBar(cart: cart),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key, required this.cart}) : super(key: key);

  final CartProvider cart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Всего к оплате: ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                TextSpan(
                  text: '${cart.totalAmount()} ₽',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: cart.totalAmount() < 1000
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => cart.TypeOfOrder == 1 ? CheckoutScreenDeliv() : CheckoutScreenPickUp(),
                      ),
                    );
                  },
            icon: Icon(
              Icons.shopping_cart,
              color: cart.totalAmount() < 1000 ? Colors.red : Colors.white,
            ),
            label: Text(
              cart.totalAmount() < 1000
                  ? '${1000 - cart.totalAmount()}₽ до заказа'
                  : 'Заказ',
              style: TextStyle(
                color: cart.totalAmount() < 1000 ? Colors.red : Colors.white,
                fontSize: cart.totalAmount() < 1000 ? 16 : 18,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: cart.totalAmount() < 1000
                  ? Colors.grey
                  : Colors.red,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BucketMenu extends StatelessWidget {
  final String dish_name;
  final int price;
  final String weight;
  final int quantity;
  final dynamic picture;
  final List<String> additional_filling;
  final String filling;

  const BucketMenu({
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
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Картинка слева
          Container(
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                picture,
                fit: BoxFit.cover,
                width: double.infinity,
                ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow(dish_name, "$price р"),
                  const Text("Арт. 1234556"),
                  Text("$filling ${additional_filling.join(", ")}"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: _buildCounterButton(cart, Icon(Icons.remove, color: Colors.white, size: 30), dish_name, () {
                          cart.minusItem(dish_name);
                        }),
                      ),
                      Text(
                        "${cart.items[index].quantity}",
                        style: const TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: _buildCounterButton(cart, Icon(Icons.add, color: Colors.white, size: 30), dish_name, () {
                          cart.plusItem(dish_name);
                        }),
                      ),
                      IconButton(
                        icon: const Icon(HugeIcons.strokeRoundedDelete02, color: Color.fromARGB(255, 92, 92, 92), size: 28),
                        onPressed: () {
                          cart.removeItem(dish_name);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    String limitText(String text, int limit) {
      return text.length > limit ? '${text.substring(0, limit)}...' : text;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          limitText(title, 16),
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

    Widget _buildCounterButton(CartProvider cart, Icon icon, String dishName, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.all(0),
      ),
      onPressed: onPressed,
      child: icon, // Используем переданную иконку вместо текста
    );
  }

}
