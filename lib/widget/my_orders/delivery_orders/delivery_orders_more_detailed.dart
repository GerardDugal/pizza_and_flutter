import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:pizza_and_flutter/widget/my_orders/orders.dart';

class PositionsInOrder extends StatelessWidget {
  const PositionsInOrder({
    super.key,
    required this.ListOfDishes,
  });

  final List<CartItem> ListOfDishes;

  @override
  Widget build(BuildContext context) {
  return Container(
    height: 500,
    child: ListView.builder(
      itemCount: ListOfDishes.length,
      itemBuilder: (context, index) {
        final item = ListOfDishes[index];
        return OrderDishes(
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
  );
}
}

class OrderStatusWidget extends StatelessWidget {
  final DetailedStatus currentStatus;

  const OrderStatusWidget({Key? key, required this.currentStatus}) : super(key: key);

  Color _getStatusColor(DetailedStatus status) {
    return currentStatus == status ? Colors.red : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatusIcon(
                icon: Icons.check,
                status: DetailedStatus.adopted,
              ),
              Container(padding: EdgeInsets.fromLTRB(12, 0, 12, 6), child: Icon(Icons.arrow_forward, size: 16, color: Colors.grey[600],)),
              _buildStatusIcon(
                icon: Icons.access_time,
                status: DetailedStatus.putToWork,
              ),
              Container(padding: EdgeInsets.fromLTRB(12, 0, 12, 6), child: Icon(Icons.arrow_forward, size: 16, color: Colors.grey[600],)),
              _buildStatusIcon(
                icon: Icons.person,
                status: DetailedStatus.toCourier,
              ),
              Container(padding: EdgeInsets.fromLTRB(12, 0, 12, 6), child: Icon(Icons.arrow_forward, size: 16, color: Colors.grey[600],)),
              _buildStatusIcon(
                icon: Icons.emoji_emotions,
                status: DetailedStatus.delivered,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 7),
            child: DetailedStatusMap[currentStatus]),
        ],
      ),
    );
  }

  Widget _buildStatusIcon({required IconData icon, required DetailedStatus status}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: _getStatusColor(status),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 9),
      ],
    );
  }
}

class OrderDishes extends StatelessWidget{
  final String dish_name;
  final int price;
  final String weight;
  final int quantity;
  final dynamic picture;
  final List<String> additional_filling;
  final String filling;

  OrderDishes({
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
              child: picture,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow(dish_name, "$price р"),
                  Text("$filling ${additional_filling.join(", ")}"),
                  Text("$quantity шт.")
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
}