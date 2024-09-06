import 'package:flutter_application_todo/api_data/api_constants.dart';
import 'package:flutter_application_todo/todo_bloc/todo_bloc_event.dart';
import 'package:flutter_application_todo/todo_bloc/todo_bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TodoBloc extends Bloc<TodoEvent, TodoState> {

  TodoBloc() : super(TodoInitial()) {
    on<LoadTodos>(_loadTodos);
    on<AddTodo>(_addTodo);
    on<ToggleFavorite>(_toggleFavorite);
    on<UpdateTodo>(_updateTodo);
    on<DeleteTodo>(_deleteTodo);
    on<UpdateFavorite>(_updateFavorite);
    on<FormUpdated>(_formUpdated);
  }

  Future<void> _loadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: header,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;

        final todos = data.map((item) {
          return {
            'id': item['id'] ?? 'no_id',
            'name': item['name'] ?? 'Untitled',
            'description': item['description'] ?? '',
            'completed_at': item['completed_at'] ?? 'No date',
            'is_personal': item['is_personal'] ?? false,
          };
        }).toList();

        emit(TodoLoaded(todos: todos));
      } else {
        emit(TodoError(message: 'Failed to load todos.'));
      }
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _addTodo(AddTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: header,
        body: json.encode({
          'name': event.title,
          'description': event.description,
          'completed_at': event.date,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201 ||
          (responseData['message'] ?? '') == 'Task was created') {
        // Reload the todos after adding
        add(LoadTodos());
        
        emit(TodoSuccess(message: 'The ToDo was created successfully.'));
      } else {
        emit(TodoError(message: 'Failed to add todo.'));
      }
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  void _toggleFavorite(ToggleFavorite event, Emitter<TodoState> emit) {
    final currentState = state;

    if (currentState is TodoLoaded) {
      final updatedTodos = List<Map<String, dynamic>>.from(currentState.todos);
      updatedTodos[event.index]['is_personal'] =
          !updatedTodos[event.index]['is_personal'];
      emit(TodoLoaded(todos: updatedTodos));
    }
  }

  Future<void> _updateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/${event.id}'),
        headers: header,
        body: json.encode({
          'name': event.title,
          'description': event.description,
          'completed_at': event.date,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 202 ||
          responseData['message'] == 'Task was updated') {
        // Reload the todos after updating
        add(LoadTodos());
        emit(TodoSuccess(message: 'The ToDo updated successfully.'));
      } else {
        emit(TodoError(message: 'Failed to update todo.'));
      }
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _deleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    final currentState = state;

    if (currentState is TodoLoaded) {
      final updatedTodos = List<Map<String, dynamic>>.from(currentState.todos)
        ..removeWhere((todo) => todo['id'] == event.id);

      emit(TodoLoaded(todos: updatedTodos));

      try {
        final response = await http.delete(
          Uri.parse('$baseUrl/${event.id}'),
          headers: header,
        );

        final responseData = json.decode(response.body);
        if (response.statusCode != 200 ||
            responseData['message'] != 'Task was deleted') {
          emit(TodoError(message: 'Failed to delete todo.'));
          emit(TodoLoaded(todos: currentState.todos));
        }
      } catch (e) {
        emit(TodoError(message: e.toString()));
        emit(TodoLoaded(todos: currentState.todos));
      }
    }
  }

  Future<void> _updateFavorite(UpdateFavorite event, Emitter<TodoState> emit) async {
    final currentState = state;

    if (currentState is TodoLoaded) {
      final updatedTodos = List<Map<String, dynamic>>.from(currentState.todos);
      final index = updatedTodos.indexWhere((todo) => todo['id'] == event.id);

      if (index != -1) {
        updatedTodos[index]['is_personal'] = event.isPersonal;
        emit(TodoLoaded(todos: updatedTodos));

        try {
          final response = await http.patch(
            Uri.parse('$baseUrl/${event.id}'),
            headers: header,
            body: json.encode({
              'name': event.title,
              'description': event.description,
              'completed_at': event.date,
              'is_personal': event.isPersonal,
            }),
          );

          final responseData = json.decode(response.body);
          if (response.statusCode != 202 ||
              responseData['message'] != 'Task was updated') {
            emit(TodoError(message: 'Failed to add to favorite.'));
            updatedTodos[index]['is_personal'] = !event.isPersonal;
            emit(TodoLoaded(todos: updatedTodos));
          }
        } catch (e) {
          emit(TodoError(message: e.toString()));
          updatedTodos[index]['is_personal'] = !event.isPersonal;
          emit(TodoLoaded(todos: updatedTodos));
        }
      }
    }
  }

  void _formUpdated(FormUpdated event, Emitter<TodoState> emit) {
    emit(FormState1(
      title: event.title,
      description: event.description,
      date: event.date,
    ));
  }
}
