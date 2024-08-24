import 'dart:convert';

class CustomList {
  int? id;
  String? name;
  bool? trash;

  CustomList({
    this.id,
    this.name,
    this.trash,
  });

  CustomList copyWith({
    int? id,
    String? name,
    bool? trash,
  }) =>
      CustomList(
        id: id ?? this.id,
        name: name ?? this.name,
        trash: trash ?? this.trash,
      );

  factory CustomList.fromRawJson(String str) =>
      CustomList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomList.fromJson(Map<String, dynamic> json) => CustomList(
        id: json["id"],
        name: json["name"],
        trash: json["trash"] == 0 ? false : true,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "trash": trash! ? 1 : 0,
      };
}
