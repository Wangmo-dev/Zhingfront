import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_providers.dart';
import 'package:frontend/screens/User_reportPage.dart';
import 'package:frontend/screens/ag_community.dart';
import 'package:frontend/screens/ag_home.dart';
import 'package:frontend/screens/ag_profile_page.dart';
import 'package:frontend/screens/ag_scannedData.dart';
import 'package:frontend/screens/edit_agronomist_profile.dart';
import 'package:frontend/screens/far_notification.dart';
import 'package:frontend/screens/far_profilePage.dart';
import 'package:provider/provider.dart';

import 'package:frontend/screens/adminreport_page.dart';
import 'package:frontend/screens/community.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/reset_password.dart';
import 'package:frontend/screens/scan_page.dart';
import 'package:frontend/screens/signup.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}
/* ─────────────────────────── MyApp ──────────────────────────── */

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agri App',
      theme: ThemeData(primarySwatch: Colors.green),

      /* -------- initial screen: if logged in, jump to /homepage -------- */
      initialRoute:
          context.read<AuthProvider>().isLoggedIn ? '/homepage' : '/login',

      /* -------- custom routes with arguments -------- */
      onGenerateRoute: (settings) {
        /* Reset‑password — keeps your existing arg handling */
        if (settings.name == '/reset_password') {
          final email =
              (settings.arguments as Map<String, dynamic>?)?['email'] ?? '';
          return MaterialPageRoute(
            builder: (_) => ResetPasswordPage(email: email),
          );
        }

        /* You can add more dynamic routes here */
        return null; // fall back to routes below
      },

      /* -------- simple routes -------- */
      routes: {
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignupScreen(),
        // '/homepage': (_) => const HomePage(),

        // '/homepage':
        //     (_) => Consumer<AuthProvider>(
        //       builder:
        //           (_, auth, __) =>
        //               auth.role == 'admin'
        //                   ? const HomePage2()
        //                   : const HomePage(),
        //     ),
        '/homepage': (_) => Consumer<AuthProvider>(
  builder: (_, auth, __) {
    print('[DEBUG] role: ${auth.role}, cid: ${auth.cid}');
    if (auth.role == 'superadmin' && auth.cid == '686a38d8b8551fd33914133f') {
      return const SuperAdminPage(); // 👈 Add this
    } else if (auth.role == 'admin') {
      return const HomePage2();
    } else {
      return const HomePage();
    }
  },
),

        /* Report page now decides using AuthProvider.role */
        '/report':
            (_) => Consumer<AuthProvider>(
              builder:
                  (_, auth, __) =>
                      auth.role == 'admin'
                          ? const AdminReportPage()
                          : const UserReportPage(),
            ),

        '/scan': (_) => const ScanPage(),
        // '/support': (_) => const CommunityPage(),
        '/support':
            (_) => Consumer<AuthProvider>(
              builder:
                  (_, auth, __) =>
                      auth.role == 'admin'
                          ? const CommunityPage2()
                          : const CommunityPage(),
            ),

        /* placeholders */
        '/agronomist_profile': (_) => const PlaceholderPage(title: 'Profile'),
        '/groupP': (_) => const PlaceholderPage(title: 'Potato Growers Group'),
        '/groupR':
            (_) => const PlaceholderPage(title: 'Rice Cultivators Group'),
        '/groupM': (_) => const PlaceholderPage(title: 'Maize Farmers Group'),

        '/a_agronomist_profile': (context) => AgronomistProfilePage2(),
          '/edit_profile': (context) => EditAgronomistProfilePage(),
          '/f_profile':(context)=> ProfilePage(),
          '/f_alert':(context)=> NotificationPage(),

      },
    );
  }
}

/* ───────────────────── simple placeholder page ───────────────────── */

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: Text('$title Page')),
  );
}
