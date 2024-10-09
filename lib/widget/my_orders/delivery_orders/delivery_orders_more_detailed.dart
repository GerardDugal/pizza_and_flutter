// import 'package:flutter/material.dart';
// import 'package:pizza_and_flutter/widget/my_orders/orders.dart';

// const String time1 = "1:30"; // Время, в которое заказ будет завершен, будет хранить в себе время, когда заказ оказался у пользователя

// enum Status1 {
//   taketo,
//   inprogress,
//   uncompleted,
//   completed
// }

// Map<Status, String> StatusMap1 =  {
//   Status.taketo : "ЗАБРАТЬ К ",
//   Status.inprogress : "В РАБОТЕ",
//   Status.completed : "ВЫПОЛНЕН В $time",
//   Status.uncompleted : "НЕ ВЫПОЛНЕН"
// };

// abstract class Orders1 extends StatelessWidget{
  
//   late final int price;
//   late final int number;
//   late final String date;
//   late final Status status;

//   Orders1({ 
//     required int price,
//     required int number,
//     required String date,
//     required Status status,
//   });

// }

// class DeliveryOrdersDetailed extends Orders1{
//   DeliveryOrdersDetailed({required super.price, required super.number, required super.date, required super.status});


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Заказ №$number от $date"),),
//       body: Container(
//         height: 200,
//         width: 200,
//         color: Colors.green,),
//     );
//   }
// }

// // DeliveryOrdersDetailed s = DeliveryOrdersDetailed(price: ,);



import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/widget/my_orders/orders.dart';

const String time1 = "1:30"; // Время, в которое заказ будет завершен, будет хранить в себе время, когда заказ оказался у пользователя

enum Status1 {
  taketo,
  inprogress,
  uncompleted,
  completed
}

Map<Status1, String> StatusMap1 =  {
  Status1.taketo : "ЗАБРАТЬ К ",
  Status1.inprogress : "В РАБОТЕ",
  Status1.completed : "ВЫПОЛНЕН В $time1",
  Status1.uncompleted : "НЕ ВЫПОЛНЕН"
};

abstract class Orders1 extends StatefulWidget{
  final int price;
  final int number;
  final String date;
  final Status1 status;

  Orders1({ 
    required this.price,
    required this.number,
    required this.date,
    required this.status,
  });
}

class DeliveryOrdersDetailed extends  Orders1{
  DeliveryOrdersDetailed({
    required int price,
    required int number,
    required String date,
    required Status1 status,
  }) : super(price: price, number: number, date: date, status: status);

  @override
  State<DeliveryOrdersDetailed> createState() => _DeliveryOrdersDetailedState();
}

class _DeliveryOrdersDetailedState extends State<DeliveryOrdersDetailed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Заказ №${widget.number} от ${widget.date}")),
      body: Container(
        height: 200,
        width: 200,
        color: Colors.green,
      ),
    );
  }
}

// Пример создания объекта класса DeliveryOrdersDetailed
// DeliveryOrdersDetailed s = DeliveryOrdersDetailed(price: 1000, number: 123, date: "10.10.2024", status: Status1.completed);
