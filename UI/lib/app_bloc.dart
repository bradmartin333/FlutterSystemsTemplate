import 'dart:async';
import 'dart:math';
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
class ChangeJsonEvent extends AppBlocEvent {
  final String value;
  const ChangeJsonEvent(this.value);
}

@immutable
class ChangeCursorEvent extends AppBlocEvent {
  final Point point;
  const ChangeCursorEvent(this.point);
}

// State

@immutable
class AppState extends Equatable {
  final int index;
  final String json;
  final Point cursor;

  const AppState.empty()
      : index = 0,
        json = "",
        cursor = const Point(-1, -1);

  const AppState({
    required this.index,
    required this.json,
    required this.cursor,
  });

  @override
  List<Object?> get props => [index, json, cursor];

  AppState copyWith({
    int? index,
    String? json,
    Point? cursor,
  }) {
    return AppState(
      index: index ?? this.index,
      json: json ?? this.json,
      cursor: cursor ?? this.cursor,
    );
  }
}

// BLoC

class AppBloc extends Bloc<AppBlocEvent, AppState> {
  AppBloc() : super(const AppState.empty()) {
    on<ChangeJsonEvent>(_onChangeJsonEvent);
    on<ChangeCursorEvent>(_onChangeCursorEvent);
  }

  FutureOr<void> _onChangeJsonEvent(
      ChangeJsonEvent event, Emitter<AppState> emit) async {
    // Clear cursor so the delete all button actually deletes all
    emit(state.copyWith(
        index: state.index + 1,
        json: event.value,
        cursor: const Point(-1, -1)));
  }

  FutureOr<void> _onChangeCursorEvent(
      ChangeCursorEvent event, Emitter<AppState> emit) async {
    emit(state.copyWith(cursor: event.point));
  }
}
