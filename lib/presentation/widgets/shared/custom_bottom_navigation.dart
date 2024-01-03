import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  const CustomBottomNavigation({super.key, required this.currentIndex});

  void onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
       context.go('/home/0');
      break;
      case 1:
       context.go('/home/1');
      break;
      case 2: 
       context.go('/home/2');
      break;
    }

  }

  @override
  Widget build(BuildContext context) {
    print(currentIndex);
    return BottomNavigationBar(
        elevation: 0,
        currentIndex: currentIndex,
        onTap: (index) => onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_max),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.label_outline),
            label: 'Categorias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Favoritos',
          ),
        ]);
  }
}
