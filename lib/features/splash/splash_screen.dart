import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// TODO: Replace with actual authentication logic later
final FutureProvider<bool> _splashDelayProvider = FutureProvider((ref) async {
  await Future.delayed(const Duration(seconds: 3));
  // Check authentication status here
  bool isAuthenticated = false; // Placeholder
  return isAuthenticated;
});

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splashDelay = ref.watch(_splashDelayProvider);

    useEffect(() {
      splashDelay.whenData((isAuthenticated) {
        // Delay navigation until after the build phase
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) { // Check if the widget is still in the tree
            if (isAuthenticated) {
              context.go('/dashboard');
            } else {
              context.go('/login');
            }
          }
        });
      });
      return null; // No cleanup needed
    }, [splashDelay]); // Rerun effect when splashDelay changes

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/svg/logo.svg', height: 50),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
