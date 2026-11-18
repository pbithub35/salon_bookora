import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/team_member_model.dart';
import '../models/user_model.dart';

class TeamRepository {
  TeamRepository({
    required SharedPreferences preferences,
    required this.storageKey,
  }) : _preferences = preferences {
    final saved = preferences.getString(storageKey);
    if (saved == null) return;
    try {
      _members.addAll(
        (jsonDecode(saved) as List<dynamic>).map(
          (item) => _fromJson(item as Map<String, dynamic>),
        ),
      );
    } on Object {
      _members.clear();
    }
  }

  final SharedPreferences _preferences;
  final String storageKey;
  final List<TeamMember> _members = [];

  List<TeamMember> getAll() => List.unmodifiable(_members);

  void seedOwner(UserModel owner) {
    if (_members.any((member) => member.id == owner.id)) return;
    _members.add(
      TeamMember(
        id: owner.id,
        fullName: owner.fullName,
        mobileNumber: owner.mobileNumber,
        email: owner.email,
        role: TeamRole.owner,
        access: TeamAccess.forRole(TeamRole.owner),
        locationIds: const [],
        serviceIds: const [],
        isBookable: false,
      ),
    );
    _save();
  }

  void save(TeamMember member) {
    final index = _members.indexWhere((item) => item.id == member.id);
    if (index < 0) {
      _members.add(member);
    } else {
      _members[index] = member;
    }
    _save();
  }

  void archive(String id) {
    final index = _members.indexWhere((member) => member.id == id);
    if (index < 0 || _members[index].role == TeamRole.owner) return;
    _members[index] = _members[index].copyWith(
      status: TeamMemberStatus.archived,
      isBookable: false,
    );
    _save();
  }

  void restore(String id) {
    final index = _members.indexWhere((member) => member.id == id);
    if (index < 0) return;
    _members[index] = _members[index].copyWith(status: TeamMemberStatus.active);
    _save();
  }

  bool delete(String id) {
    final index = _members.indexWhere((member) => member.id == id);
    if (index < 0 || _members[index].role == TeamRole.owner) return false;
    _members.removeAt(index);
    _save();
    return true;
  }

  void _save() => unawaited(
    _preferences.setString(
      storageKey,
      jsonEncode(_members.map(_toJson).toList()),
    ),
  );

  static Map<String, dynamic> _toJson(TeamMember member) => {
    'id': member.id,
    'fullName': member.fullName,
    'mobileNumber': member.mobileNumber,
    'email': member.email,
    'role': member.role.name,
    'status': member.status.name,
    'isBookable': member.isBookable,
    'locationIds': member.locationIds,
    'serviceIds': member.serviceIds,
        'weeklyShifts': member.weeklyShifts
            .map(
              (shift) => {
                'shopId': shift.shopId,
                'dayIndex': shift.dayIndex,
                'startTime': shift.startTime,
                'endTime': shift.endTime,
                'isClosed': shift.isClosed,
              },
            )
            .toList(),
    'access': {
      'ownCalendarOnly': member.access.ownCalendarOnly,
      'manageCalendar': member.access.manageCalendar,
      'manageCatalog': member.access.manageCatalog,
      'manageTeam': member.access.manageTeam,
      'manageLocations': member.access.manageLocations,
      'viewReports': member.access.viewReports,
    },
  };

  static TeamMember _fromJson(Map<String, dynamic> json) {
    final access = json['access'] as Map<String, dynamic>? ?? {};
    return TeamMember(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      mobileNumber: json['mobileNumber'] as String,
      email: json['email'] as String?,
      role: TeamRole.values.byName(json['role'] as String),
      status: TeamMemberStatus.values.byName(json['status'] as String),
      isBookable: json['isBookable'] as bool? ?? true,
      locationIds: (json['locationIds'] as List<dynamic>? ?? [])
          .whereType<String>()
          .toList(),
      serviceIds: (json['serviceIds'] as List<dynamic>? ?? [])
          .whereType<String>()
          .toList(),
      weeklyShifts: (json['weeklyShifts'] as List<dynamic>? ?? [])
          .map((item) => item as Map<String, dynamic>)
          .map(
            (shift) => TeamWeeklyShift(
              shopId: shift['shopId'] as String,
              dayIndex: (shift['dayIndex'] as num).toInt(),
              startTime: shift['startTime'] as String,
              endTime: shift['endTime'] as String,
              isClosed: shift['isClosed'] as bool? ?? false,
            ),
          )
          .toList(),
      access: TeamAccess(
        ownCalendarOnly: access['ownCalendarOnly'] as bool? ?? true,
        manageCalendar: access['manageCalendar'] as bool? ?? false,
        manageCatalog: access['manageCatalog'] as bool? ?? false,
        manageTeam: access['manageTeam'] as bool? ?? false,
        manageLocations: access['manageLocations'] as bool? ?? false,
        viewReports: access['viewReports'] as bool? ?? false,
      ),
    );
  }
}
