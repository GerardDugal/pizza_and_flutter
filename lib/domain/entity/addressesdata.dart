import 'package:json_annotation/json_annotation.dart';

part 'addressesdata.g.dart';

@JsonSerializable()
class Data {
  final List<Address> addresses;
  final List<Region> regions;
  final Map<String, List<WorkSchedule>> work_schedules;

  Data({required this.addresses, required this.regions, required this.work_schedules});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Address {
  final int id;
  final double longitude;
  final double latitude;
  final String title;
  final String description;
  final String city_title;
  final String address;
  final String work_hours;
  final String subway;
  final String subway_color;
  final String? phone_number;
  final String? photo;
  final String? panorama;
  final bool allow_event_reservation;
  final List<WorkSchedule> work_schedule;
  final bool subway_available;
  final String about;
  final String about_photos;
  final String link_facebook;
  final String link_twitter;
  final String link_vk;
  final String link_ok;
  final String link_instagram;
  final String link_youtube;
  final String link_tripadvisor;
  final String link_telegram;
  final String route;
  final String route_ru;
  final String route_en;
  final String route_uk;
  final String? delivery_region;
  final String? delivery_region_color;
  final String address_color;
  final int city_id;
  final int field_order;
  final bool deleted;

  Address({
    required this.id,
    required this.longitude,
    required this.latitude,
    required this.title,
    required this.description,
    required this.city_title,
    required this.address,
    required this.work_hours,
    required this.subway,
    required this.subway_color,
    required this.phone_number,
    this.photo,
    this.panorama,
    required this.allow_event_reservation,
    required this.work_schedule,
    required this.subway_available,
    required this.about,
    required this.about_photos,
    required this.link_facebook,
    required this.link_twitter,
    required this.link_vk,
    required this.link_ok,
    required this.link_instagram,
    required this.link_youtube,
    required this.link_tripadvisor,
    required this.link_telegram,
    required this.route,
    required this.route_ru,
    required this.route_en,
    required this.route_uk,
    required this.delivery_region,
    required this.delivery_region_color,
    required this.address_color,
    required this.city_id,
    required this.field_order,
    required this.deleted,
  });

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

@JsonSerializable()
class Region {
  final int id;
  final int address_id;
  final int zone_order;
  final int delivery_price;
  final int minimum_cart;
  final int free_delivery;
  final String color;
  final String vertices;
  final String terms;
  final String price_levels;

  Region({
    required this.id,
    required this.address_id,
    required this.zone_order,
    required this.delivery_price,
    required this.minimum_cart,
    required this.free_delivery,
    required this.color,
    required this.vertices,
    required this.terms,
    required this.price_levels,
  });

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);
  Map<String, dynamic> toJson() => _$RegionToJson(this);
}

@JsonSerializable()
class WorkSchedule {
  final String id;
  final int wday_start;
  final int wday_end;
  final bool is_24h;
  final String time_open;
  final int time_open_hour;
  final int time_open_minute;
  final String time_close;
  final int time_close_hour;
  final int time_close_minute;
  final bool has_break;
  final String break_start;
  final int break_start_hour;
  final int break_start_minute;
  final String break_end;
  final int break_end_hour;
  final int break_end_minute;

  WorkSchedule({
    required this.id,
    required this.wday_start,
    required this.wday_end,
    required this.is_24h,
    required this.time_open,
    required this.time_open_hour,
    required this.time_open_minute,
    required this.time_close,
    required this.time_close_hour,
    required this.time_close_minute,
    required this.has_break,
    required this.break_start,
    required this.break_start_hour,
    required this.break_start_minute,
    required this.break_end,
    required this.break_end_hour,
    required this.break_end_minute,
  });

  factory WorkSchedule.fromJson(Map<String, dynamic> json) => _$WorkScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$WorkScheduleToJson(this);
}
