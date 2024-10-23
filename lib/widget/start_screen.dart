import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pizza_and_flutter/api_clients/api_client.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:pizza_and_flutter/widget/menu/menu_main.dart';
import 'package:pizza_and_flutter/widget/my_orders/my_orders_main.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Оборачиваем в SingleChildScrollView
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 60, 20, 30),
          child: Column(
            children: [
              AboutUs(),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Panel(name: "Мои заказы", color: Colors.red, TextColor: Colors.white, icon: Ionicons.receipt_outline),
                    Panel(name: "Рестораны", color: Colors.black, TextColor: Colors.white, icon: Ionicons.location_outline)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Panel(name: "Доставка", color: Colors.black, TextColor: Colors.white, icon: Ionicons.home_outline),
                    Panel(name: "Самовывоз", color: Colors.red, TextColor: Colors.white, icon: Ionicons.car_sport_outline)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Panel(name: "Отзыв", color: Colors.white, TextColor: Colors.black, icon: Ionicons.chatbox_ellipses_outline),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutUs extends StatelessWidget {
  AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    final image = AssetImage('images/pizza_main.png');
    return Center(
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(image: image),
          ),
          Container(
            margin: EdgeInsets.only(left: 15),
            child: Text(
              "О нас",
              style: TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.w700),
            ),
          )
        ],
      ),
    );
  }
}

class Panel extends StatefulWidget {
  final String name;
  final Color color;
  final Color TextColor;
  final IoniconsData icon;

  Panel({super.key, required this.name, required this.color, required this.TextColor, required this.icon});

  @override
  State<Panel> createState() => _PanelsState();
}

int _counter = 0;

class _PanelsState extends State<Panel> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: InkWell(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5, blurStyle: BlurStyle.outer)],
            color: widget.color,
            borderRadius: BorderRadius.circular(10),
          ),
          width: (screenWidth - 70) / 2,
          height: (screenWidth - 70) / 2,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.fromLTRB(12, 20, 12, 3),
            child: Column(
              children: [
                Icon(widget.icon, color: widget.TextColor, size: 90),
                Divider(color: widget.TextColor, thickness: 0.4),
                Text(
                  widget.name,
                  style: TextStyle(
                    color: widget.TextColor,
                    fontFamily: "Inter",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          if (widget.name == "Мои заказы") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyOrders()),
            );
          }
          if (widget.name == "Доставка") {
            final apiclient = ApiClient();
            // apiclient.createAdresses();
            apiclient.addAddresses();
            apiclient.addDishes();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Menu()),
            );
          }
          if (widget.name == "Самовывоз") {
            // ApiClient apiclient = ApiClient();
            // apiclient.getPosts();
            // apiclient.createAdresses();
          }
        },
      ),
    );
  }
}
