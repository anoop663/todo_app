import 'package:flutter/material.dart';
import 'package:flutter_application_todo/widgets/completed_todo.dart';
import 'package:flutter_application_todo/widgets/list_todo_page.dart';
import 'package:flutter_application_todo/widgets/myfav_todo.dart';

class BottomNavigate extends StatefulWidget {
  const BottomNavigate({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavigate createState() => _BottomNavigate();
}

class _BottomNavigate extends State<BottomNavigate> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onBottomNavTapped(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: const [
          TodoListPage(),
           MyFav(),
           CompletedTodo(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        backgroundColor: Colors.yellowAccent,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Completed',
          ),
        ],
      ),
    );
  }
}
