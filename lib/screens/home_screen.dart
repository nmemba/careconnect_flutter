import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../config/theme.dart';

class HomeScreen extends StatefulWidget {
  final Widget child;

  const HomeScreen({super.key, required this.child});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<_NavItem> _navItems = [
    _NavItem(path: '/', icon: Icons.home, label: 'Today'),
    _NavItem(path: '/medications', icon: Icons.medication, label: 'Meds'),
    _NavItem(path: '/calendar', icon: Icons.calendar_today, label: 'Calendar'),
    _NavItem(path: '/communications', icon: Icons.chat_bubble_outline, label: 'Messages'),
    _NavItem(path: '/settings', icon: Icons.settings, label: 'Settings'),
  ];

  void _onNavItemTapped(int index) {
    setState(() => _currentIndex = index);
    context.go(_navItems[index].path);
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    // Update current index based on current route
    final currentLocation = GoRouterState.of(context).uri.path;
    final newIndex = _navItems.indexWhere((item) => 
      currentLocation == item.path || 
      (item.path != '/' && currentLocation.startsWith(item.path))
    );
    if (newIndex != -1 && newIndex != _currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _currentIndex = newIndex);
        }
      });
    }

    return Scaffold(
      backgroundColor: AppTheme.grayBg,
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.grayBorder),
          ),
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onNavItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: AppTheme.grayMedium,
            selectedFontSize: isLandscape ? 14 : 12,
            unselectedFontSize: isLandscape ? 14 : 12,
            iconSize: isLandscape ? 20 : 24,
            items: _navItems.map((item) {
              return BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: isLandscape ? 0 : 4),
                  child: Icon(item.icon),
                ),
                label: item.label,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String path;
  final IconData icon;
  final String label;

  _NavItem({
    required this.path,
    required this.icon,
    required this.label,
  });
}
