import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pizza_and_flutter/api_clients/api_client.dart';
import 'package:pizza_and_flutter/carts_and_navigatios/location.dart';
import 'package:pizza_and_flutter/textstyle.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:pizza_and_flutter/widget/menu/dishes_model.dart';
import 'package:pizza_and_flutter/widget/menu/menu.dart';
import 'package:pizza_and_flutter/widget/menu/menu_main.dart';
import 'package:pizza_and_flutter/widget/menu/pickupScreen.dart';
import 'package:pizza_and_flutter/widget/my_orders/my_orders_main.dart';
import 'package:provider/provider.dart';
import 'package:yandex_maps_mapkit_lite/mapkit.dart' as ymm;

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  @override
  void initState() {
    super.initState();
    if (AllPositionsFromServer.isEmpty){ApiClient().getPosts();}
  }

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
                    Panel(name: "Мои заказы", color: Colors.red, TextColor: Colors.white, picture: "images/my_orders.png"),
                    Panel(name: "Рестораны", color: Colors.black, TextColor: Colors.white, picture: "images/location.png")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Panel(name: "Доставка", color: Colors.black, TextColor: Colors.white, picture: "images/delivery.png"),
                    Panel(name: "Самовывоз", color: Colors.red, TextColor: Colors.white, picture: "images/pickup.png")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Panel(name: "Отзыв", color: Colors.white, TextColor: Colors.black, picture: "images/feedback.png"),
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
              style: TextStyles.AboutUs,
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
  final String picture;

  Panel({super.key, required this.name, required this.color, required this.TextColor, required this.picture});

  @override
  State<Panel> createState() => _PanelsState();
}

int _counter = 0;

class _PanelsState extends State<Panel> {
  ymm.MapWindow? _mapWindow;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final TypeOfOrder = Provider.of<CartProvider>(context);
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
                ImageIcon(color: widget.TextColor, AssetImage(widget.picture), size: 70),
                // Icon(widget.icon, color: widget.TextColor, size: 90),
                SizedBox(height: 20),
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
            // final apiclient = ApiClient();
            // apiclient.createAdresses();
            // apiclient.addAddresses();
            // apiclient.addDishes(context);
            TypeOfOrder.setTypeOfOrder(1);
            TypeOfOrder.clearCart();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Menu(TypeOfOrder: 1,)),
            );
          }
          if (widget.name == "Рестораны") {
            TypeOfOrder.setTypeOfOrder(1);
            TypeOfOrder.clearCart();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FlutterMapWidget(onMapCreated:(mapWindow) {
    mapWindow.map.moveWithAnimation(
        ymm.CameraPosition(
          ymm.Point(longitude: 37.618423, latitude:55.751244),
          zoom: 13.0,
          azimuth: 0.0,
          tilt: 0.0,
        ),
        ymm.Animation(ymm.AnimationType.Linear, duration: 1.0),
      );
  }, onMapDispose: () { print('Map disposed');},)),
            );
          }
          if (widget.name == "Самовывоз") {
            TypeOfOrder.setTypeOfOrder(2);
            TypeOfOrder.clearCart();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PickupScreen()),
            );
          }
        },
      ),
    );
  }
}
