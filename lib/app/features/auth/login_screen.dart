import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/di.dart';
import '../../theme/theme_colors.dart';
import 'bloc/bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _auth = getIt<AuthBloc>();

  bool _isLogin = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (_isLogin) {
      _auth.add(AuthSignInRequested(email: email, password: password));
    } else {
      _auth.add(
        AuthSignUpRequested(
          email: email,
          password: password,
          displayName: _nameController.text.trim(),
        ),
      );
    }
  }

  void _resetPassword() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage('Сначала введите адрес электронной почты');
      return;
    }

    _auth.add(AuthPasswordResetRequested(email: email));
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _switchMode(bool isLogin) {
    if (_isLogin == isLogin) return;

    setState(() {
      _isLogin = isLogin;
      _formKey.currentState?.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/cyberpunk2077.jpg', fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(10, 16, 24, 0.92),
                  Color.fromRGBO(20, 52, 78, 0.82),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: BlocConsumer<AuthBloc, AuthState>(
                    bloc: _auth,
                    listenWhen: (previous, current) {
                      return current is AuthPasswordResetSent ||
                          current is AuthUnauthenticated &&
                              current.error != null &&
                              previous is AuthUnauthenticated &&
                              previous.error != current.error;
                    },
                    listener: (context, state) {
                      if (state is AuthPasswordResetSent) {
                        _showMessage(
                          'Письмо для сброса пароля отправлено на почту',
                        );
                      } else if (state is AuthUnauthenticated &&
                          state.error != null) {
                        _showMessage(state.error!);
                      }
                    },
                    builder: (context, state) {
                      final isLoading =
                          state is AuthUnauthenticated && state.isLoading;

                      return _AuthCard(
                        formKey: _formKey,
                        isLogin: _isLogin,
                        isLoading: isLoading,
                        obscurePassword: _obscurePassword,
                        nameController: _nameController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        onSwitchMode: _switchMode,
                        onTogglePassword: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        onSubmit: _submit,
                        onResetPassword: _resetPassword,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({
    required this.formKey,
    required this.isLogin,
    required this.isLoading,
    required this.obscurePassword,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.onSwitchMode,
    required this.onTogglePassword,
    required this.onSubmit,
    required this.onResetPassword,
  });

  final GlobalKey<FormState> formKey;
  final bool isLogin;
  final bool isLoading;
  final bool obscurePassword;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ValueChanged<bool> onSwitchMode;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;
  final VoidCallback onResetPassword;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 18,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.sports_esports_rounded,
                size: 54,
                color: ThemeColors.accent,
              ),
              const SizedBox(height: 12),
              Text(
                'GameVault',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: ThemeColors.black,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isLogin
                    ? 'Войдите, чтобы синхронизировать избранные игры'
                    : 'Создайте аккаунт для облачного избранного',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _ModeButton(
                        label: 'Вход',
                        selected: isLogin,
                        onTap: isLoading ? null : () => onSwitchMode(true),
                      ),
                    ),
                    Expanded(
                      child: _ModeButton(
                        label: 'Регистрация',
                        selected: !isLogin,
                        onTap: isLoading ? null : () => onSwitchMode(false),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (!isLogin) ...[
                TextFormField(
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Имя',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Укажите имя';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
              ],
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Электронная почта',
                  prefixIcon: Icon(Icons.alternate_email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final email = value?.trim() ?? '';
                  final isValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                      .hasMatch(email);

                  if (!isValid) return 'Введите корректный адрес почты';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => onSubmit(),
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: onTogglePassword,
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Пароль должен содержать не менее 6 символов';
                  }
                  return null;
                },
              ),
              if (isLogin)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: isLoading ? null : onResetPassword,
                    child: const Text('Забыли пароль?'),
                  ),
                )
              else
                const SizedBox(height: 8),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: isLoading ? null : onSubmit,
                style: FilledButton.styleFrom(
                  backgroundColor: ThemeColors.accent,
                  minimumSize: const Size.fromHeight(52),
                ),
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(isLogin ? Icons.login : Icons.person_add_alt_1),
                label: Text(isLogin ? 'Войти' : 'Зарегистрироваться'),
              ),
              const SizedBox(height: 16),
              Text(
                'Данные пользователя и избранные игры хранятся в Firebase.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        borderRadius: BorderRadius.circular(11),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? ThemeColors.accent : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}
