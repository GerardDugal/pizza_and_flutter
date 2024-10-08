import 'package:flutter/material.dart';


class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Мои заказы"),),
      body: ListView(
      children: [
        Order(),
        Order(),
        Order(),
        Order(),
        Order(),
        Order(),
        Order(),
        Order(),
        Order(),
        Order(),
      ],
        )
      );
  }
}


class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      color: Colors.green,
      margin: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 120,
            width: 120,
            color: Colors.blue,
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("12.12.1212"),
                Divider(),
                Text("2500"),
                Divider(),
                Container(
                  color: Colors.red,
                  height: 10,
                  width: 50,
                  child: Text("забрать"),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("12.12.1212"),
                Divider(),
                Text("2500"),
                Divider(),
                Container(
                  color: Colors.red,
                  height: 10,
                  width: 50,
                  child: Text("забрать"),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
