import 'package:flutter/material.dart';
import 'package:flutter_application_todo/todo_bloc/todo_bloc_event.dart';
import 'package:flutter_application_todo/todo_bloc/todo_bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_todo/todo_bloc/todo_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';

class EditTodo extends StatelessWidget {
  final Map<String, dynamic> todo;

  const EditTodo({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController(text: todo['name']);
    final _descriptionController = TextEditingController(text: todo['description']);
    final _dateController = TextEditingController(text: todo['completed_at']);
    final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo'),
        backgroundColor: Colors.yellowAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<TodoBloc, TodoState>(
          listener: (context, state) {
            if (state is TodoSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              Navigator.of(context).pop();
            } else if (state is TodoError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state is FormState1) {
                _nameController.text = state.title;
                _descriptionController.text = state.description;
                _dateController.text = state.date;
              }

              return Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    onChanged: (value) {
                      context.read<TodoBloc>().add(FormUpdated(
                            title: value,
                            description: _descriptionController.text,
                            date: _dateController.text,
                          ));
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    onChanged: (value) {
                      context.read<TodoBloc>().add(FormUpdated(
                            title: _nameController.text,
                            description: value,
                            date: _dateController.text,
                          ));
                    },
                  ),
                  TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(labelText: 'Due date'),
                    readOnly: true,
                    onTap: () {
                      DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        onConfirm: (date) {
                          final formattedDate = _dateFormat.format(date);
                          _dateController.text = formattedDate;
                          context.read<TodoBloc>().add(FormUpdated(
                                title: _nameController.text,
                                description: _descriptionController.text,
                                date: _dateController.text,
                              ));
                        },
                        currentTime: DateTime.now(),
                        locale: LocaleType.en,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final date = DateTime.tryParse(_dateController.text);
                      if (date != null) {
                        context.read<TodoBloc>().add(
                          UpdateTodo(
                            id: todo['id'],
                            title: _nameController.text,
                            description: _descriptionController.text,
                            date: _dateFormat.format(date),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invalid date format')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellowAccent,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Update Todo'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
