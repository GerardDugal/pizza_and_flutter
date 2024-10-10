import 'dart:ui';
import 'package:flutter/material.dart';

abstract class Dish extends StatefulWidget{
  
  final String dish_name;
  final int price;
  final int weight;
  final int quantity;
  final dynamic picture;

  Dish({required this.dish_name, required this.price, required this.weight, required this.picture, required this.quantity});

}

class Dishes extends Dish {

  Dishes({
      required String dish_name,
      required int price,
      required int weight,
      required int quantity,
      required dynamic picture,
    }) : super(dish_name: dish_name, price: price, weight: weight, quantity: quantity, picture: picture);

  @override
  State<Dishes> createState() => _DishesState();
}

class _DishesState extends State<Dishes> {
  @override
  Widget build(BuildContext context) {
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
                Text(widget.dish_name),
                Text("${widget.weight.toString()} г"),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: () => null, style: ButtonStyle(), child: Text("${widget.price} р"),))
              ],
            ),
          )
        ],
      ),
    );
  }
}

