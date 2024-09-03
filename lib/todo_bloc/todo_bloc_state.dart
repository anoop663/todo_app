import 'package:equatable/equatable.dart';

abstract class TodoState extends Equatable {
  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Map<String, dynamic>> todos;

  TodoLoaded({required this.todos});

  @override
  List<Object> get props => [todos];
}

class TodoError extends TodoState {
  final String message;

  TodoError({required this.message});

  

  @override
  List<Object> get props => [message];
}

class FormState1 extends TodoState {
  final String title;
  final String description;
  final String date;

  FormState1({
    required this.title,
    required this.description,
    required this.date,
  });

  FormState1 copyWith({
    String? title,
    String? description,
    String? date,
  }) {
    return FormState1(
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }

  @override
  List<Object> get props => [title, description, date];
}


class TodoSuccess extends TodoState {
  final String message;

  TodoSuccess({required this.message});


  @override
  List<Object> get props => [message];
}