// Additional Hive Model Adapter (you need to generate this with build_runner)
import 'package:hive/hive.dart';

import 'activity_hive_model.dart';

class DailyActivityModelAdapter extends TypeAdapter<DailyActivityModel> {
  @override
  final int typeId = 0;

  @override
  DailyActivityModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyActivityModel(
      businessType: fields[0] as String,
      customer: fields[1] as String,
      callType: fields[2] as String,
      activityType: fields[3] as String,
      productCategory: fields[4] as String,
      reason: fields[5] as String,
      medium: fields[6] as String,
      vehicle: fields[7] as String,
      edition: fields[8] as String,
      position: fields[9] as String,
      size: fields[10] as String,
      location: fields[11] as String,
      createdDate: fields[12] as DateTime,
      media:
          (fields[13] as String?) ?? '', // Provide default empty string if null
      cost:
          (fields[14] as String?) ?? '', // Provide default empty string if null
    );
  }

  @override
  void write(BinaryWriter writer, DailyActivityModel obj) {
    writer
      ..writeByte(15) // Update to 15 fields to include media and cost
      ..writeByte(0)
      ..write(obj.businessType)
      ..writeByte(1)
      ..write(obj.customer)
      ..writeByte(2)
      ..write(obj.callType)
      ..writeByte(3)
      ..write(obj.activityType)
      ..writeByte(4)
      ..write(obj.productCategory)
      ..writeByte(5)
      ..write(obj.reason)
      ..writeByte(6)
      ..write(obj.medium)
      ..writeByte(7)
      ..write(obj.vehicle)
      ..writeByte(8)
      ..write(obj.edition)
      ..writeByte(9)
      ..write(obj.position)
      ..writeByte(10)
      ..write(obj.size)
      ..writeByte(11)
      ..write(obj.location)
      ..writeByte(12)
      ..write(obj.createdDate)
      ..writeByte(13)
      ..write(obj.media)
      ..writeByte(14)
      ..write(obj.cost);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyActivityModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}
