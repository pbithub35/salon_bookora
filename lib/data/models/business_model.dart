import 'dart:convert';

/// Business account owned by a salon owner.
/// `brandName` is optional — only useful for owners with multiple shops.
class BusinessModel {
  const BusinessModel({
    required this.id,
    required this.ownerId,
    this.brandName,
    this.createdAt,
  });

  final String id;
  final String ownerId;
  final String? brandName;
  final DateTime? createdAt;

  Map<String, dynamic> toMap() => {
    'id': id,
    'ownerId': ownerId,
    'brandName': brandName,
    'createdAt': createdAt?.toIso8601String(),
  };

  factory BusinessModel.fromMap(Map<String, dynamic> map) => BusinessModel(
    id: map['id'] ?? '',
    ownerId: map['ownerId'] ?? '',
    brandName: map['brandName'],
    createdAt: map['createdAt'] != null
        ? DateTime.tryParse(map['createdAt'] as String)
        : null,
  );

  String toJson() => json.encode(toMap());

  factory BusinessModel.fromJson(String source) =>
      BusinessModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
