
import 'package:hive/hive.dart';

part 'contect_data.g.dart';

@HiveType(typeId: 0)
class Contect_Data extends HiveObject{
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? contect;
  @HiveField(2)
  String ?gender;
  @HiveField(3)
  var cropImage;

  Contect_Data(this.name, this.contect, this.gender, this.cropImage);
}