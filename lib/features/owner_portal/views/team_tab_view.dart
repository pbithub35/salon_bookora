import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text.dart';
import '../../../common/widgets/app_text_field.dart';
import '../../../common/widgets/phone_number_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_sizes.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/shop_model.dart';
import '../../../data/models/team_member_model.dart';
import '../viewmodels/shops_viewmodel.dart';
import '../viewmodels/team_viewmodel.dart';

class TeamTabView extends ConsumerStatefulWidget {
  const TeamTabView({super.key});

  @override
  ConsumerState<TeamTabView> createState() => _TeamTabViewState();
}

class _TeamTabViewState extends ConsumerState<TeamTabView> {
  bool _showArchived = false;

  @override
  Widget build(BuildContext context) {
    final team = ref.watch(teamProvider);
    final active = team
        .where((member) => member.status == TeamMemberStatus.active)
        .toList();
    final archived = team
        .where((member) => member.status == TeamMemberStatus.archived)
        .toList();
    final members = _showArchived ? archived : active;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        onPressed: () => _openMemberEditor(context),
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Add team member'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.title('Team'),
                AppSpacing.v4,
                Text(
                  'Manage people, access, locations and booking eligibility.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppTextSizes.bodySmall,
                  ),
                ),
                AppSpacing.v16,
                Row(
                  children: [
                    _CountCard(
                      label: 'Active',
                      value: active.length,
                      color: AppColors.success,
                    ),
                    AppSpacing.h10,
                    _CountCard(
                      label: 'Bookable',
                      value: active.where((m) => m.isBookable).length,
                      color: AppColors.primaryPurple,
                    ),
                    AppSpacing.h10,
                    _CountCard(
                      label: 'Archived',
                      value: archived.length,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
                AppSpacing.v16,
                Wrap(
                  spacing: 8.w,
                  children: [
                    ChoiceChip(
                      label: const Text('Active team'),
                      selected: !_showArchived,
                      onSelected: (_) => setState(() => _showArchived = false),
                    ),
                    ChoiceChip(
                      label: const Text('Archived'),
                      selected: _showArchived,
                      onSelected: (_) => setState(() => _showArchived = true),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: members.isEmpty
                ? _EmptyTeam(archived: _showArchived)
                : ListView.separated(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 100.h),
                    itemCount: members.length,
                    separatorBuilder: (_, _) => AppSpacing.v10,
                    itemBuilder: (context, index) => _TeamMemberCard(
                      member: members[index],
                      onEdit: () =>
                          _openMemberEditor(context, member: members[index]),
                      onArchive: () => _confirmArchive(context, members[index]),
                      onRestore: () => ref
                          .read(teamProvider.notifier)
                          .restore(members[index].id),
                      onDelete: () => _confirmDelete(context, members[index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _openMemberEditor(
    BuildContext context, {
    TeamMember? member,
  }) async {
    final shops = ref.read(shopsProvider);
    final saved = await showModalBottomSheet<TeamMember>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      builder: (_) => _TeamMemberSheet(member: member, shops: shops),
    );
    if (saved == null || !mounted) return;
    final succeeded = ref.read(teamProvider.notifier).save(saved);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          succeeded
              ? 'Team member saved'
              : 'This phone number is already used by a team member',
        ),
      ),
    );
  }

  Future<void> _confirmArchive(BuildContext context, TeamMember member) async {
    final archive = await _confirm(
      context,
      title: 'Archive ${member.fullName}?',
      message:
          'They will lose booking eligibility and workspace access. Their record remains available for reporting.',
      action: 'Archive',
    );
    if (archive == true && mounted) {
      ref.read(teamProvider.notifier).archive(member.id);
    }
  }

  Future<void> _confirmDelete(BuildContext context, TeamMember member) async {
    final delete = await _confirm(
      context,
      title: 'Delete ${member.fullName}?',
      message:
          'Delete archived profiles only when their history is no longer needed.',
      action: 'Delete',
    );
    if (delete == true && mounted) {
      ref.read(teamProvider.notifier).delete(member.id);
    }
  }

  Future<bool?> _confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String action,
  }) => showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(action),
        ),
      ],
    ),
  );
}

class _CountCard extends StatelessWidget {
  const _CountCard({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radius12,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$value',
            style: TextStyle(
              fontSize: AppTextSizes.title,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: AppTextSizes.caption,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ),
  );
}

class _EmptyTeam extends StatelessWidget {
  const _EmptyTeam({required this.archived});
  final bool archived;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(32.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            archived ? Icons.inventory_2_outlined : Icons.groups_outlined,
            size: 54.r,
            color: AppColors.textMuted,
          ),
          AppSpacing.v12,
          AppText.title(
            archived ? 'No archived team members' : 'Build your team',
          ),
          AppSpacing.v6,
          Text(
            archived
                ? 'Archived profiles stay here for reference.'
                : 'Add staff, managers, and receptionists once, then assign them to shops.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    ),
  );
}

class _TeamMemberCard extends StatelessWidget {
  const _TeamMemberCard({
    required this.member,
    required this.onEdit,
    required this.onArchive,
    required this.onRestore,
    required this.onDelete,
  });
  final TeamMember member;
  final VoidCallback onEdit;
  final VoidCallback onArchive;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  String _roleName() => switch (member.role) {
    TeamRole.owner => 'Owner',
    TeamRole.administrator => 'Sub-admin',
    TeamRole.manager => 'Manager',
    TeamRole.receptionist => 'Receptionist',
    TeamRole.serviceProvider => 'Service provider',
  };

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(14.r),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: AppRadius.radius16,
      border: Border.all(color: AppColors.border),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.surfaceSubtle,
          child: Text(
            member.fullName.isEmpty ? '?' : member.fullName[0].toUpperCase(),
          ),
        ),
        AppSpacing.h12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.fullName,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: AppTextSizes.body,
                ),
              ),
              AppSpacing.v2,
              Text(
                '${_roleName()} · ${member.mobileNumber}',
                style: TextStyle(
                  fontSize: AppTextSizes.caption,
                  color: AppColors.textSecondary,
                ),
              ),
              AppSpacing.v6,
              Wrap(
                spacing: 6.w,
                runSpacing: 4.h,
                children: [
                  _Tag(
                    member.status == TeamMemberStatus.active
                        ? 'Active'
                        : 'Archived',
                    member.status == TeamMemberStatus.active
                        ? AppColors.success
                        : AppColors.textMuted,
                  ),
                  if (member.isBookable)
                    _Tag('Bookable', AppColors.primaryPurple),
                  _Tag(
                    '${member.locationIds.length} shop${member.locationIds.length == 1 ? '' : 's'}',
                    AppColors.info,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (member.role != TeamRole.owner)
          PopupMenuButton<String>(
            onSelected: (action) => switch (action) {
              'edit' => onEdit(),
              'archive' => onArchive(),
              'restore' => onRestore(),
              'delete' => onDelete(),
              _ => null,
            },
            itemBuilder: (_) => [
              if (member.status == TeamMemberStatus.active) ...[
                const PopupMenuItem(value: 'edit', child: Text('Edit profile')),
                const PopupMenuItem(value: 'archive', child: Text('Archive')),
              ] else ...[
                const PopupMenuItem(value: 'restore', child: Text('Restore')),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete permanently'),
                ),
              ],
            ],
          ),
      ],
    ),
  );
}

class _Tag extends StatelessWidget {
  const _Tag(this.label, this.color);
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .10),
      borderRadius: AppRadius.radius20,
    ),
    child: Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: AppTextSizes.tiny,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _TeamMemberSheet extends StatefulWidget {
  const _TeamMemberSheet({this.member, required this.shops});
  final TeamMember? member;
  final List<ShopModel> shops;
  @override
  State<_TeamMemberSheet> createState() => _TeamMemberSheetState();
}

class _TeamMemberSheetState extends State<_TeamMemberSheet> {
  final _key = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  TeamRole _role = TeamRole.serviceProvider;
  late Set<String> _locationIds;
  late Set<String> _serviceIds;
  late Map<String, TeamWeeklyShift> _shiftsByKey;
  bool _isBookable = true;

  @override
  void initState() {
    super.initState();
    final member = widget.member;
    _name.text = member?.fullName ?? '';
    _phone.text = member?.mobileNumber ?? '';
    _email.text = member?.email ?? '';
    _role = member?.role ?? TeamRole.serviceProvider;
    _locationIds = member?.locationIds.toSet() ?? <String>{};
    _serviceIds = member?.serviceIds.toSet() ?? <String>{};
    _shiftsByKey = {
      for (final shift in member?.weeklyShifts ?? const <TeamWeeklyShift>[])
        _shiftKey(shift.shopId, shift.dayIndex): shift,
    };
    for (final shop in widget.shops.where(
      (shop) => _locationIds.contains(shop.id),
    )) {
      _addDefaultShifts(shop);
    }
    _isBookable = member?.isBookable ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  List<ShopServiceItem> get _availableServices => widget.shops
      .where((shop) => _locationIds.contains(shop.id))
      .expand((shop) => shop.services)
      .toList();

  String _shiftKey(String shopId, int dayIndex) => '$shopId:$dayIndex';

  void _addDefaultShifts(ShopModel shop) {
    for (final hours in shop.hours) {
      final key = _shiftKey(shop.id, hours.dayIndex);
      _shiftsByKey.putIfAbsent(
        key,
        () => TeamWeeklyShift(
          shopId: shop.id,
          dayIndex: hours.dayIndex,
          startTime: hours.open,
          endTime: hours.close,
          isClosed: hours.isClosed,
        ),
      );
    }
  }

  String _dayLabel(int dayIndex) =>
      const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][dayIndex - 1];

  int _minutes(String value) {
    final parts = value.split(':');
    return (int.tryParse(parts.first) ?? 0) * 60 +
        (parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0);
  }

  Future<void> _pickTime(TeamWeeklyShift shift, {required bool isStart}) async {
    final value = isStart ? shift.startTime : shift.endTime;
    final parts = value.split(':');
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.tryParse(parts.first) ?? 10,
        minute: parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0,
      ),
    );
    if (picked == null || !mounted) return;
    setState(
      () => _shiftsByKey[_shiftKey(shift.shopId, shift.dayIndex)] = shift.copyWith(
        startTime: isStart
            ? '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}'
            : null,
        endTime: isStart
            ? null
            : '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h + bottom),
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppText.title(
                  widget.member == null
                      ? 'Add team member'
                      : 'Edit team member',
                ),
                AppSpacing.v4,
                Text(
                  'A profile can work across multiple shops.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                AppSpacing.v16,
                AppTextField(
                  label: 'Full name',
                  controller: _name,
                  validator: (value) =>
                      Validators.validateFullName(context.l10n, value),
                ),
                AppSpacing.v12,
                PhoneNumberField(
                  controller: _phone,
                  validator: (value) =>
                      Validators.validateMobile(context.l10n, value),
                ),
                AppSpacing.v12,
                AppTextField(
                  label: 'Email (optional)',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      Validators.validateEmail(context.l10n, value),
                ),
                AppSpacing.v16,
                Text(
                  'Workspace role',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: AppTextSizes.bodySmall,
                  ),
                ),
                AppSpacing.v8,
                DropdownButtonFormField<TeamRole>(
                  key: ValueKey(_role),
                  initialValue: _role,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.radius12,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: TeamRole.administrator,
                      child: Text('Sub-admin — full operational access'),
                    ),
                    DropdownMenuItem(
                      value: TeamRole.manager,
                      child: Text('Manager — calendars, services and reports'),
                    ),
                    DropdownMenuItem(
                      value: TeamRole.receptionist,
                      child: Text('Receptionist — calendars and bookings'),
                    ),
                    DropdownMenuItem(
                      value: TeamRole.serviceProvider,
                      child: Text('Service provider — own calendar only'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _role = value);
                  },
                ),
                AppSpacing.v16,
                Text(
                  'Assigned shops',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: AppTextSizes.bodySmall,
                  ),
                ),
                if (widget.shops.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      'Create a shop before assigning this team member.',
                      style: TextStyle(color: AppColors.warning),
                    ),
                  ),
                ...widget.shops.map(
                  (shop) => CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(shop.salonName),
                    subtitle: Text(shop.city),
                    value: _locationIds.contains(shop.id),
                    onChanged: (selected) => setState(() {
                      if (selected ?? false) {
                        _locationIds.add(shop.id);
                        _addDefaultShifts(shop);
                      } else {
                        _locationIds.remove(shop.id);
                        _serviceIds.removeAll(
                          shop.services.map((service) => service.id),
                        );
                        _shiftsByKey.removeWhere(
                          (key, _) => key.startsWith('${shop.id}:'),
                        );
                      }
                    }),
                  ),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Available for bookings'),
                  subtitle: const Text(
                    'Customers can choose this person when booking a service.',
                  ),
                  value: _isBookable,
                  onChanged: _role == TeamRole.serviceProvider
                      ? (value) => setState(() => _isBookable = value)
                      : null,
                ),
                if (_role == TeamRole.serviceProvider && _isBookable) ...[
                  AppSpacing.v8,
                  Text(
                    'Services they can perform',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: AppTextSizes.bodySmall,
                    ),
                  ),
                  if (_availableServices.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        'Select a shop with services first.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ..._availableServices.map(
                    (service) => CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(service.name),
                      subtitle: Text(
                        '${service.durationMinutes} min · ₹${service.price.toStringAsFixed(0)}',
                      ),
                      value: _serviceIds.contains(service.id),
                      onChanged: (selected) => setState(
                        () => (selected ?? false)
                            ? _serviceIds.add(service.id)
                            : _serviceIds.remove(service.id),
                      ),
                    ),
                  ),
                  AppSpacing.v12,
                  Text(
                    'Weekly availability',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: AppTextSizes.bodySmall,
                    ),
                  ),
                  AppSpacing.v4,
                  Text(
                    'Starts with each shop’s hours. Adjust this person’s working hours before they go live.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: AppTextSizes.caption,
                    ),
                  ),
                  ...widget.shops
                      .where((shop) => _locationIds.contains(shop.id))
                      .map(
                        (shop) => ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          title: Text(shop.salonName),
                          children: shop.hours.map((hours) {
                            final shift =
                                _shiftsByKey[_shiftKey(
                                  shop.id,
                                  hours.dayIndex,
                                )]!;
                            return Column(
                              children: [
                                SwitchListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(_dayLabel(hours.dayIndex)),
                                  subtitle: shift.isClosed
                                      ? const Text('Not working')
                                      : Text(
                                          '${shift.startTime} – ${shift.endTime}',
                                        ),
                                  value: !shift.isClosed,
                                  onChanged: (working) => setState(
                                    () =>
                                        _shiftsByKey[_shiftKey(
                                          shop.id,
                                          hours.dayIndex,
                                        )] = shift.copyWith(
                                          isClosed: !working,
                                        ),
                                  ),
                                ),
                                if (!shift.isClosed)
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8.h),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () =>
                                                _pickTime(shift, isStart: true),
                                            child: Text(
                                              'Start ${shift.startTime}',
                                            ),
                                          ),
                                        ),
                                        AppSpacing.h8,
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () => _pickTime(
                                              shift,
                                              isStart: false,
                                            ),
                                            child: Text('End ${shift.endTime}'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                ],
                AppSpacing.v16,
                _AccessSummary(access: TeamAccess.forRole(_role)),
                AppSpacing.v20,
                AppButton.primary(
                  text: widget.member == null
                      ? 'Create team profile'
                      : 'Save changes',
                  onPressed: () {
                    if (!_key.currentState!.validate()) return;
                    if (_role == TeamRole.serviceProvider &&
                        _isBookable &&
                        _serviceIds.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Assign at least one service before making a provider bookable.',
                          ),
                        ),
                      );
                      return;
                    }
                    if (_role == TeamRole.serviceProvider &&
                        _isBookable &&
                        _shiftsByKey.values
                            .where((shift) => !shift.isClosed)
                            .any(
                              (shift) =>
                                  _minutes(shift.endTime) <=
                                  _minutes(shift.startTime),
                            )) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('A shift must end after it starts.'),
                        ),
                      );
                      return;
                    }
                    Navigator.pop(
                      context,
                      TeamMember(
                        id:
                            widget.member?.id ??
                            'team_${DateTime.now().microsecondsSinceEpoch}',
                        fullName: _name.text.trim(),
                        mobileNumber: _phone.text.trim(),
                        email: _email.text.trim().isEmpty
                            ? null
                            : _email.text.trim(),
                        role: _role,
                        access: TeamAccess.forRole(_role),
                        locationIds: _locationIds.toList(),
                        serviceIds: _serviceIds.toList(),
                        weeklyShifts: _shiftsByKey.values
                            .where(
                              (shift) => _locationIds.contains(shift.shopId),
                            )
                            .toList(),
                        isBookable:
                            _role == TeamRole.serviceProvider && _isBookable,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AccessSummary extends StatelessWidget {
  const _AccessSummary({required this.access});
  final TeamAccess access;
  @override
  Widget build(BuildContext context) {
    final items = <String>[
      if (access.ownCalendarOnly) 'Own calendar',
      if (access.manageCalendar) 'All calendars',
      if (access.manageCatalog) 'Services & pricing',
      if (access.manageTeam) 'Team management',
      if (access.manageLocations) 'Shop settings',
      if (access.viewReports) 'Reports',
    ];
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.infoBackground,
        borderRadius: AppRadius.radius12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Access included with this role',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.info,
            ),
          ),
          AppSpacing.v6,
          Text(
            items.join(' · '),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppTextSizes.caption,
            ),
          ),
        ],
      ),
    );
  }
}
