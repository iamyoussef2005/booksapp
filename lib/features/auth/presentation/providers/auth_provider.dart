import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUser {
  const AuthUser({
    required this.fullName,
    required this.email,
  });

  final String fullName;
  final String email;
}

class AuthState {
  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  final AuthUser? user;
  final bool isLoading;
  final String? errorMessage;

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    AuthUser? user,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  static const _emailKey = 'auth_email';
  static const _nameKey = 'auth_name';

  @override
  Future<AuthState> build() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final email = preferences.getString(_emailKey);
      final fullName = preferences.getString(_nameKey);

      if (email != null && fullName != null) {
        return AuthState(
          user: AuthUser(
            fullName: fullName,
            email: email,
          ),
        );
      }
    } catch (_) {
      // Ignore storage failures in mock auth mode.
    }

    return const AuthState();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim();

    if (normalizedEmail.isEmpty || password.trim().isEmpty) {
      state = AsyncData(
        (state.valueOrNull ?? const AuthState()).copyWith(
          errorMessage: 'Email and password are required.',
        ),
      );
      return;
    }

    state = AsyncData(
      (state.valueOrNull ?? const AuthState()).copyWith(
        isLoading: true,
        clearError: true,
      ),
    );

    await Future<void>.delayed(const Duration(milliseconds: 700));

    final user = AuthUser(
      fullName: _deriveNameFromEmail(normalizedEmail),
      email: normalizedEmail,
    );
    final nextState = AuthState(user: user);
    state = AsyncData(nextState);
    await _persistUser(user);
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final normalizedName = fullName.trim();
    final normalizedEmail = email.trim();

    if (normalizedName.isEmpty ||
        normalizedEmail.isEmpty ||
        password.trim().isEmpty ||
        confirmPassword.trim().isEmpty) {
      state = AsyncData(
        (state.valueOrNull ?? const AuthState()).copyWith(
          errorMessage: 'Please complete all fields.',
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      state = AsyncData(
        (state.valueOrNull ?? const AuthState()).copyWith(
          errorMessage: 'Passwords do not match.',
        ),
      );
      return;
    }

    state = AsyncData(
      (state.valueOrNull ?? const AuthState()).copyWith(
        isLoading: true,
        clearError: true,
      ),
    );

    await Future<void>.delayed(const Duration(milliseconds: 850));

    final user = AuthUser(
      fullName: normalizedName,
      email: normalizedEmail,
    );
    final nextState = AuthState(user: user);
    state = AsyncData(nextState);
    await _persistUser(user);
  }

  Future<void> signOut() async {
    state = const AsyncData(AuthState());

    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.remove(_emailKey);
      await preferences.remove(_nameKey);
    } catch (_) {
      // Ignore storage failures in mock auth mode.
    }
  }

  void clearError() {
    final current = state.valueOrNull ?? const AuthState();
    state = AsyncData(current.copyWith(clearError: true));
  }

  Future<void> _persistUser(AuthUser user) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(_emailKey, user.email);
      await preferences.setString(_nameKey, user.fullName);
    } catch (_) {
      // Ignore storage failures in mock auth mode.
    }
  }

  String _deriveNameFromEmail(String email) {
    final localPart = email.split('@').first;
    if (localPart.isEmpty) {
      return 'Reader';
    }

    final formatted = localPart.replaceAll(RegExp(r'[._-]+'), ' ').trim();
    return formatted
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map(
          (part) => '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
