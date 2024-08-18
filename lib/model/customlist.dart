import 'dart:convert';

class CustomList {
  int? id;
  String? name;

  CustomList({
    this.id,
    this.name,
  });

  CustomList copyWith({
    int? id,
    String? name,
  }) =>
      CustomList(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory CustomList.fromRawJson(String str) =>
      CustomList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomList.fromJson(Map<String, dynamic> json) => CustomList(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
