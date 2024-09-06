import 'package:flutter/material.dart';
import 'package:flutter_application_todo/todo_bloc/todo_bloc_event.dart';
import 'package:flutter_application_todo/todo_bloc/todo_bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_todo/todo_bloc/todo_bloc.dart';

class MyFav extends StatelessWidget {
  const MyFav({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoBloc()..add(LoadTodos()),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              int todoCount = 0;
              if (state is TodoLoaded) {
                todoCount = state.todos.where((todo) => todo['is_personal']).length;
              }
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('My Favorite Todos'),
                  Chip(
                    label: Text(
                      '$todoCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ],
              );
            },
          ),
          backgroundColor: Colors.yellowAccent,
        ),
        body: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state is TodoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TodoLoaded) {
              // Filter the list to include only favorite items
              final favoriteTodos = state.todos.where((todo) => todo['is_personal']).toList();
              
              return ListView.builder(
                itemCount: favoriteTodos.length,
                itemBuilder: (context, index) {
                  final todo = favoriteTodos[index];
                  return Card(
                    color: Colors.black,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        todo['name'] ?? 'Untitled',
                        style: const TextStyle(color: Colors.yellowAccent),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            todo['description'] ?? '',
                            style: const TextStyle(color: Colors.yellowAccent),
                          ),
                          Text(
                            todo['completed_at'] ?? '',
                            style: const TextStyle(color: Colors.yellowAccent),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              todo['is_personal']
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: todo['is_personal']
                                  ? Colors.red
                                  : Colors.yellowAccent,
                            ),
                            onPressed: () {
                              bool isPersonal = !todo['is_personal'];
                              bool isDone = !todo['is_done'];
                              context.read<TodoBloc>().add(
                                    ToggleFavorite(index: index),
                                  );
                              context.read<TodoBloc>().add(
                                    UpdateFavorite(
                                      id: todo['id'],
                                      title: todo['name'],
                                      description: todo['description'],
                                      date: todo['completed_at'],
                                      isPersonal: isPersonal,
                                      isDone: isDone,

                                    ),
                                  );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.yellowAccent),
                            onPressed: () {
                              // Navigate to the edit page
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.yellowAccent),
                            onPressed: () {
                              context
                                  .read<TodoBloc>()
                                  .add(DeleteTodo(id: todo['id']));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is TodoError) {
              return Center(child: Text(state.message));
            }

            return Container();
          },
        ),
      ),
    );
  }
}
