import 'package:equatable/equatable.dart';

class MedicineModel extends Equatable {
  final int? id;
  final String name;
  final String? genericName;
  final String code;
  final String? description;
  final String manufacturer;
  final String? unitOfMeasure;
  final double price;
  final int quantityInStock;
  final int? minimumStock;
  final String? batchNumber;
  final DateTime? expiryDate;
  final String? category;
  final String? storageCondition;
  final bool prescriptionRequired;
  final bool isActive;
  final String? imageUrl;

  const MedicineModel({
    this.id,
    required this.name,
    this.genericName,
    required this.code,
    this.description,
    required this.manufacturer,
    this.unitOfMeasure,
    required this.price,
    required this.quantityInStock,
    this.minimumStock,
    this.batchNumber,
    this.expiryDate,
    this.category,
    this.storageCondition,
    this.prescriptionRequired = false,
    this.isActive = true,
    this.imageUrl,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'],
      name: json['name'],
      genericName: json['genericName'],
      code: json['code'],
      description: json['description'],
      manufacturer: json['manufacturer'],
      unitOfMeasure: json['unitOfMeasure'],
      price: (json['price'] as num).toDouble(),
      quantityInStock: json['quantityInStock'],
      minimumStock: json['minimumStock'],
      batchNumber: json['batchNumber'],
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : null,
      category: json['category'],
      storageCondition: json['storageCondition'],
      prescriptionRequired: json['prescriptionRequired'] ?? false,
      isActive: json['isActive'] ?? true,
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'genericName': genericName,
      'code': code,
      'description': description,
      'manufacturer': manufacturer,
      'unitOfMeasure': unitOfMeasure,
      'price': price,
      'quantityInStock': quantityInStock,
      'minimumStock': minimumStock,
      'batchNumber': batchNumber,
      'expiryDate': expiryDate?.toIso8601String(),
      'category': category,
      'storageCondition': storageCondition,
      'prescriptionRequired': prescriptionRequired,
      'isActive': isActive,
      'imageUrl': imageUrl,
    };
  }

  MedicineModel copyWith({
    int? id,
    String? name,
    String? genericName,
    String? code,
    String? description,
    String? manufacturer,
    String? unitOfMeasure,
    double? price,
    int? quantityInStock,
    int? minimumStock,
    String? batchNumber,
    DateTime? expiryDate,
    String? category,
    String? storageCondition,
    bool? prescriptionRequired,
    bool? isActive,
    String? imageUrl,
  }) {
    return MedicineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      genericName: genericName ?? this.genericName,
      code: code ?? this.code,
      description: description ?? this.description,
      manufacturer: manufacturer ?? this.manufacturer,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      price: price ?? this.price,
      quantityInStock: quantityInStock ?? this.quantityInStock,
      minimumStock: minimumStock ?? this.minimumStock,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      category: category ?? this.category,
      storageCondition: storageCondition ?? this.storageCondition,
      prescriptionRequired: prescriptionRequired ?? this.prescriptionRequired,
      isActive: isActive ?? this.isActive,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        genericName,
        code,
        description,
        manufacturer,
        unitOfMeasure,
        price,
        quantityInStock,
        minimumStock,
        batchNumber,
        expiryDate,
        category,
        storageCondition,
        prescriptionRequired,
        isActive,
        imageUrl,
      ];
}