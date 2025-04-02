// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodEntryAdapter extends TypeAdapter<FoodEntry> {
  @override
  final int typeId = 0;

  @override
  FoodEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodEntry(
      id: fields[0] as String,
      name: fields[1] as String,
      portion: fields[2] as String,
      calories: fields[3] as int,
      protein: fields[4] as int,
      carbs: fields[5] as int,
      fat: fields[6] as int,
      mealType: fields[7] as String,
      date: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FoodEntry obj) {
    writer.writeByte(9);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.name);
    writer.writeByte(2);
    writer.write(obj.portion);
    writer.writeByte(3);
    writer.write(obj.calories);
    writer.writeByte(4);
    writer.write(obj.protein);
    writer.writeByte(5);
    writer.write(obj.carbs);
    writer.writeByte(6);
    writer.write(obj.fat);
    writer.writeByte(7);
    writer.write(obj.mealType);
    writer.writeByte(8);
    writer.write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
