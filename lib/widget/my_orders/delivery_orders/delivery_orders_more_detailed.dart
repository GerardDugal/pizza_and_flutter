import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/widget/my_orders/orders.dart';

class DeliveryOrdersDetailed extends Orders{

  final int count_positions;
  final DetailedStatus detailedStatus;

  DeliveryOrdersDetailed({
    required int price,
    required int number,
    required String date,
    required Status status,
    required this.count_positions,
    required this.detailedStatus,
  }) : super(price: price, number: number, date: date, status: status);

  @override
  State<DeliveryOrdersDetailed> createState() => _DeliveryOrdersDetailedState();
}

class _DeliveryOrdersDetailedState extends State<DeliveryOrdersDetailed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(
        child: Column(
          children: [
            Text("Заказ №${widget.number} от ${widget.date}", style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: "Inter", fontWeight: FontWeight.w700)),
            Text("${widget.count_positions} позиции на ${widget.price} ₽", style: TextStyle(color: Colors.red, fontSize: 14, fontFamily: "Inter", fontWeight: FontWeight.w600),)
          ],
        ),
      )),
      body: Container(
        child: Center(
          child: DetailedStatusMap[widget.detailedStatus],
        ),
      ),
    );
  }
}

