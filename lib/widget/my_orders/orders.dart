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
        Text("Принят.", style: TextStyle(fontFamily: "Inter", fontSize: 26, fontWeight: FontWeight.w700),),
        Text("Отдаём в работу.", style: TextStyle(fontFamily: "Inter", fontSize: 18, fontWeight: FontWeight.w700),)
      ],
    ),
  ),
  DetailedStatus.putToWork : Center(
    child: Column(
      children: [
        Text("Отдан в работу.", style: TextStyle(fontFamily: "Inter", fontSize: 26, fontWeight: FontWeight.w700),),
        Text("Быстро и только для вас.", style: TextStyle(fontFamily: "Inter", fontSize: 18, fontWeight: FontWeight.w700),)
      ],
    ),
  ),
  DetailedStatus.toCourier : Center(
    child: Column(
      children: [
        Text("Передан курьеру.", style: TextStyle(fontFamily: "Inter", fontSize: 26, fontWeight: FontWeight.w700),),
        Text("Скоро будет у вас.", style: TextStyle(fontFamily: "Inter", fontSize: 18, fontWeight: FontWeight.w700),)
      ],
    ),
  ),
  DetailedStatus.delivered : Center(
    child: Column(
      children: [
        Text("Доставлен.", style: TextStyle(fontFamily: "Inter", fontSize: 26, fontWeight: FontWeight.w700),),
        Text("Приятного аппетита!", style: TextStyle(fontFamily: "Inter", fontSize: 18, fontWeight: FontWeight.w700),)
      ],
    ),
  ),
  DetailedStatus.readyToGet : Center(
    child: Column(
      children: [
        Text("Готов к выдачи.", style: TextStyle(fontFamily: "Inter", fontSize: 26, fontWeight: FontWeight.w700),),
        Text("Скоро будет у вас.", style: TextStyle(fontFamily: "Inter", fontSize: 18, fontWeight: FontWeight.w700),)
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

