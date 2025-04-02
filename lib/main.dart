import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobilecalorietrackers/core/router/app_router.dart';
import 'package:mobilecalorietrackers/core/theme/app_theme.dart';
import 'package:mobilecalorietrackers/features/user/providers/user_provider.dart';
import 'package:mobilecalorietrackers/features/food/models/food_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(FoodEntryAdapter());
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil. Must be done *before* MaterialApp
    // Set the design size (e.g., based on Figma design or a common device)
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Example iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // Use MaterialApp.router for go_router
        return MaterialApp.router(
          title: 'FitCount Calorie Tracker',
          theme: AppTheme.lightTheme, // Apply the custom theme
          // darkTheme: AppTheme.darkTheme, // Optional: Add dark theme
          // themeMode: ThemeMode.system, // Or manage theme mode via a provider
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router, // Pass the router configuration
          // No need for 'home' when using routerConfig
        );
      },
    );
  }
}
