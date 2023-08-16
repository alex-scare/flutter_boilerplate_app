// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'global_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GlobalState {
  bool get globalLoading => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GlobalStateCopyWith<GlobalState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GlobalStateCopyWith<$Res> {
  factory $GlobalStateCopyWith(
          GlobalState value, $Res Function(GlobalState) then) =
      _$GlobalStateCopyWithImpl<$Res, GlobalState>;
  @useResult
  $Res call({bool globalLoading});
}

/// @nodoc
class _$GlobalStateCopyWithImpl<$Res, $Val extends GlobalState>
    implements $GlobalStateCopyWith<$Res> {
  _$GlobalStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? globalLoading = null,
  }) {
    return _then(_value.copyWith(
      globalLoading: null == globalLoading
          ? _value.globalLoading
          : globalLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GlobalStateCopyWith<$Res>
    implements $GlobalStateCopyWith<$Res> {
  factory _$$_GlobalStateCopyWith(
          _$_GlobalState value, $Res Function(_$_GlobalState) then) =
      __$$_GlobalStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool globalLoading});
}

/// @nodoc
class __$$_GlobalStateCopyWithImpl<$Res>
    extends _$GlobalStateCopyWithImpl<$Res, _$_GlobalState>
    implements _$$_GlobalStateCopyWith<$Res> {
  __$$_GlobalStateCopyWithImpl(
      _$_GlobalState _value, $Res Function(_$_GlobalState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? globalLoading = null,
  }) {
    return _then(_$_GlobalState(
      globalLoading: null == globalLoading
          ? _value.globalLoading
          : globalLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_GlobalState implements _GlobalState {
  const _$_GlobalState({this.globalLoading = false});

  @override
  @JsonKey()
  final bool globalLoading;

  @override
  String toString() {
    return 'GlobalState(globalLoading: $globalLoading)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GlobalState &&
            (identical(other.globalLoading, globalLoading) ||
                other.globalLoading == globalLoading));
  }

  @override
  int get hashCode => Object.hash(runtimeType, globalLoading);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GlobalStateCopyWith<_$_GlobalState> get copyWith =>
      __$$_GlobalStateCopyWithImpl<_$_GlobalState>(this, _$identity);
}

abstract class _GlobalState implements GlobalState {
  const factory _GlobalState({final bool globalLoading}) = _$_GlobalState;

  @override
  bool get globalLoading;
  @override
  @JsonKey(ignore: true)
  _$$_GlobalStateCopyWith<_$_GlobalState> get copyWith =>
      throw _privateConstructorUsedError;
}
