import 'package:hive/hive.dart';

// Hive Model for Daily Activity
@HiveType(typeId: 0)
class DailyActivityModel extends HiveObject {
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
  });
}
