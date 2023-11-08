import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Event

@immutable
abstract class AppBlocEvent {
  const AppBlocEvent();
}

@immutable
class ChangeStateEvent extends AppBlocEvent {
  final int value;
  const ChangeStateEvent(this.value);
}

// State

@immutable
class AppState extends Equatable {
  final int index;
  final int value;

  const AppState.empty()
      : index = 0,
        value = 0;

  const AppState({
    required this.index,
    required this.value,
  });

  @override
  List<Object?> get props => [index, value];

  AppState copyWith({
    int? index,
    int? value,
  }) {
    return AppState(
      index: index ?? this.index,
      value: value ?? this.value,
    );
  }
}

// BLoC

class AppBloc extends Bloc<AppBlocEvent, AppState> {
  AppBloc() : super(const AppState.empty()) {
    on<ChangeStateEvent>(_onChangeStateEvent);
  }

  FutureOr<void> _onChangeStateEvent(
      ChangeStateEvent event, Emitter<AppState> emit) async {
    emit(state.copyWith(index: state.index + 1, value: event.value));
  }
}
