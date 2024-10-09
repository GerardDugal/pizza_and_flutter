import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';


class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    
    List<Widget> ListOfOrders = [PickUp(price: 2500, number: 4218, date: '29.01.2024', status: Status.taketo, pickup_adress: "ул. Пушкина, д. 13", pickup_time: "17:30",),
      Deliv(price: 1600, number: 4512, date: '29.01.2024', status: Status.inprogress),
      Deliv(price: 570, number: 4562, date: '29.01.2024', status: Status.uncompleted),
      PickUp(price: 2500, number: 4582, date: '29.01.2024', status: Status.completed, pickup_adress: "ул. Пушкина, д. 13", pickup_time: "17:30",),
      ];

    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Мои заказы")),),
      body: ListView(
      children: ListOfOrders
        )
      );
  }
}

const String time = "1:30"; // Время, в колторое заказ будет завершен, будет хранить в себе время, когда заказ оказался у пользователя

enum Status {
  taketo,
  inprogress,
  uncompleted,
  completed
}

Map<Status, String> StatusMap =  {
  Status.taketo : "ЗАБРАТЬ К ",
  Status.inprogress : "В РАБОТЕ",
  Status.completed : "ВЫПОЛНЕН В $time",
  Status.uncompleted : "НЕ ВЫПОЛНЕН"
};

abstract class Orders extends StatefulWidget {
  final int price;
  final int number;
  final String date;
  final Status status;

  Orders({ 
    required this.price,
    required this.number,
    required this.date,
    required this.status,
  });
}

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

  // @override
  // set timeready(String value) => _timeready = value;

  

  @override
  State<PickUp> createState() => _PickUpState();
  
}

class _PickUpState extends State<PickUp> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}


class Deliv extends Orders{

  Deliv({
    required int price,
    required int number,
    required String date,
    required Status status,
  }) : super(price: price, number: number, date: date, status: status);

  @override
  State<Deliv> createState() => _DelivState();
  
}

class _DelivState extends State<Deliv> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5, blurStyle: BlurStyle.outer)],
        borderRadius: BorderRadius.circular(10)
      ),
      margin: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container( // Иконка для Доставки
            height: 120,
            width: 120,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 10), child: Icon(Ionicons.home_outline, size: 70, color: Colors.grey[600],)),
                Center(child: Text("Доставка", style: TextStyle(color: Colors.grey[600]),))
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
                (widget.status == Status.inprogress)
                ? Container(
                  decoration: BoxDecoration(
                    color: Colors.red, 
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Text(
                    "${StatusMap[widget.status]}",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontSize: 12
                    ),
                  )
                ) :
                (widget.status == Status.uncompleted)
                ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "${StatusMap[widget.status]}",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 12
                    ),
                  )
                ) :
                Container(
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
                Container(
                  height: 40,
                  width: 70,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:ionicons/ionicons.dart';


// class MyOrders extends StatelessWidget {
//   const MyOrders({super.key});

//   @override
//   Widget build(BuildContext context) {
    
//     List<Widget> ListOfOrders = [PickUp(price: 2500, number: 4218, date: '29.01.2024', status: Status.taketo, pickup_adress: "ул. Пушкина, д. 13", pickup_time: "17:30",),
//       Deliv(price: 1600, number: 4512, date: '29.01.2024', status: Status.inprogress),
//       Deliv(price: 570, number: 4562, date: '29.01.2024', status: Status.uncompleted),
//       PickUp(price: 2500, number: 4582, date: '29.01.2024', status: Status.completed, pickup_adress: "ул. Пушкина, д. 13", pickup_time: "17:30",),
//       ];

//     return Scaffold(
//       appBar: AppBar(title: Center(child: Text("Мои заказы")),),
//       body: ListView(
//       children: ListOfOrders
//         )
//       );
//   }
// }

// const String time = "1:30"; // Время, в колторое заказ будет завершен, будет хранить в себе время, когда заказ оказался у пользователя

// enum Status {
//   taketo,
//   inprogress,
//   uncompleted,
//   completed
// }

// Map<Status, String> StatusMap =  {
//   Status.taketo : "ЗАБРАТЬ К ",
//   Status.inprogress : "В РАБОТЕ",
//   Status.completed : "ВЫПОЛНЕН В $time",
//   Status.uncompleted : "НЕ ВЫПОЛНЕН"
// };

// abstract class Orders {
//   final int price;
//   final int number;
//   final String date;
//   final Status status;
//   // late String _timeready; // Время, когда заказ будет готов

//   Orders (this.price, this.number, this.date, this.status);

//   // set timeready(String value) => _timeready = value; 
// }

// class PickUp extends StatefulWidget implements Orders{
  
//   @override
//   final int price;
//   @override
//   final int number;
//   @override
//   final String date;
//   @override
//   final Status status;
//   // @override
//   // late String _timeready;


//   final String pickup_adress;
//   final String pickup_time;

//   // @override
//   // set timeready(String value) => _timeready = value;

//   PickUp({super.key, required this.price, required this.number, required this.date, required this.status, required this.pickup_adress, required this.pickup_time});

//   @override
//   State<PickUp> createState() => _PickUpState();
  
// }

// class _PickUpState extends State<PickUp> {
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
//           Container( // Иконка для самовывоза
//             height: 120,
//             width: 120,
//             decoration: BoxDecoration(color: const Color.fromARGB(255, 247, 218, 218), borderRadius: BorderRadius.circular(10)),
//             child: Column(
//               children: [
//                 Padding(padding: EdgeInsets.only(top: 10), child: Icon(Ionicons.bag_handle_outline, size: 70, color: Colors.grey[600],)),
//                 Center(child: Text("Самовывоз", style: TextStyle(color: Colors.grey[600]),))
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
//                 (widget.status == Status.completed)
//                 ? Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: Text(
//                     "${StatusMap[widget.status]}",
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontFamily: 'Inter',
//                       fontSize: 12
//                     ),
//                   )
//                 ): 
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.red, 
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
//                   child: Text(
//                     "${StatusMap[widget.status]}${widget.pickup_time}",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontFamily: 'Inter',
//                       fontSize: 12
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
//                 (widget.status == Status.completed)
//                 ? Container(
//                   height: 40,
//                   width: 70,
//                 ):
//                   Container(
//                   height: 40,
//                   width: 70,
//                   child: Text(widget.pickup_adress, style: TextStyle(fontSize: 10, color: Colors.black54,),), )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// class Deliv extends StatefulWidget implements Orders{
  
//   @override
//   final int price;
//   @override
//   final int number;
//   @override
//   final String date;
//   @override
//   final Status status;
//   // @override
//   // late String _timeready;

//   // @override
//   // set timeready(String value) => _timeready = value;

//   Deliv({super.key, required this.price, required this.number, required this.date, required this.status,});

//   @override
//   State<Deliv> createState() => _DelivState();
  
  
// }

// class _DelivState extends State<Deliv> {
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
//           Container( // Иконка для Доставки
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
//                 (widget.status == Status.inprogress)
//                 ? Container(
//                   decoration: BoxDecoration(
//                     color: Colors.red, 
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
//                   child: Text(
//                     "${StatusMap[widget.status]}",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontFamily: 'Inter',
//                       fontSize: 12
//                     ),
//                   )
//                 ) :
//                 (widget.status == Status.uncompleted)
//                 ? Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: Text(
//                     "${StatusMap[widget.status]}",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w600,
//                       fontSize: 12
//                     ),
//                   )
//                 ) :
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: Text(
//                     "${StatusMap[widget.status]}",
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontFamily: 'Inter',
//                       fontSize: 12
//                     ),
//                   )
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
//                 Container(
//                   height: 40,
//                   width: 70,)
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }