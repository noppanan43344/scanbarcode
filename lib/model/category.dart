// To parse this JSON data, do
//
//     final categoryList = categoryListFromJson(jsonString);

import 'dart:convert';

List<CategoryList> categoryListFromJson(String str) => List<CategoryList>.from(json.decode(str).map((x) => CategoryList.fromJson(x)));

String categoryListToJson(List<CategoryList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryList {
    CategoryList({
        this.categoryId,
        this.categoryName,
    });

    int categoryId;
    String categoryName;

    factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
    );

    Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "categoryName": categoryName,
    };
}
