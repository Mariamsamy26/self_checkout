// To parse this JSON data, do
//
//     final productByBarcode = productByBarcodeFromJson(jsonString);

import 'dart:convert';

ProductByBarcode productByBarcodeFromJson(String str) => ProductByBarcode.fromJson(json.decode(str));

String productByBarcodeToJson(ProductByBarcode data) => json.encode(data.toJson());

class ProductByBarcode {
  int? status;
  List<Datum>? data;

  ProductByBarcode({this.status, this.data});

  factory ProductByBarcode.fromJson(Map<String, dynamic> json) => ProductByBarcode(
    status: json["status"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? name;
  String? nameAr;
  String? defaultCode;
  String? barcode;
  double? listPrice;
  String? description;
  String? descriptionAr;
  bool? active;
  bool? isPublished;
  bool? isArchived;
  bool? isVariant;
  bool? small;
  double? smallPrice;
  bool? medium;
  double? mediumPrice;
  bool? large;
  double? largePrice;
  double? calories;
  String? image;
  double? virtualAvailable;
  double? qtyAvailable;
  List<dynamic>? taxesId;
  int selectedQty = 1;

  Datum({
    this.id,
    this.name,
    this.nameAr,
    this.defaultCode,
    this.barcode,
    this.listPrice,
    this.description,
    this.descriptionAr,
    this.active,
    this.isPublished,
    this.isArchived,
    this.isVariant,
    this.small,
    this.smallPrice,
    this.medium,
    this.mediumPrice,
    this.large,
    this.largePrice,
    this.calories,
    this.image,
    this.virtualAvailable,
    this.qtyAvailable,
    this.taxesId,
    this.selectedQty = 1,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    nameAr: json["name_ar"],
    defaultCode: json["default_code"],
    barcode: json["barcode"],
    listPrice: json["list_price"]?.toDouble(),
    description: json["description"],
    descriptionAr: json["description_ar"],
    active: json["active"],
    isPublished: json["is_published"],
    isArchived: json["is_archived"],
    isVariant: json["is_variant"],
    small: json["small"],
    smallPrice: json["small_price"]?.toDouble(),
    medium: json["medium"],
    mediumPrice: json["medium_price"]?.toDouble(),
    large: json["large"],
    largePrice: json["large_price"]?.toDouble(),
    calories: json["calories"],
    image: json["image"],
    virtualAvailable: json["virtual_available"],
    qtyAvailable: json["qty_available"],
    taxesId: json["taxes_id"] == null ? [] : List<dynamic>.from(json["taxes_id"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "name_ar": nameAr,
    "default_code": defaultCode,
    "barcode": barcode,
    "list_price": listPrice,
    "description": description,
    "description_ar": descriptionAr,
    "active": active,
    "is_published": isPublished,
    "is_archived": isArchived,
    "is_variant": isVariant,
    "small": small,
    "small_price": smallPrice,
    "medium": medium,
    "medium_price": mediumPrice,
    "large": large,
    "large_price": largePrice,
    "calories": calories,
    "image": image,
    "virtual_available": virtualAvailable,
    "qty_available": qtyAvailable,
    "taxes_id": taxesId == null ? [] : List<dynamic>.from(taxesId!.map((x) => x)),
  };
}
