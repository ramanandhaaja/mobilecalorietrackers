import 'package:hive/hive.dart';
import 'food_entry.dart';

class FoodEntryAdapter extends TypeAdapter<FoodEntry> {
  @override
  final typeId = 0; // Unique ID for this adapter

  @override
  FoodEntry read(BinaryReader reader) {
    return FoodEntry(
      id: reader.readString(),
      name: reader.readString(),
      portion: reader.readString(),
      calories: reader.readInt(),
      protein: reader.readInt(),
      carbs: reader.readInt(),
      fat: reader.readInt(),
      mealType: reader.readString(),
      date: DateTime.parse(reader.readString()),
    );
  }

  @override
  void write(BinaryWriter writer, FoodEntry obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.portion);
    writer.writeInt(obj.calories);
    writer.writeInt(obj.protein);
    writer.writeInt(obj.carbs);
    writer.writeInt(obj.fat);
    writer.writeString(obj.mealType);
    writer.writeString(obj.date.toIso8601String());
  }
}
