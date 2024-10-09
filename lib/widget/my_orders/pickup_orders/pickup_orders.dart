import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pizza_and_flutter/widget/my_orders/orders.dart';

class PickUp extends Orders{

  final String pickup_adress;
  final String pickup_time;

  PickUp({
    required int price,
    required int number,
    required String date,
    required Status status,
    required this.pickup_adress,
    required this.pickup_time,
  }) : super(price: price, number: number, date: date, status: status);

  @override
  State<PickUp> createState() => _PickUpState();
  
}

class _PickUpState extends State<PickUp> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5, blurStyle: BlurStyle.outer)],
          borderRadius: BorderRadius.circular(10)
        ),
        margin: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container( // Иконка для самовывоза
              height: 120,
              width: 120,
              decoration: BoxDecoration(color: const Color.fromARGB(255, 247, 218, 218), borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 10), child: Icon(Ionicons.bag_handle_outline, size: 70, color: Colors.grey[600],)),
                  Center(child: Text("Самовывоз", style: TextStyle(color: Colors.grey[600]),))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              width: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.date,
                  style: TextStyle(
                    color: Colors.grey[850],
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500
                  ),),
                  // цена заказа
                  Text("${widget.price.toString()} ₽",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 21,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800
                  ),),
                  Divider(height: 15, color: Colors.white,),
                  //Статус заказа
                  (widget.status == Status.completed)
                  ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "${StatusMap[widget.status]}",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: 'Inter',
                        fontSize: 12
                      ),
                    )
                  ): 
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red, 
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Text(
                      "${StatusMap[widget.status]}${widget.pickup_time}",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontSize: 12
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // номер заказа
                  Text("№${widget.number.toString()}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Divider(height: 41,),
                  // адрес доставки
                  (widget.status == Status.completed)
                  ? Container(
                    height: 40,
                    width: 70,
                  ):
                    Container(
                    height: 40,
                    width: 70,
                    child: Text(widget.pickup_adress, style: TextStyle(fontSize: 10, color: Colors.black54,),), )
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
            // print("Tap");
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const MyOrders()),
            // );
        },
    );
  }
}