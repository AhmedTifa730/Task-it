import 'package:hive/hive.dart';



class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  int timestamp; // Stored as milliseconds since epoch

  @HiveField(2)
  bool completed;

  // Constructor should accept a DateTime and convert it to milliseconds
  Task(this.title, DateTime date, this.completed) : timestamp = date.millisecondsSinceEpoch;

  // Helper to retrieve date from timestamp
  DateTime get date => DateTime.fromMillisecondsSinceEpoch(timestamp);
}





class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final title = reader.readString();
    final timestamp = reader.readInt();
    final completed = reader.readBool();
    return Task(
      title,
      DateTime.fromMillisecondsSinceEpoch(timestamp),
      completed,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer.writeString(obj.title);
    writer.writeInt(obj.timestamp);
    writer.writeBool(obj.completed);
  }
}
