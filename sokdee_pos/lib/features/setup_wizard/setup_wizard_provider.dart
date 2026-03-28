import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sokdee_pos/core/network/api_client.dart';

part 'setup_wizard_provider.freezed.dart';
part 'setup_wizard_provider.g.dart';

@freezed
class SetupWizardState with _$SetupWizardState {
  const factory SetupWizardState({
    @Default('') String name,
    @Default('retail') String type,
    @Default('starter') String plan,
    @Default(1) int maxUsers,
    @Default(0) int maxTables,
    @Default(false) bool enableKds,
    @Default(AsyncValue.data(null)) AsyncValue<void> submissionStatus,
  }) = _SetupWizardState;
}

@riverpod
class SetupWizard extends _$SetupWizard {
  @override
  SetupWizardState build() => const SetupWizardState();

  void setName(String value) => state = state.copyWith(name: value);
  void setType(String value) => state = state.copyWith(type: value);
  void setPlan(String value) => state = state.copyWith(plan: value);
  void setMaxUsers(int value) => state = state.copyWith(maxUsers: value);
  void setMaxTables(int value) => state = state.copyWith(maxTables: value);
  void setEnableKds(bool value) => state = state.copyWith(enableKds: value);

  Future<bool> submit() async {
    state = state.copyWith(submissionStatus: const AsyncValue.loading());
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.post(
        '/admin/tenants',
        body: {
          'name': state.name,
          'type': state.type,
          'subscription_plan': state.plan,
          'max_users': state.maxUsers,
          if (state.type == 'restaurant') 'max_tables': state.maxTables,
          if (state.type == 'restaurant') 'enable_kds': state.enableKds,
        },
      );
      state = state.copyWith(submissionStatus: const AsyncValue.data(null));
      return true;
    } catch (e, st) {
      state = state.copyWith(submissionStatus: AsyncValue.error(e, st));
      return false;
    }
  }
}
