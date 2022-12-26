import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:relay/screens/dashboard/account_screen.dart';
import 'package:relay/screens/dashboard/chat_screen.dart';
import 'package:relay/screens/dashboard/home_screen.dart';

class HelperScreen extends StatefulWidget {
  const HelperScreen({super.key});

  @override
  State<HelperScreen> createState() => _HelperScreenState();
}

class _HelperScreenState extends State<HelperScreen> {
  final screens = [HomeScreen(), ChatScreen(), AccountSCreen()];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        height: 60,
        backgroundColor: Colors.white,
        destinations: [
          NavigationDestination(
              icon: FaIcon(FontAwesomeIcons.dashboard), label: 'Feed'),
          NavigationDestination(
              icon: FaIcon(FontAwesomeIcons.chartBar), label: 'Chats'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Account'),
        ],
        onDestinationSelected: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        selectedIndex: _currentIndex,
      ),
    );
  }
}
