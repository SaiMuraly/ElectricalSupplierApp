import 'package:hive/hive.dart';
part 'add_date.g.dart';

@HiveType(typeId: 1)
class Add_data extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  // explain;
  //@HiveField(2)
  String amount;
  @HiveField(2)
  String IN;
  @HiveField(3)
  DateTime datetime;
  //Add_data(this.IN, this.amount, this.datetime, this.explain, this.name);
  Add_data(this.name, this.amount, this.IN, this.datetime);
}
