import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilecalorietrackers/features/auth/repositories/auth_repository.dart';
import 'package:mobilecalorietrackers/features/auth/models/login_response.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository();
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState.initial());

  Future<void> login(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final loginResponse = await _repository.login(email, password);
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        error: null,
        loginResponse: loginResponse,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isAuthenticated: false,
      );
      rethrow;
    }

  }

  Future<void> logout() async {
    await _repository.logout();
    state = AuthState.initial();
  }
}

class AuthState {
  final LoginResponse? loginResponse;
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;

  AuthState({
    this.loginResponse,
    required this.isLoading,
    required this.isAuthenticated,
    this.error,
  });

  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      isAuthenticated: false,
      error: null,
      loginResponse: null,
    );
  }

  AuthState copyWith({
    LoginResponse? loginResponse,
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error ?? this.error,
      loginResponse: loginResponse ?? this.loginResponse,
    );
  }
}
