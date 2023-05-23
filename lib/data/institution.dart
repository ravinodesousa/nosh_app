class Institution {
  Institution({this.id, this.name, this.type, this.is_active});

  String? id;
  String? name;
  String? type;
  bool? is_active;

  factory Institution.fromJson(Map<String, dynamic> json) => Institution(
        id: json["_id"],
        name: json["name"],
        type: json["type"],
        is_active: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "type": type,
        "is_active": is_active,
      };
}
