import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:pizza_and_flutter/widget/my_orders/delivery_orders/delivery_orders_more_detailed.dart';
import 'package:pizza_and_flutter/widget/my_orders/orders.dart';


class Deliv extends Orders{
  
  Deliv({
    required double price,
    required int number,
    required String date,
    required Status status,
    required int count_positions,
    required DetailedStatus detailedStatus,
    required List<CartItem> dishList
  }) : super(price: price, number: number, date: date, status: status, count_positions: count_positions, detailedStatus: detailedStatus, dishList: dishList);

  @override
  State<Deliv> createState() => _DelivState();
  
}

class _DelivState extends State<Deliv> {

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
      ),
      onTap: () {
            print("Tap");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _DeliveryOrdersDetailed()),
            );
        },
    );
  }

  Widget _DeliveryOrdersDetailed(){
    return Scaffold(
      appBar: AppBar(title: Center(
        child: Column(
          children: [
            Text("Заказ №${widget.number} от ${widget.date}", style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: "Inter", fontWeight: FontWeight.w700)),
            Text("${widget.count_positions} позиции на ${widget.price} ₽", style: TextStyle(color: Colors.red, fontSize: 14, fontFamily: "Inter", fontWeight: FontWeight.w600),)
          ],
        ),
      )),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 50),
            color: const Color.fromARGB(255, 241, 241, 241),
            child: Center(
              child: Column(
                children: [
                  OrderStatusWidget(currentStatus: widget.detailedStatus,),
                  Container(child: DetailedStatusMap[widget.detailedStatus])
                ],
              ),
            ),
          ),
          Container(color: Colors.green,)
        ],
      ),
    );
  }
}

class OrderStatusWidget extends StatelessWidget {
  final DetailedStatus currentStatus;

  const OrderStatusWidget({Key? key, required this.currentStatus}) : super(key: key);

  Color _getStatusColor(DetailedStatus status) {
    return currentStatus == status ? Colors.red : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStatusIcon(
            icon: Icons.check,
            status: DetailedStatus.adopted,
          ),
          Container(padding: EdgeInsets.fromLTRB(12, 0, 12, 6), child: Icon(Icons.arrow_forward, size: 16, color: Colors.grey[600],)),
          _buildStatusIcon(
            icon: Icons.access_time,
            status: DetailedStatus.putToWork,
          ),
          Container(padding: EdgeInsets.fromLTRB(12, 0, 12, 6), child: Icon(Icons.arrow_forward, size: 16, color: Colors.grey[600],)),
          _buildStatusIcon(
            icon: Icons.person,
            status: DetailedStatus.toCourier,
          ),
          Container(padding: EdgeInsets.fromLTRB(12, 0, 12, 6), child: Icon(Icons.arrow_forward, size: 16, color: Colors.grey[600],)),
          _buildStatusIcon(
            icon: Icons.emoji_emotions,
            status: DetailedStatus.delivered,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon({required IconData icon, required DetailedStatus status}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: _getStatusColor(status),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}