import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("какой-то адрес")),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        childAspectRatio: (200 / 310),
        children: <Widget>[
          Dishes(dish_name: "Ебать пицца с черри нахуй ебнись просто", price: 666, weight: 1050, quantity: 0, picture: null,),
          Dishes(dish_name: "Ебанина с рисом или хуй его знает", price: 666, weight: 1050, quantity: 0, picture: null,),
          Dishes(dish_name: "вяленная конская залупа", price: 666, weight: 1050, quantity: 0, picture: null,),
          Dishes(dish_name: "хер моржовый", price: 666, weight: 1050, quantity: 0, picture: null,),

        ],
      ),
    );
  }
}