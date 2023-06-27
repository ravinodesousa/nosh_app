import 'package:nosh_app/data/institution.dart';

class CategoryItem {
  CategoryItem({this.id, this.name, this.image, this.is_active});

  String? id;
  String? name;
  String? image;
  bool? is_active;

  factory CategoryItem.fromJson(Map<String, dynamic> json) => CategoryItem(
        id: json["_id"],
        name: json["name"],
        image: json["image"],
        is_active: json["is_active"],
      );
}
