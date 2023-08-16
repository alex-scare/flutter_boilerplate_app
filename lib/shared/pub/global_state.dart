import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'global_state.freezed.dart';

final globalStatePod = StateNotifierProvider<GlobalStateNotifier, GlobalState>(
  (ref) => GlobalStateNotifier(),
);

class GlobalStateNotifier extends StateNotifier<GlobalState> {
  GlobalStateNotifier() : super(const GlobalState());

  void setGlobalLoading(bool isLoading) {
    state = state.copyWith(globalLoading: isLoading);
  }
}

@freezed
class GlobalState with _$GlobalState {
  const factory GlobalState({
    @Default(false) bool globalLoading,
  }) = _GlobalState;
}
