import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text.dart';
import '../../../common/widgets/app_text_field.dart';
import '../../../common/widgets/phone_number_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_sizes.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/shop_model.dart';
import '../../../data/models/team_member_model.dart';
import '../viewmodels/shops_viewmodel.dart';
import '../viewmodels/owner_portal_viewmodel.dart';
import '../viewmodels/team_viewmodel.dart';

class ShopDetailView extends ConsumerStatefulWidget {
  const ShopDetailView({super.key, required this.shopId});

  final String shopId;

  @override
  ConsumerState<ShopDetailView> createState() => _ShopDetailViewState();
}

class _ShopDetailViewState extends ConsumerState<ShopDetailView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final shops = ref.watch(shopsProvider);
    final shop =
        shops.where((s) => s.id == widget.shopId).firstOrNull ??
        ref.read(shopsProvider.notifier).shopById(widget.shopId);

    if (shop == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.shopsTitle)),
        body: Center(child: Text(l10n.shopsEmptyTitle)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        title: Text(shop.salonName),
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          indicatorColor: AppColors.cyan,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: l10n.shopDetails),
            Tab(text: l10n.shopServicesPrices),
            Tab(text: l10n.shopMembers),
            Tab(text: l10n.shopHours),
            Tab(text: l10n.shopBookingPage),
          ],
        ),
      ),
      body: Column(
        children: [
          if (shop.setupStatus == ShopSetupStatus.setupInProgress)
            _SetupProgressBanner(
              shop: shop,
              onAddServices: () => _tabs.animateTo(1),
              onAddMembers: () => _tabs.animateTo(2),
              onReviewBooking: () => _tabs.animateTo(4),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _DetailsTab(shop: shop),
                _ServicesTab(shop: shop),
                _ShopTeamTab(shop: shop),
                _HoursTab(shop: shop),
                _BookingTab(shop: shop),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SetupProgressBanner extends StatelessWidget {
  const _SetupProgressBanner({
    required this.shop,
    required this.onAddServices,
    required this.onAddMembers,
    required this.onReviewBooking,
  });

  final ShopModel shop;
  final VoidCallback onAddServices;
  final VoidCallback onAddMembers;
  final VoidCallback onReviewBooking;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.warningBackground,
        borderRadius: AppRadius.radius12,
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.setupProgressTitle,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: AppTextSizes.body,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.v4,
          Text(
            l10n.setupProgressSubtitle(
              shop.setupCompletedSteps,
              shop.setupTotalSteps,
            ),
            style: TextStyle(
              fontSize: AppTextSizes.caption,
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.v8,
          ClipRRect(
            borderRadius: AppRadius.radius20,
            child: LinearProgressIndicator(
              value: shop.setupProgress,
              minHeight: 6.h,
              backgroundColor: Colors.white,
              color: AppColors.warning,
            ),
          ),
          AppSpacing.v12,
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              FilledButton.tonal(
                onPressed: onAddServices,
                child: Text(l10n.actionAddServices),
              ),
              FilledButton.tonal(
                onPressed: onAddMembers,
                child: Text(l10n.actionAddMembers),
              ),
              FilledButton.tonal(
                onPressed: onReviewBooking,
                child: Text(l10n.actionReviewBookingPage),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailsTab extends StatelessWidget {
  const _DetailsTab({required this.shop});
  final ShopModel shop;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: EdgeInsets.all(16.r),
      children: [
        _InfoTile(l10n.shopName, shop.salonName),
        _InfoTile(l10n.shopType, shop.salonType),
        _InfoTile(l10n.shopPhone, shop.contactNumber),
        _InfoTile(l10n.email, shop.email ?? l10n.notProvided),
        _InfoTile(l10n.addressLine1, shop.addressLine1),
        if (shop.addressLine2 != null && shop.addressLine2!.isNotEmpty)
          _InfoTile(l10n.addressLine2, shop.addressLine2!),
        _InfoTile(l10n.city, '${shop.city}, ${shop.state} ${shop.pincode}'),
        if (shop.description != null && shop.description!.isNotEmpty)
          _InfoTile(l10n.salonDescription, shop.description!),
        if (shop.website != null && shop.website!.isNotEmpty)
          _InfoTile(l10n.websiteOptional, shop.website!),
        if (shop.gstin != null && shop.gstin!.isNotEmpty)
          _InfoTile(l10n.gstinOptional, shop.gstin!),
        if (shop.latitude != null)
          _InfoTile(
            l10n.mapPinOptional,
            '${shop.latitude!.toStringAsFixed(4)}, ${shop.longitude!.toStringAsFixed(4)}',
          ),
      ],
    );
  }
}

class _ShopTeamTab extends ConsumerWidget {
  const _ShopTeamTab({required this.shop});
  final ShopModel shop;

  void _openTeam(BuildContext context, WidgetRef ref) {
    ref
        .read(ownerPortalViewModelProvider.notifier)
        .changeTab(OwnerPortalTabs.team);
    context.go(AppRoutes.ownerShell);
  }

  String _roleName(TeamRole role) => switch (role) {
    TeamRole.owner => 'Owner',
    TeamRole.administrator => 'Sub-admin',
    TeamRole.manager => 'Manager',
    TeamRole.receptionist => 'Receptionist',
    TeamRole.serviceProvider => 'Service provider',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref
        .watch(teamProvider)
        .where(
          (member) =>
              member.status == TeamMemberStatus.active &&
              member.locationIds.contains(shop.id),
        )
        .toList();
    return ListView(
      padding: EdgeInsets.all(16.r),
      children: [
        Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: AppColors.infoBackground,
            borderRadius: AppRadius.radius12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Team is managed for the whole business',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.info,
                ),
              ),
              AppSpacing.v4,
              Text(
                'Assign a profile to this shop from Team. One person can work at more than one location.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppTextSizes.caption,
                ),
              ),
              AppSpacing.v10,
              FilledButton.tonalIcon(
                onPressed: () => _openTeam(context, ref),
                icon: const Icon(Icons.groups_rounded),
                label: const Text('Manage team'),
              ),
            ],
          ),
        ),
        AppSpacing.v16,
        Text(
          '${members.length} assigned to ${shop.salonName}',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: AppTextSizes.bodySmall,
          ),
        ),
        AppSpacing.v8,
        if (members.isEmpty)
          Text(
            'No active team profiles are assigned to this shop yet.',
            style: TextStyle(color: AppColors.textSecondary),
          )
        else
          ...members.map(
            (member) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: AppColors.surfaceSubtle,
                child: Text(
                  member.fullName.isEmpty
                      ? '?'
                      : member.fullName[0].toUpperCase(),
                ),
              ),
              title: Text(member.fullName),
              subtitle: Text(
                '${_roleName(member.role)}${member.isBookable ? ' · Bookable' : ''}',
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => _openTeam(context, ref),
            ),
          ),
      ],
    );
  }
}

class _ServicesTab extends ConsumerWidget {
  const _ServicesTab({required this.shop});
  final ShopModel shop;

  Future<void> _addService(BuildContext context, WidgetRef ref) async {
    final service = await showDialog<ShopServiceItem>(
      context: context,
      builder: (_) => const _AddServiceDialog(),
    );
    if (service != null) {
      ref
          .read(shopsProvider.notifier)
          .upsert(shop.copyWith(services: [...shop.services, service]));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    if (shop.services.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.noServicesYet),
              AppSpacing.v12,
              FilledButton.icon(
                onPressed: () => _addService(context, ref),
                icon: const Icon(Icons.add),
                label: Text(l10n.addService),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
          child: Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: () => _addService(context, ref),
              icon: const Icon(Icons.add),
              label: Text(l10n.addService),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(16.r),
            itemCount: shop.services.length,
            separatorBuilder: (_, _) => AppSpacing.v10,
            itemBuilder: (context, index) {
              final service = shop.services[index];
              return Container(
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.radius12,
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: AppTextSizes.body,
                            ),
                          ),
                          if (service.category?.isNotEmpty == true)
                            Text(
                              service.category!,
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: AppTextSizes.tiny,
                              ),
                            ),
                          Text(
                            l10n.durationMinutes(service.durationMinutes),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: AppTextSizes.caption,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${service.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryPurple,
                        fontSize: AppTextSizes.titleSmall,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AddServiceDialog extends StatefulWidget {
  const _AddServiceDialog();

  @override
  State<_AddServiceDialog> createState() => _AddServiceDialogState();
}

class _AddServiceDialogState extends State<_AddServiceDialog> {
  final _key = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _category = TextEditingController();
  final _duration = TextEditingController(text: '30');
  final _price = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _category.dispose();
    _duration.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.addService),
      content: Form(
        key: _key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              label: l10n.serviceName,
              controller: _name,
              validator: (v) =>
                  Validators.validateRequired(l10n, v, l10n.serviceName),
            ),
            AppSpacing.v12,
            AppTextField(label: l10n.serviceCategory, controller: _category),
            AppSpacing.v12,
            AppTextField(
              label: l10n.serviceDuration,
              controller: _duration,
              keyboardType: TextInputType.number,
              validator: (v) => (int.tryParse(v ?? '') ?? 0) > 0
                  ? null
                  : l10n.validationPositiveDuration,
            ),
            AppSpacing.v12,
            AppTextField(
              label: l10n.servicePrice,
              controller: _price,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (v) => (double.tryParse(v ?? '') ?? 0) > 0
                  ? null
                  : l10n.validationPositivePrice,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (!_key.currentState!.validate()) return;
            Navigator.pop(
              context,
              ShopServiceItem(
                id: 'svc_${DateTime.now().microsecondsSinceEpoch}',
                name: _name.text.trim(),
                category: _category.text.trim().isEmpty
                    ? null
                    : _category.text.trim(),
                durationMinutes: int.parse(_duration.text),
                price: double.parse(_price.text),
              ),
            );
          },
          child: Text(l10n.addService),
        ),
      ],
    );
  }
}

class _HoursTab extends StatelessWidget {
  const _HoursTab({required this.shop});
  final ShopModel shop;

  String _dayLabel(BuildContext context, int day) {
    final l10n = context.l10n;
    return switch (day) {
      1 => l10n.dayMon,
      2 => l10n.dayTue,
      3 => l10n.dayWed,
      4 => l10n.dayThu,
      5 => l10n.dayFri,
      6 => l10n.daySat,
      _ => l10n.daySun,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView.separated(
      padding: EdgeInsets.all(16.r),
      itemCount: shop.hours.length,
      separatorBuilder: (_, _) => AppSpacing.v8,
      itemBuilder: (context, index) {
        final h = shop.hours[index];
        return ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.radius12,
            side: BorderSide(color: AppColors.border),
          ),
          tileColor: AppColors.surface,
          title: Text(_dayLabel(context, h.dayIndex)),
          trailing: Text(
            h.isClosed ? l10n.closed : l10n.openHours(h.open, h.close),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: h.isClosed ? AppColors.error : AppColors.textPrimary,
            ),
          ),
        );
      },
    );
  }
}

class _BookingTab extends StatelessWidget {
  const _BookingTab({required this.shop});
  final ShopModel shop;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: EdgeInsets.all(16.r),
      children: [
        AppText.title(l10n.shopBookingPage),
        AppSpacing.v8,
        Text(
          l10n.bookingPagePreviewOnly,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: AppTextSizes.bodySmall,
          ),
        ),
        AppSpacing.v16,
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.radius12,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.title(shop.salonName),
              AppSpacing.v8,
              _InfoTile(l10n.shopType, shop.salonType),
              _InfoTile(l10n.shopPhone, shop.contactNumber),
              _InfoTile(l10n.addressLine1, shop.address),
              if (shop.services.isNotEmpty) ...[
                AppText.title(
                  l10n.shopServicesPrices,
                  fontSize: AppTextSizes.titleSmall,
                ),
                AppSpacing.v8,
                ...shop.services.map(
                  (service) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(service.name),
                    subtitle: Text(
                      l10n.durationMinutes(service.durationMinutes),
                    ),
                    trailing: Text('₹${service.price.toStringAsFixed(0)}'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// Kept temporarily to preserve the old per-shop profile editor until data migration.
// The visible tab uses the business-level `_ShopTeamTab` above.
// ignore: unused_element
class _MembersTab extends ConsumerWidget {
  const _MembersTab({required this.shop});
  final ShopModel shop;

  String _roleLabel(BuildContext context, ShopMemberRole role) {
    final l10n = context.l10n;
    return switch (role) {
      ShopMemberRole.owner => l10n.roleOwner,
      ShopMemberRole.subAdmin => l10n.roleSubAdmin,
      ShopMemberRole.staff => l10n.roleStaff,
    };
  }

  Future<void> _openAddMember(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<ShopMember>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddMemberSheet(services: shop.services),
    );
    if (result == null) return;
    final added = ref.read(shopsProvider.notifier).addMember(shop.id, result);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            added
                ? context.l10n.memberAdded
                : context.l10n.memberPhoneAlreadyUsed,
          ),
        ),
      );
    }
  }

  Future<void> _editMember(
    BuildContext context,
    WidgetRef ref,
    ShopMember member,
  ) async {
    final updated = await showModalBottomSheet<ShopMember>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddMemberSheet(member: member, services: shop.services),
    );
    if (updated != null) {
      final saved = ref
          .read(shopsProvider.notifier)
          .updateMember(shop.id, updated);
      if (context.mounted && !saved) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.memberPhoneAlreadyUsed)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
          child: Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: () => _openAddMember(context, ref),
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: Text(l10n.addMember),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(16.r),
            itemCount: shop.members.length,
            separatorBuilder: (_, _) => AppSpacing.v10,
            itemBuilder: (context, index) {
              final member = shop.members[index];
              return Container(
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.radius12,
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.surfaceSubtle,
                          child: Text(
                            member.name.isNotEmpty
                                ? member.name[0].toUpperCase()
                                : '?',
                          ),
                        ),
                        AppSpacing.h12,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: AppTextSizes.body,
                                ),
                              ),
                              Text(
                                '${_roleLabel(context, member.role)} · ${member.mobileNumber}',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: AppTextSizes.caption,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (member.role != ShopMemberRole.owner) ...[
                          IconButton(
                            tooltip: l10n.editMember,
                            onPressed: () => _editMember(context, ref, member),
                            icon: const Icon(Icons.edit_outlined),
                          ),
                          IconButton(
                            tooltip: l10n.removeMember,
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  title: Text(l10n.removeMember),
                                  content: Text(member.name),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext, false),
                                      child: Text(l10n.cancel),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext, true),
                                      child: Text(l10n.removeMember),
                                    ),
                                  ],
                                ),
                              );
                              if (confirmed != true || !context.mounted) return;
                              final ok = ref
                                  .read(shopsProvider.notifier)
                                  .removeMember(shop.id, member.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    ok
                                        ? l10n.memberRemoved
                                        : l10n.cannotRemoveOwner,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ],
                    ),
                    AppSpacing.v10,
                    if (member.role == ShopMemberRole.staff &&
                        member.serviceIds.isNotEmpty)
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 6.h,
                        children: [
                          for (final service in shop.services.where(
                            (service) => member.serviceIds.contains(service.id),
                          ))
                            _PermChip(service.name),
                        ],
                      ),
                    if (member.role == ShopMemberRole.staff &&
                        member.serviceIds.isNotEmpty)
                      AppSpacing.v10,
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 6.h,
                      children: [
                        if (member.permissions.manageBookings)
                          _PermChip(l10n.permManageBookings),
                        if (member.permissions.manageServices)
                          _PermChip(l10n.permManageServices),
                        if (member.permissions.manageStaff)
                          _PermChip(l10n.permManageStaff),
                        if (member.permissions.manageShopSettings)
                          _PermChip(l10n.permManageShopSettings),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PermChip extends StatelessWidget {
  const _PermChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: AppRadius.radius20,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: AppTextSizes.tiny,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _AddMemberSheet extends StatefulWidget {
  const _AddMemberSheet({this.member, required this.services});

  final ShopMember? member;
  final List<ShopServiceItem> services;

  @override
  State<_AddMemberSheet> createState() => _AddMemberSheetState();
}

class _AddMemberSheetState extends State<_AddMemberSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  ShopMemberRole _role = ShopMemberRole.staff;
  late ShopPermissions _permissions;
  late Set<String> _serviceIds;

  @override
  void initState() {
    super.initState();
    final member = widget.member;
    if (member != null) {
      _name.text = member.name;
      _phone.text = member.mobileNumber;
      _role = member.role;
      _permissions = member.permissions;
      _serviceIds = member.serviceIds.toSet();
    } else {
      _permissions = ShopPermissions.forRole(_role);
      _serviceIds = <String>{};
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _onRoleChanged(ShopMemberRole? role) {
    if (role == null || role == ShopMemberRole.owner) return;
    setState(() {
      _role = role;
      _permissions = ShopPermissions.forRole(role);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h + bottom),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppText.title(
                widget.member == null ? l10n.addMember : l10n.editMember,
              ),
              AppSpacing.v16,
              AppTextField(
                label: l10n.memberName,
                controller: _name,
                validator: (v) => Validators.validateFullName(l10n, v),
              ),
              AppSpacing.v12,
              PhoneNumberField(
                controller: _phone,
                selectedCountryCode: '+91',
                validator: (v) => Validators.validateMobile(l10n, v),
              ),
              AppSpacing.v12,
              DropdownButtonFormField<ShopMemberRole>(
                initialValue: _role,
                decoration: InputDecoration(
                  labelText: l10n.memberRole,
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: ShopMemberRole.subAdmin,
                    child: Text(l10n.roleSubAdmin),
                  ),
                  DropdownMenuItem(
                    value: ShopMemberRole.staff,
                    child: Text(l10n.roleStaff),
                  ),
                ],
                onChanged: _onRoleChanged,
              ),
              if (_role == ShopMemberRole.staff) ...[
                AppSpacing.v16,
                Text(
                  l10n.staffServices,
                  style: TextStyle(
                    fontSize: AppTextSizes.bodySmall,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.v4,
                Text(
                  widget.services.isEmpty
                      ? l10n.noServicesToAssign
                      : l10n.staffServicesHint,
                  style: TextStyle(
                    fontSize: AppTextSizes.caption,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (widget.services.isNotEmpty)
                  ...widget.services.map(
                    (service) => CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(service.name),
                      value: _serviceIds.contains(service.id),
                      onChanged: (selected) => setState(() {
                        if (selected ?? false) {
                          _serviceIds.add(service.id);
                        } else {
                          _serviceIds.remove(service.id);
                        }
                      }),
                    ),
                  ),
              ],
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.permManageBookings),
                value: _permissions.manageBookings,
                onChanged: (v) => setState(() {
                  _permissions = _permissions.copyWith(
                    manageBookings: v ?? false,
                  );
                }),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.permManageServices),
                value: _permissions.manageServices,
                onChanged: (v) => setState(() {
                  _permissions = _permissions.copyWith(
                    manageServices: v ?? false,
                  );
                }),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.permManageStaff),
                value: _permissions.manageStaff,
                onChanged: (v) => setState(() {
                  _permissions = _permissions.copyWith(manageStaff: v ?? false);
                }),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.permManageShopSettings),
                value: _permissions.manageShopSettings,
                onChanged: (v) => setState(() {
                  _permissions = _permissions.copyWith(
                    manageShopSettings: v ?? false,
                  );
                }),
              ),
              AppSpacing.v12,
              AppButton.primary(
                text: widget.member == null ? l10n.addMember : l10n.saveMember,
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  Navigator.pop(
                    context,
                    ShopMember(
                      id:
                          widget.member?.id ??
                          'mem_${DateTime.now().millisecondsSinceEpoch}',
                      name: _name.text.trim(),
                      mobileNumber: _phone.text.trim(),
                      role: _role,
                      permissions: _permissions,
                      serviceIds: _role == ShopMemberRole.staff
                          ? _serviceIds.toList(growable: false)
                          : const [],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppTextSizes.caption,
              color: AppColors.textMuted,
            ),
          ),
          AppSpacing.v4,
          Text(
            value,
            style: TextStyle(
              fontSize: AppTextSizes.body,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
