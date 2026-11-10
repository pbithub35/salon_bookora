import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_routes.dart';
import '../../../data/models/user_model.dart';

final roleSelectionViewModelProvider =
    NotifierProvider.autoDispose<RoleSelectionViewModel, UserRole>(
      RoleSelectionViewModel.new,
    );

class RoleSelectionViewModel extends Notifier<UserRole> {
  @override
  UserRole build() => UserRole.customer;

  void selectRole(UserRole role) => state = role;

  String get nextRoute => state == UserRole.customer
      ? AppRoutes.registerCustomer
      : AppRoutes.registerOwner;
}
