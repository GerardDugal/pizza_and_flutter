// import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:ionicons/ionicons.dart';


// class MyOrders extends StatelessWidget {
//   const MyOrders({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Center(child: Text("Мои заказы")),),
//       body: ListView(
//       children: [
//         Order(delive: delivery.Takebymyself, price: 2500, number: 4218, date: '29.01.2024', status: "Забрать к 17:30", adress: "ул. Пушкина, д. 13",),
//         Order(delive: delivery.Takebymyself, price: 1600, number: 3465, date: '19.02.2024', status: "Забрать к 12:30", adress: "ул. Милашенкова, д. 13",),
//         Order(delive: delivery.Delivery, price: 2500, number: 4325, date: '01.01.2024', status: "В работе", adress: "ул. Пушкина, д. 13",),
//       ],
//         )
//       );
//   }
// }

// enum delivery {
//   Delivery,
//   Takebymyself,
// }

// // enum Status {
// //   taketo,
// //   inprogress,
// //   uncompleted,
// //   completed
// // }


// abstract class Orders {
//   final delivery delive;
//   final int price;
//   final int number;
//   final String date;
//   final dynamic status;
//   final String adress;


//   Orders (this.delive, this.price, this.number, this.date, this.status, this.adress);
// }

// class Order extends StatefulWidget implements Orders{
  
//   @override
//   final delivery delive;
//   final int price;
//   final int number;
//   final String date;
//   final dynamic status;
//   final String adress;


//   const Order({super.key, required this.delive, required this.price, required this.number, required this.date, required this.status, required this.adress});

//   @override
//   State<Order> createState() => _OrderState();
  
// }

// class _OrderState extends State<Order> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 120,
//       decoration: BoxDecoration(
//         boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5, blurStyle: BlurStyle.outer)],
//         borderRadius: BorderRadius.circular(10)
//       ),
//       margin: EdgeInsets.all(15),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           (widget.delive == delivery.Takebymyself)
//           ? Container( // Иконка для самовывоза
//             height: 120,
//             width: 120,
//             decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
//             child: Column(
//               children: [
//                 Padding(padding: EdgeInsets.only(top: 10), child: Icon(Ionicons.bag_handle_outline, size: 70, color: Colors.grey[600],)),
//                 Center(child: Text("Самовывоз", style: TextStyle(color: Colors.grey[600]),))
//               ],
//             ),
//           ) 
//         : Container( // Иконка для Доставки
//             height: 120,
//             width: 120,
//             decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
//             child: Column(
//               children: [
//                 Padding(padding: EdgeInsets.only(top: 10), child: Icon(Ionicons.home_outline, size: 70, color: Colors.grey[600],)),
//                 Center(child: Text("Доставка", style: TextStyle(color: Colors.grey[600]),))
//               ],
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
//             width: 120,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(widget.date,
//                 style: TextStyle(
//                   color: Colors.grey[850],
//                   fontSize: 16,
//                   fontFamily: 'Inter',
//                   fontWeight: FontWeight.w500
//                 ),),
//                 // цена заказа
//                 Text("${widget.price.toString()} ₽",
//                 style: TextStyle(
//                   color: Colors.red,
//                   fontSize: 21,
//                   fontFamily: 'Inter',
//                   fontWeight: FontWeight.w800
//                 ),),
//                 Divider(height: 15, color: Colors.white,),
//                 //Статус заказа
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.red, 
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
//                   child: Text(
//                     widget.status,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontFamily: 'Inter',
//                       fontSize: 13
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.fromLTRB(10, 10, 10, 6),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 // номер заказа
//                 Text("№${widget.number.toString()}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//                 Divider(height: 41,),
//                 // адрес доставки
//                 Container(
//                   height: 40,
//                   width: 70,
//                   child: Text(widget.adress, style: TextStyle(fontSize: 10, color: Colors.black54,),), )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
