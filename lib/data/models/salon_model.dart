import 'dart:convert';

enum SalonApprovalStatus { pending, approved, rejected }

enum SalonTrialStatus { notStarted, active, expired }

/// Salon Application & Profile Model
class SalonModel {
  final String id;
  final String ownerId;
  final String salonName;
  final String salonType;
  final String contactNumber;
  final String? email;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String? description;
  final SalonApprovalStatus approvalStatus;
  final String? rejectionReason;
  final DateTime? approvedAt;
  final DateTime? trialStartsAt;
  final DateTime? trialEndsAt;
  final SalonTrialStatus trialStatus;

  const SalonModel({
    required this.id,
    required this.ownerId,
    required this.salonName,
    required this.salonType,
    required this.contactNumber,
    this.email,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.description,
    this.approvalStatus = SalonApprovalStatus.pending,
    this.rejectionReason,
    this.approvedAt,
    this.trialStartsAt,
    this.trialEndsAt,
    this.trialStatus = SalonTrialStatus.notStarted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'salonName': salonName,
      'salonType': salonType,
      'contactNumber': contactNumber,
      'email': email,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'description': description,
      'approvalStatus': approvalStatus.name,
      'rejectionReason': rejectionReason,
      'approvedAt': approvedAt?.toIso8601String(),
      'trialStartsAt': trialStartsAt?.toIso8601String(),
      'trialEndsAt': trialEndsAt?.toIso8601String(),
      'trialStatus': trialStatus.name,
    };
  }

  factory SalonModel.fromMap(Map<String, dynamic> map) {
    SalonApprovalStatus parseStatus(String? val) {
      if (val == 'approved' || val == 'APPROVED') {
        return SalonApprovalStatus.approved;
      }
      if (val == 'rejected' || val == 'REJECTED') {
        return SalonApprovalStatus.rejected;
      }
      return SalonApprovalStatus.pending;
    }

    SalonTrialStatus parseTrial(String? val) {
      if (val == 'active' || val == 'ACTIVE') {
        return SalonTrialStatus.active;
      }
      if (val == 'expired' || val == 'EXPIRED') {
        return SalonTrialStatus.expired;
      }
      return SalonTrialStatus.notStarted;
    }

    return SalonModel(
      id: map['id'] ?? '',
      ownerId: map['ownerId'] ?? '',
      salonName: map['salonName'] ?? '',
      salonType: map['salonType'] ?? 'Unisex Salon',
      contactNumber: map['contactNumber'] ?? '',
      email: map['email'],
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      pincode: map['pincode'] ?? '',
      description: map['description'],
      approvalStatus: parseStatus(map['approvalStatus']),
      rejectionReason: map['rejectionReason'],
      approvedAt: map['approvedAt'] != null
          ? DateTime.tryParse(map['approvedAt'])
          : null,
      trialStartsAt: map['trialStartsAt'] != null
          ? DateTime.tryParse(map['trialStartsAt'])
          : null,
      trialEndsAt: map['trialEndsAt'] != null
          ? DateTime.tryParse(map['trialEndsAt'])
          : null,
      trialStatus: parseTrial(map['trialStatus']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SalonModel.fromJson(String source) =>
      SalonModel.fromMap(json.decode(source));
}
