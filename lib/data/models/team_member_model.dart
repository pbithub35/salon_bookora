enum TeamRole { owner, administrator, manager, receptionist, serviceProvider }

enum TeamMemberStatus { active, archived }

class TeamWeeklyShift {
  const TeamWeeklyShift({
    required this.shopId,
    required this.dayIndex,
    required this.startTime,
    required this.endTime,
    this.isClosed = false,
  });

  final String shopId;
  final int dayIndex;
  final String startTime;
  final String endTime;
  final bool isClosed;

  TeamWeeklyShift copyWith({
    String? startTime,
    String? endTime,
    bool? isClosed,
  }) =>
      TeamWeeklyShift(
        shopId: shopId,
        dayIndex: dayIndex,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        isClosed: isClosed ?? this.isClosed,
      );
}

class TeamAccess {
  const TeamAccess({
    this.ownCalendarOnly = true,
    this.manageCalendar = false,
    this.manageCatalog = false,
    this.manageTeam = false,
    this.manageLocations = false,
    this.viewReports = false,
  });

  final bool ownCalendarOnly;
  final bool manageCalendar;
  final bool manageCatalog;
  final bool manageTeam;
  final bool manageLocations;
  final bool viewReports;

  factory TeamAccess.forRole(TeamRole role) => switch (role) {
    TeamRole.owner => const TeamAccess(
      ownCalendarOnly: false,
      manageCalendar: true,
      manageCatalog: true,
      manageTeam: true,
      manageLocations: true,
      viewReports: true,
    ),
    TeamRole.administrator => const TeamAccess(
      ownCalendarOnly: false,
      manageCalendar: true,
      manageCatalog: true,
      manageTeam: true,
      manageLocations: true,
      viewReports: true,
    ),
    TeamRole.manager => const TeamAccess(
      ownCalendarOnly: false,
      manageCalendar: true,
      manageCatalog: true,
      manageTeam: false,
      manageLocations: false,
      viewReports: true,
    ),
    TeamRole.receptionist => const TeamAccess(
      ownCalendarOnly: false,
      manageCalendar: true,
    ),
    TeamRole.serviceProvider => const TeamAccess(),
  };

  TeamAccess copyWith({
    bool? ownCalendarOnly,
    bool? manageCalendar,
    bool? manageCatalog,
    bool? manageTeam,
    bool? manageLocations,
    bool? viewReports,
  }) => TeamAccess(
    ownCalendarOnly: ownCalendarOnly ?? this.ownCalendarOnly,
    manageCalendar: manageCalendar ?? this.manageCalendar,
    manageCatalog: manageCatalog ?? this.manageCatalog,
    manageTeam: manageTeam ?? this.manageTeam,
    manageLocations: manageLocations ?? this.manageLocations,
    viewReports: viewReports ?? this.viewReports,
  );
}

class TeamMember {
  const TeamMember({
    required this.id,
    required this.fullName,
    required this.mobileNumber,
    required this.role,
    required this.access,
    required this.locationIds,
    required this.serviceIds,
    this.weeklyShifts = const [],
    this.email,
    this.isBookable = true,
    this.status = TeamMemberStatus.active,
  });

  final String id;
  final String fullName;
  final String mobileNumber;
  final String? email;
  final TeamRole role;
  final TeamAccess access;
  final List<String> locationIds;
  final List<String> serviceIds;
  final List<TeamWeeklyShift> weeklyShifts;
  final bool isBookable;
  final TeamMemberStatus status;

  TeamMember copyWith({
    String? fullName,
    String? mobileNumber,
    String? email,
    TeamRole? role,
    TeamAccess? access,
    List<String>? locationIds,
    List<String>? serviceIds,
    List<TeamWeeklyShift>? weeklyShifts,
    bool? isBookable,
    TeamMemberStatus? status,
  }) => TeamMember(
    id: id,
    fullName: fullName ?? this.fullName,
    mobileNumber: mobileNumber ?? this.mobileNumber,
    email: email ?? this.email,
    role: role ?? this.role,
    access: access ?? this.access,
    locationIds: locationIds ?? this.locationIds,
    serviceIds: serviceIds ?? this.serviceIds,
        weeklyShifts: weeklyShifts ?? this.weeklyShifts,
    isBookable: isBookable ?? this.isBookable,
    status: status ?? this.status,
  );
}
