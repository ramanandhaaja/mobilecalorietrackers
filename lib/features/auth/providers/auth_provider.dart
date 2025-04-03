import 'package:hooks_riverpod/hooks_riverpod.dart';
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
  bool _initialized = false;
  final IAuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState.initial()) {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    if (_initialized) return;
    _initialized = true;

    try {
      final hasToken = await _repository.hasValidToken();
      if (hasToken) {
        state = state.copyWith(isAuthenticated: true, isLoading: false);
      }
    } catch (e) {
      // If there's an error checking the token, we'll just treat it as not authenticated
      state = state.copyWith(isAuthenticated: false, isLoading: false);
    }
  }

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
