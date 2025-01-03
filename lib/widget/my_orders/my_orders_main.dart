import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:pizza_and_flutter/widget/my_orders/delivery_orders/delivery_orders.dart';
import 'package:pizza_and_flutter/widget/my_orders/orders.dart';
import 'package:pizza_and_flutter/widget/my_orders/pickup_orders/pickup_orders.dart';

List <Widget> ListOfsDelivOrders = [
  // Deliv(price: 1600, number: 4512, date: '29.01.2024', status: Status.inprogress, count_positions: 4, detailedStatus: DetailedStatus.delivered, dishList: [],),
  // Deliv(price: 570, number: 4562, date: '29.01.2024', status: Status.uncompleted, count_positions: 4, detailedStatus: DetailedStatus.delivered, dishList: [],),
  ]; 
List <Widget> ListOfPickUpOrders = [
  // PickUp(price: 2500, number: 4218, date: '29.01.2024', status: Status.taketo, pickup_adress: "ул. Пушкина, д. 13", pickup_time: "17:30", count_positions: 4, detailedStatus: DetailedStatus.adopted, dishList: [],),
  // PickUp(price: 2500, number: 4582, date: '29.01.2024', status: Status.completed, pickup_adress: "ул. Пушкина, д. 13", pickup_time: "17:30", count_positions: 4, detailedStatus: DetailedStatus.adopted, dishList: [],),
];

// потом удалить
class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    List <Widget> ListOfOrders = ListOfsDelivOrders + ListOfPickUpOrders;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Мои заказы"),
        centerTitle: true, // Это выравнивает заголовок по центру
      ),
      body: ListView(
      children: ListOfOrders
        )
      );
  }
}

