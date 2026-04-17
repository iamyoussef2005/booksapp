import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_icon.dart';
import '../providers/auth_provider.dart';

enum AuthMode { signIn, signUp }

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _signInEmailController = TextEditingController();
  final _signInPasswordController = TextEditingController();
  final _signUpNameController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _signUpConfirmController = TextEditingController();

  AuthMode _mode = AuthMode.signIn;
  bool _hideSignInPassword = true;
  bool _hideSignUpPassword = true;
  bool _hideSignUpConfirm = true;

  @override
  void dispose() {
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    _signUpNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _signUpConfirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final notifier = ref.read(authProvider.notifier);

    if (_mode == AuthMode.signIn) {
      await notifier.signIn(
        email: _signInEmailController.text,
        password: _signInPasswordController.text,
      );
      return;
    }

    await notifier.signUp(
      fullName: _signUpNameController.text,
      email: _signUpEmailController.text,
      password: _signUpPasswordController.text,
      confirmPassword: _signUpConfirmController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider).valueOrNull ?? const AuthState();

    ref.listen(authProvider, (previous, next) {
      final message = next.valueOrNull?.errorMessage;
      if (message != null && message.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        ref.read(authProvider.notifier).clearError();
      }
    });

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8F0E6),
              Color(0xFFE9D7C5),
              Color(0xFFD8B394),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: -40,
              top: 90,
              child: _GlowOrb(
                size: 180,
                color: Colors.white.withValues(alpha: 0.22),
              ),
            ),
            Positioned(
              right: -30,
              top: 30,
              child: _GlowOrb(
                size: 140,
                color: Colors.white.withValues(alpha: 0.16),
              ),
            ),
            Positioned(
              right: -20,
              bottom: 140,
              child: _GlowOrb(
                size: 200,
                color: AppColors.primary.withValues(alpha: 0.10),
              ),
            ),
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 540),
                  child: SingleChildScrollView(
                    padding: AppSpacing.screenPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppColors.primaryDark,
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusMd,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const AppIcon(
                                HugeIcons.strokeRoundedBookOpen01,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            AppSpacing.gapWsm,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Book Shop',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                  Text(
                                    'Curated reads, cozy corners, and smart discovery',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.gapXl,
                        Text(
                          _mode == AuthMode.signIn
                              ? 'Welcome back to your reading ritual.'
                              : 'Create your reader profile and step into the shop.',
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: AppColors.primaryDark,
                          ),
                        ),
                        AppSpacing.gapSm,
                        Text(
                          _mode == AuthMode.signIn
                              ? 'Sign in to continue exploring saved books, preferences, and your growing library.'
                              : 'Sign up in seconds with mock auth and start exploring the full bookstore experience.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        AppSpacing.gapXl,
                        Container(
                          padding: AppSpacing.cardPadding,
                          decoration: BoxDecoration(
                            color: theme.cardTheme.color,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusLg,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shadow,
                                blurRadius: 28,
                                offset: Offset(0, 16),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.xs),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceSoft,
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusXl,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    _ModeChip(
                                      label: 'Sign In',
                                      selected: _mode == AuthMode.signIn,
                                      onTap: () {
                                        setState(() => _mode = AuthMode.signIn);
                                      },
                                    ),
                                    _ModeChip(
                                      label: 'Sign Up',
                                      selected: _mode == AuthMode.signUp,
                                      onTap: () {
                                        setState(() => _mode = AuthMode.signUp);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              AppSpacing.gapLg,
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 280),
                                switchInCurve: Curves.easeOutCubic,
                                switchOutCurve: Curves.easeInCubic,
                                child: _mode == AuthMode.signIn
                                    ? _SignInForm(
                                        key: const ValueKey('sign-in-form'),
                                        emailController: _signInEmailController,
                                        passwordController:
                                            _signInPasswordController,
                                        hidePassword: _hideSignInPassword,
                                        onTogglePassword: () {
                                          setState(() {
                                            _hideSignInPassword =
                                                !_hideSignInPassword;
                                          });
                                        },
                                      )
                                    : _SignUpForm(
                                        key: const ValueKey('sign-up-form'),
                                        nameController: _signUpNameController,
                                        emailController: _signUpEmailController,
                                        passwordController:
                                            _signUpPasswordController,
                                        confirmController:
                                            _signUpConfirmController,
                                        hidePassword: _hideSignUpPassword,
                                        hideConfirm: _hideSignUpConfirm,
                                        onTogglePassword: () {
                                          setState(() {
                                            _hideSignUpPassword =
                                                !_hideSignUpPassword;
                                          });
                                        },
                                        onToggleConfirm: () {
                                          setState(() {
                                            _hideSignUpConfirm =
                                                !_hideSignUpConfirm;
                                          });
                                        },
                                      ),
                              ),
                              AppSpacing.gapLg,
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: authState.isLoading ? null : _submit,
                                  child: authState.isLoading
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          _mode == AuthMode.signIn
                                              ? 'Enter Book Shop'
                                              : 'Create Mock Account',
                                        ),
                                ),
                              ),
                              AppSpacing.gapSm,
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _mode = _mode == AuthMode.signIn
                                          ? AuthMode.signUp
                                          : AuthMode.signIn;
                                    });
                                  },
                                  child: Text(
                                    _mode == AuthMode.signIn
                                        ? 'New here? Create an account'
                                        : 'Already have an account? Sign in',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignInForm extends StatelessWidget {
  const _SignInForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.hidePassword,
    required this.onTogglePassword,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool hidePassword;
  final VoidCallback onTogglePassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LabelText('Email'),
        AppSpacing.gapXs,
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.all(12),
              child: AppIcon(HugeIcons.strokeRoundedProfile, size: 20),
            ),
            hintText: 'reader@example.com',
          ),
        ),
        AppSpacing.gapMd,
        _LabelText('Password'),
        AppSpacing.gapXs,
        TextField(
          controller: passwordController,
          obscureText: hidePassword,
          decoration: InputDecoration(
            prefixIcon: const Padding(
              padding: EdgeInsets.all(12),
              child: AppIcon(HugeIcons.strokeRoundedBookLock, size: 20),
            ),
            hintText: 'Enter your password',
            suffixIcon: IconButton(
              onPressed: onTogglePassword,
              icon: AppIcon(
                hidePassword
                    ? HugeIcons.strokeRoundedViewOff
                    : HugeIcons.strokeRoundedView,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SignUpForm extends StatelessWidget {
  const _SignUpForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmController,
    required this.hidePassword,
    required this.hideConfirm,
    required this.onTogglePassword,
    required this.onToggleConfirm,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final bool hidePassword;
  final bool hideConfirm;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirm;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LabelText('Full Name'),
        AppSpacing.gapXs,
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.all(12),
              child: AppIcon(HugeIcons.strokeRoundedUserCircle, size: 20),
            ),
            hintText: 'Aseel T.',
          ),
        ),
        AppSpacing.gapMd,
        _LabelText('Email'),
        AppSpacing.gapXs,
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.all(12),
              child: AppIcon(HugeIcons.strokeRoundedProfile, size: 20),
            ),
            hintText: 'reader@example.com',
          ),
        ),
        AppSpacing.gapMd,
        _LabelText('Password'),
        AppSpacing.gapXs,
        TextField(
          controller: passwordController,
          obscureText: hidePassword,
          decoration: InputDecoration(
            prefixIcon: const Padding(
              padding: EdgeInsets.all(12),
              child: AppIcon(HugeIcons.strokeRoundedBookLock, size: 20),
            ),
            hintText: 'Create a password',
            suffixIcon: IconButton(
              onPressed: onTogglePassword,
              icon: AppIcon(
                hidePassword
                    ? HugeIcons.strokeRoundedViewOff
                    : HugeIcons.strokeRoundedView,
                size: 20,
              ),
            ),
          ),
        ),
        AppSpacing.gapMd,
        _LabelText('Confirm Password'),
        AppSpacing.gapXs,
        TextField(
          controller: confirmController,
          obscureText: hideConfirm,
          decoration: InputDecoration(
            prefixIcon: const Padding(
              padding: EdgeInsets.all(12),
              child: AppIcon(HugeIcons.strokeRoundedBookCheck, size: 20),
            ),
            hintText: 'Repeat your password',
            suffixIcon: IconButton(
              onPressed: onToggleConfirm,
              icon: AppIcon(
                hideConfirm
                    ? HugeIcons.strokeRoundedViewOff
                    : HugeIcons.strokeRoundedView,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LabelText extends StatelessWidget {
  const _LabelText(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
          ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: selected ? Theme.of(context).colorScheme.primary : null,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: selected
                  ? Theme.of(context).colorScheme.onPrimary
                  : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
