import 'package:flutter/material.dart';
import 'package:cervical_cancer_flutter_app/constants.dart';
import 'package:provider/provider.dart';
import 'package:cervical_cancer_flutter_app/services/auth_service.dart';
import 'package:cervical_cancer_flutter_app/screens/login_screen.dart';
import 'package:cervical_cancer_flutter_app/screens/prediction_form_screen.dart';
import 'package:cervical_cancer_flutter_app/screens/history_screen.dart';
import 'package:cervical_cancer_flutter_app/screens/about_screen.dart';
import 'package:cervical_cancer_flutter_app/screens/guide_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Map<String, dynamic>> _navItems = [
    {'title': 'الرئيسية', 'icon': Icons.home, 'widget': PredictionFormScreen()},
    {'title': 'السجل', 'icon': Icons.history, 'widget': HistoryScreen()},
    {'title': 'الدليل', 'icon': Icons.menu_book, 'widget': GuideScreen()},
    {'title': 'عن البرنامج', 'icon': Icons.info, 'widget': AboutScreen()},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // إغلاق الـ Drawer بعد الاختيار
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDarkColor,
        foregroundColor: Colors.white,
        title: const Text('🏥 تطبيق التنبؤ بسرطان الرحم', style: TextStyle(color: Colors.white)),
        centerTitle: false,
        elevation: 4,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: kDarkColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'قائمة التنقل',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'مرحباً، ${authService.userEmail ?? 'مستخدم'}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ..._navItems.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> item = entry.value;
              return ListTile(
                leading: Icon(item['icon'], color: _selectedIndex == index ? kPrimaryColor : kDarkColor),
                title: Text(item['title'], style: TextStyle(color: _selectedIndex == index ? kPrimaryColor : kDarkColor)),
                selected: _selectedIndex == index,
                onTap: () => _onItemTapped(index),
              );
            }).toList(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: kLogoutColor),
              title: const Text('تسجيل الخروج', style: TextStyle(color: kLogoutColor)),
              onTap: () async {
                await authService.logout();
                if (mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: _navItems[_selectedIndex]['widget'],
      ),
    );
  }
}
