import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../data/models/team_member_model.dart';
import '../../../data/repositories/team_repository.dart';
import '../../auth/viewmodels/auth_notifier.dart';

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  final user = ref.watch(authProvider).user;
  final repository = TeamRepository(
    preferences: ref.watch(sharedPreferencesProvider),
    storageKey: 'team_${user?.id ?? 'anonymous'}',
  );
  if (user != null) repository.seedOwner(user);
  return repository;
});

final teamProvider =
    NotifierProvider.autoDispose<TeamViewModel, List<TeamMember>>(
      TeamViewModel.new,
    );

class TeamViewModel extends Notifier<List<TeamMember>> {
  TeamRepository get _repository => ref.read(teamRepositoryProvider);

  @override
  List<TeamMember> build() => _repository.getAll();

  bool save(TeamMember member) {
    final duplicate = state.any(
      (item) =>
          item.id != member.id && item.mobileNumber == member.mobileNumber,
    );
    if (duplicate) return false;
    _repository.save(member);
    state = _repository.getAll();
    return true;
  }

  void archive(String id) {
    _repository.archive(id);
    state = _repository.getAll();
  }

  void restore(String id) {
    _repository.restore(id);
    state = _repository.getAll();
  }

  bool delete(String id) {
    final deleted = _repository.delete(id);
    state = _repository.getAll();
    return deleted;
  }
}
