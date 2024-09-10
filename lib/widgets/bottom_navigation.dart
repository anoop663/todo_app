import 'package:flutter/material.dart';
import 'package:flutter_application_todo/todo_bloc/navig_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_todo/widgets/completed_todo.dart';
import 'package:flutter_application_todo/widgets/list_todo_page.dart';
import 'package:flutter_application_todo/widgets/myfav_todo.dart';

class BottomNavigate extends StatelessWidget {
  
  final PageController _pageController = PageController();

  BottomNavigate({super.key});

  void _onBottomNavTapped(BuildContext context, int index) {
    _pageController.jumpToPage(index);
    context.read<NavigationCubit>().updateIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          context.read<NavigationCubit>().updateIndex(index);
        },
        children: const [
          TodoListPage(),
          MyFav(),
          CompletedTodo(),
        ],
      ),
      bottomNavigationBar: BlocBuilder<NavigationCubit, int>(
        builder: (context, selectedIndex) {
          return BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) => _onBottomNavTapped(context, index),
            backgroundColor: Colors.yellowAccent,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black54,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Pending',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle),
                label: 'completed',
              ),
            ],
          );
        },
      ),
    );
  }
}
