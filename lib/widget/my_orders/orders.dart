import 'package:flutter/material.dart';

const String time = "1:30"; // Время, в колторое заказ будет завершен, будет хранить в себе время, когда заказ оказался у пользователя
const DetailedStatus detailedStatus = DetailedStatus.adopted; 

List<String> ListOfOrders = ["Пицца", "хуй с солью", "Говно", "хер моржовый"];

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

Map<DetailedStatus, Widget> DetailedStatusMap =  {
  DetailedStatus.adopted : Text("Принят \nОтдаём в работу.", textAlign: TextAlign.center,),
  DetailedStatus.putToWork : Text("Отдан в работу \nБыстро и только для вас", textAlign: TextAlign.center,),
  DetailedStatus.toCourier : Text("Передан курьеру. \nСкоро будет у вас.", textAlign: TextAlign.center,),
  DetailedStatus.delivered : Text("Доставлен. \nПриятного аппетита!", textAlign: TextAlign.center,),
  DetailedStatus.readyToGet : Text("Готов к выдачи. \nСкоро будет у вас.", textAlign: TextAlign.center,)
};

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