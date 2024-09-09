import 'package:flutter/material.dart';
import 'package:flutter_application_todo/todo_bloc/todo_bloc_event.dart';
import 'package:flutter_application_todo/todo_bloc/todo_bloc_state.dart';
import 'package:flutter_application_todo/widgets/add_todo.dart';
import 'package:flutter_application_todo/widgets/edit_todo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_todo/todo_bloc/todo_bloc.dart';

class CompletedTodo extends StatelessWidget {
  const CompletedTodo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            int completeCount = 0;
            if (state is TodoLoaded) {
              // Count only completed tasks where is_done == true
              completeCount = state.todos
                  .where((todo) => todo['is_done'] ?? false)
                  .length;
            }
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Completed Tasks'),
                Chip(
                  label: Text(
                    '$completeCount',
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
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is TodoSuccess) {
            context.read<TodoBloc>().add(LoadTodos());
          }
        },
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            // Filter todos where is_done is true (completed tasks)
            final completedTodos = state.todos
                .where((todo) => todo['is_done'] ?? false)
                .toList();

            if (completedTodos.isEmpty) {
              return const Center(child: Text('No completed tasks.'));
            }

            return ListView.builder(
              itemCount: completedTodos.length,
              itemBuilder: (context, index) {
                final todo = completedTodos[index];
                return Container(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Card(
                    color: Colors.black,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BlocBuilder<TodoBloc, TodoState>(
                            builder: (context, state) {
                              return Checkbox(
                                value: todo['is_done'] ?? false,
                                onChanged: (value) {
                                  bool isPersonal = todo['is_personal'];
                                  bool isDone = !(todo['is_done'] ?? false);
                                  context.read<TodoBloc>().add(
                                        UpdateTodo(
                                          id: todo['id'],
                                          title: todo['name'],
                                          description: todo['description'],
                                          date: todo['completed_at'],
                                          isPersonal: isPersonal,
                                          isDone: isDone,
                                        ),
                                      );
                                },
                                checkColor: Colors.black,
                                activeColor: Colors.yellowAccent,
                              );
                            },
                          ),
                          const Flexible(
                            child: Text(
                              'Completed',
                              style: TextStyle(
                                fontSize: 7,
                                color: Colors.yellowAccent,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
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
                              bool isDone = todo['is_done'] ?? false;
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
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25.0)),
                                ),
                                builder: (context) => FractionallySizedBox(
                                  heightFactor: 0.75,
                                  child: EditTodo(
                                    todo: todo,
                                  ),
                                ),
                              );
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            builder: (context) => const FractionallySizedBox(
              heightFactor: 0.75,
              child: AddTodoPage(
                todo: {},
              ),
            ),
          );

          if (result == true) {
            // ignore: use_build_context_synchronously
            context.read<TodoBloc>().add(LoadTodos());
          }
        },
        backgroundColor: Colors.yellowAccent,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
