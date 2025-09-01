import 'package:hive/hive.dart';

// Hive Model for Daily Activity
@HiveType(typeId: 0)
class DailyActivityModel extends HiveObject {
  // Add these fields to your model
  List<String>? locationHistory; // Store all locations for the day
  DateTime? lastLocationUpdate;
  String? routeData; // Store encoded polyline or route points
  @HiveField(0)
  String businessType;

  @HiveField(1)
  String customer;

  @HiveField(2)
  String callType;

  @HiveField(3)
  String activityType;

  @HiveField(4)
  String productCategory;

  @HiveField(5)
  String reason;

  @HiveField(6)
  String medium;

  @HiveField(7)
  String vehicle;

  @HiveField(8)
  String edition;

  @HiveField(9)
  String position;

  @HiveField(10)
  String size;

  @HiveField(11)
  String location;

  @HiveField(12)
  DateTime createdDate;

  @HiveField(13)
  String media;

  @HiveField(14)
  String cost;

  DailyActivityModel({
    required this.businessType,
    required this.customer,
    required this.callType,
    required this.activityType,
    required this.productCategory,
    required this.reason,
    required this.medium,
    required this.vehicle,
    required this.edition,
    required this.position,
    required this.size,
    required this.location,
    required this.createdDate,
    required this.media,
    required this.cost,
  });
}

@HiveType(typeId: 0)
class LocationModel extends HiveObject {
  @HiveField(0)
  double latitude;

  @HiveField(1)
  double longitude;

  @HiveField(2)
  DateTime timestamp;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });
}
