import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobilecalorietrackers/features/user/models/user_details.dart';
import 'package:mobilecalorietrackers/features/user/repositories/user_repository.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize in main.dart');
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final userRepositoryProvider = Provider<IUserRepository>((ref) {
  return UserRepository(
    dio: Dio(),
    prefs: ref.watch(sharedPreferencesProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});

final userDetailsProvider =
    StateNotifierProvider<UserDetailsNotifier, AsyncValue<UserDetails?>>((ref) {
  return UserDetailsNotifier(ref.watch(userRepositoryProvider));
});

class UserDetailsNotifier extends StateNotifier<AsyncValue<UserDetails?>> {
  final IUserRepository _repository;

  UserDetailsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _initializeUserDetails();
  }

  Future<void> _initializeUserDetails() async {
    try {
      final localDetails = await _repository.getLocalUserDetails();
      if (localDetails != null) {
        state = AsyncValue.data(localDetails);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> loadUserDetails() async {
    try {
      state = const AsyncValue.loading();
      final details = await _repository.getUserDetails();
      
      if (details != null) {
        state = AsyncValue.data(details);
        return true;
      } else {
        state = const AsyncValue.data(null);
        return false;
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<void> clearUserDetails() async {
    await _repository.clearLocalUserDetails();
    state = const AsyncValue.data(null);
  }
}
