import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text.dart';
import '../../../common/widgets/app_text_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_sizes.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/shop_model.dart';
import '../../../data/repositories/shop_repository.dart';
import '../viewmodels/owner_portal_viewmodel.dart';
import '../viewmodels/shops_viewmodel.dart';

class CreateShopView extends ConsumerStatefulWidget {
  const CreateShopView({super.key});

  @override
  ConsumerState<CreateShopView> createState() => _CreateShopViewState();
}

class _CreateShopViewState extends ConsumerState<CreateShopView> {
  final _detailsKey = GlobalKey<FormState>();
  final _locationKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _description = TextEditingController();
  final _website = TextEditingController();
  final _social = TextEditingController();
  final _address1 = TextEditingController();
  final _address2 = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController(text: 'Punjab');
  final _pincode = TextEditingController();
  final _gstin = TextEditingController();

  String _shopType = AppConstants.shopTypes.first;
  int _step = 0;
  bool _saving = false;
  late List<ShopDayHours> _hours;

  @override
  void initState() {
    super.initState();
    _hours = InMemoryShopRepository.defaultHours();
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _description.dispose();
    _website.dispose();
    _social.dispose();
    _address1.dispose();
    _address2.dispose();
    _city.dispose();
    _state.dispose();
    _pincode.dispose();
    _gstin.dispose();
    super.dispose();
  }

  String _dayLabel(int day) {
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

  Future<void> _pickTime({required int index, required bool isOpen}) async {
    final current = _hours[index];
    final parts = (isOpen ? current.open : current.close).split(':');
    final initial = TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 10,
      minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
    );
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;
    final formatted =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    setState(() {
      _hours[index] = isOpen
          ? current.copyWith(open: formatted)
          : current.copyWith(close: formatted);
    });
  }

  void _copyMondayToOpenDays() {
    final monday = _hours.firstWhere((h) => h.dayIndex == 1);
    setState(() {
      _hours = [
        for (final h in _hours)
          if (h.dayIndex == 1 || h.isClosed)
            h
          else
            h.copyWith(open: monday.open, close: monday.close, isClosed: false),
      ];
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.hoursCopied)));
  }

  bool _validateHours() {
    if (_hours.every((h) => h.isClosed)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.atLeastOneOpenDay)));
      return false;
    }
    for (final day in _hours.where((day) => !day.isClosed)) {
      final open = _timeInMinutes(day.open);
      final close = _timeInMinutes(day.close);
      if (open == null || close == null || close <= open) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.invalidOpeningHours)),
        );
        return false;
      }
    }
    return true;
  }

  int? _timeInMinutes(String value) {
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null ||
        hour < 0 ||
        hour > 23 ||
        minute == null ||
        minute < 0 ||
        minute > 59) {
      return null;
    }
    return hour * 60 + minute;
  }

  void _next() {
    if (_step == 0) {
      if (!_detailsKey.currentState!.validate()) return;
      setState(() => _step = 1);
      return;
    }
    if (_step == 1) {
      if (!_locationKey.currentState!.validate()) return;
      setState(() => _step = 2);
    }
  }

  Future<void> _save() async {
    if (!_validateHours()) return;
    setState(() => _saving = true);

    ref
        .read(shopsProvider.notifier)
        .createShop(
          salonName: _name.text.trim(),
          salonType: _shopType,
          contactNumber: _phone.text.trim(),
          email: _email.text.trim().isEmpty ? null : _email.text.trim(),
          description: _description.text.trim().isEmpty
              ? null
              : _description.text.trim(),
          website: _website.text.trim().isEmpty ? null : _website.text.trim(),
          socialLinks: _social.text.trim().isEmpty ? null : _social.text.trim(),
          addressLine1: _address1.text.trim(),
          addressLine2: _address2.text.trim().isEmpty
              ? null
              : _address2.text.trim(),
          city: _city.text.trim(),
          stateName: _state.text.trim(),
          pincode: _pincode.text.trim(),
          gstin: _gstin.text.trim().isEmpty ? null : _gstin.text.trim(),
          hours: List<ShopDayHours>.from(_hours),
        );

    if (!mounted) return;
    ref
        .read(ownerPortalViewModelProvider.notifier)
        .changeTab(OwnerPortalTabs.shops);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.shopSaved)));
    context.go(AppRoutes.ownerShell);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final titles = [l10n.stepShopDetails, l10n.stepLocation, l10n.stepHours];

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        title: Text(l10n.createShopTitle),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.title(titles[_step]),
                AppSpacing.v10,
                Row(
                  children: List.generate(3, (i) {
                    final active = i <= _step;
                    return Expanded(
                      child: Container(
                        height: 4.h,
                        margin: EdgeInsets.only(right: i < 2 ? 6.w : 0),
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.primaryPurple
                              : AppColors.border,
                          borderRadius: AppRadius.radius20,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (_step) {
              0 => _buildDetailsStep(),
              1 => _buildLocationStep(),
              _ => _buildHoursStep(),
            },
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: Row(
                children: [
                  if (_step > 0)
                    Expanded(
                      child: AppButton.secondary(
                        text: l10n.backStep,
                        onPressed: () => setState(() => _step -= 1),
                      ),
                    ),
                  if (_step > 0) AppSpacing.h12,
                  Expanded(
                    child: AppButton.primary(
                      text: _step == 2 ? l10n.saveShop : l10n.nextStep,
                      isLoading: _saving,
                      onPressed: _saving
                          ? null
                          : () {
                              if (_step < 2) {
                                _next();
                              } else {
                                _save();
                              }
                            },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsStep() {
    final l10n = context.l10n;
    return Form(
      key: _detailsKey,
      child: ListView(
        padding: EdgeInsets.all(16.r),
        children: [
          AppTextField(
            label: '${l10n.shopName} *',
            controller: _name,
            validator: (v) => Validators.validateFullName(l10n, v),
          ),
          AppSpacing.v12,
          DropdownButtonFormField<String>(
            initialValue: _shopType,
            decoration: _dropdownDecoration('${l10n.shopType} *'),
            items: AppConstants.shopTypes
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _shopType = v);
            },
          ),
          AppSpacing.v12,
          AppTextField(
            label: '${l10n.shopPhone} *',
            controller: _phone,
            keyboardType: TextInputType.phone,
            validator: (v) => Validators.validateMobile(l10n, v),
          ),
          AppSpacing.v12,
          AppTextField(
            label: l10n.shopEmailOptional,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => Validators.validateEmail(l10n, v),
          ),
          AppSpacing.v12,
          AppTextField(
            label: l10n.shopDescriptionOptional,
            controller: _description,
            maxLines: 3,
          ),
          AppSpacing.v12,
          AppTextField(label: l10n.websiteOptional, controller: _website),
          AppSpacing.v12,
          AppTextField(label: l10n.socialLinksOptional, controller: _social),
          AppSpacing.v12,
          AppTextField(
            label: l10n.gstinOptional,
            controller: _gstin,
            hintText: l10n.gstinHint,
          ),
          AppSpacing.v12,
          Text(
            l10n.mediaLater,
            style: TextStyle(
              fontSize: AppTextSizes.caption,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStep() {
    final l10n = context.l10n;
    return Form(
      key: _locationKey,
      child: ListView(
        padding: EdgeInsets.all(16.r),
        children: [
          AppTextField(
            label: '${l10n.addressLine1} *',
            controller: _address1,
            validator: (v) =>
                Validators.validateRequired(l10n, v, l10n.addressLine1),
          ),
          AppSpacing.v12,
          AppTextField(label: l10n.addressLine2, controller: _address2),
          AppSpacing.v12,
          AppTextField(
            label: '${l10n.city} *',
            controller: _city,
            validator: (v) => Validators.validateRequired(l10n, v, l10n.city),
          ),
          AppSpacing.v12,
          AppTextField(
            label: '${l10n.state} *',
            controller: _state,
            validator: (v) => Validators.validateRequired(l10n, v, l10n.state),
          ),
          AppSpacing.v12,
          AppTextField(
            label: '${l10n.pincode} *',
            controller: _pincode,
            keyboardType: TextInputType.number,
            validator: (v) => Validators.validatePincode(l10n, v),
          ),
          AppSpacing.v20,
          AppText.title(l10n.mapPinOptional, fontSize: AppTextSizes.titleSmall),
          AppSpacing.v8,
          Text(
            l10n.mapPinSkipped,
            style: TextStyle(
              fontSize: AppTextSizes.caption,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoursStep() {
    final l10n = context.l10n;
    return ListView(
      padding: EdgeInsets.all(16.r),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _copyMondayToOpenDays,
            icon: const Icon(Icons.copy_all_rounded),
            label: Text(l10n.copyHoursToAll),
          ),
        ),
        AppSpacing.v8,
        ...List.generate(_hours.length, (index) {
          final h = _hours[index];
          return Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.radius12,
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _dayLabel(h.dayIndex),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: AppTextSizes.body,
                        ),
                      ),
                    ),
                    Text(l10n.closed),
                    Switch(
                      value: h.isClosed,
                      onChanged: (closed) {
                        setState(() {
                          _hours[index] = h.copyWith(isClosed: closed);
                        });
                      },
                    ),
                  ],
                ),
                if (!h.isClosed)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              _pickTime(index: index, isOpen: true),
                          child: Text('${l10n.openTime}: ${h.open}'),
                        ),
                      ),
                      AppSpacing.h8,
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              _pickTime(index: index, isOpen: false),
                          child: Text('${l10n.closeTime}: ${h.close}'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
    );
  }
}
