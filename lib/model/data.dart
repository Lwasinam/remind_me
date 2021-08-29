import 'package:remind_me/Imports/imports.dart';

part 'data.g.dart';

@HiveType(typeId: 0)
class UserData {
  @HiveField(0)
  String taskName;
  @HiveField(1)
  bool pending;
  @HiveField(2)
  DateTime time;

  UserData(this.time, this.pending, this.taskName);
}
