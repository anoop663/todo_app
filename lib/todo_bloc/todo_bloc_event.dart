import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class DateChanged extends TodoEvent {
  final DateTime date;

  DateChanged(this.date);

  @override
  List<Object> get props => [date];
}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String title;
  final String description;
  final String date;

  AddTodo({required this.title, required this.description, required this.date});
}

class FormUpdated extends TodoEvent {
  final String title;
  final String description;
  final String date;

  FormUpdated(
      {required this.title, required this.description, required this.date});
}

class ToggleFavorite extends TodoEvent {
  final int index;

  ToggleFavorite({required this.index});
}

class UpdateTodo extends TodoEvent {
  final int id;
  final String title;
  final String description;
  final String date;
  final bool isDone;

  UpdateTodo({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.isDone,
  });
}

class DeleteTodo extends TodoEvent {
  final int id;

  DeleteTodo({required this.id});
}

class UpdateFavorite extends TodoEvent {
  final int id;
  final String title;
  final String description;
  final String date;
  final bool isPersonal;
  final bool isDone;

  UpdateFavorite({
    required this.id,
    required this.isPersonal,
    required this.title,
    required this.description,
    required this.date,
    required this.isDone,
  });
}
