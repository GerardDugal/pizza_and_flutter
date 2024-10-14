import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';

const String time = "1:30"; // Время, в колторое заказ будет завершен, будет хранить в себе время, когда заказ оказался у пользователя
const DetailedStatus detailedStatus = DetailedStatus.adopted; 


enum Status {
  taketo,
  inprogress,
  uncompleted,
  completed
}

enum DetailedStatus {
  adopted,
  putToWork,
  toCourier,
  delivered,
  readyToGet
}


Map<DetailedStatus, Widget> DetailedStatusMap = {
  DetailedStatus.adopted : Center(
    child: Column(
      children: [
        Text("Принят"),
        Text("Отдаём в работу.")
      ],
    ),
  ),
  DetailedStatus.putToWork : Center(
    child: Column(
      children: [
        Text("Отдан в работу"),
        Text("Быстро и только для вас.")
      ],
    ),
  ),
  DetailedStatus.toCourier : Center(
    child: Column(
      children: [
        Text("Передан курьеру."),
        Text("Скоро будет у вас.")
      ],
    ),
  ),
  DetailedStatus.delivered : Center(
    child: Column(
      children: [
        Text("Доставлен."),
        Text("Приятного аппетита!")
      ],
    ),
  ),
  DetailedStatus.readyToGet : Center(
    child: Column(
      children: [
        Text("Готов к выдачи."),
        Text("Скоро будет у вас.")
      ],
    ),
  ),
};

Map<Status, String> StatusMap =  {
  Status.taketo : "ЗАБРАТЬ К ",
  Status.inprogress : "В РАБОТЕ",
  Status.completed : "ВЫПОЛНЕН В $time",
  Status.uncompleted : "НЕ ВЫПОЛНЕН"
};

abstract class Orders extends StatefulWidget {
  final double price;
  final int number;
  final String date;
  final Status status;
  final int count_positions;
  final DetailedStatus detailedStatus;
  final List<CartItem> dishList;

  Orders({ 
    required this.price,
    required this.number,
    required this.date,
    required this.status,
    required this.count_positions,
    required this.detailedStatus,
    required this.dishList,
  });

}