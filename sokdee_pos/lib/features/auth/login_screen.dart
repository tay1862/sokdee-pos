import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sokdee_pos/core/auth/auth_provider.dart';
import 'package:sokdee_pos/core/auth/auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _tenantController = TextEditingController();
  final _usernameController = TextEditingController();
  String _pin = '';
  bool _isLoading = false;
  String? _errorMessage;

  static const _maxPinLength = 6;
  static const _minPinLength = 4;

  @override
  void dispose() {
    _tenantController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _onDigitTap(String digit) {
    if (_pin.length >= _maxPinLength) return;
    setState(() {
      _pin += digit;
      _errorMessage = null;
    });
    if (_pin.length >= _minPinLength) {
      // Auto-submit when PIN reaches minimum length and fields are filled
    }
  }

  void _onBackspace() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  void _onClear() => setState(() => _pin = '');

  Future<void> _onLogin() async {
    if (_tenantController.text.isEmpty || _usernameController.text.isEmpty) {
      setState(() => _errorMessage = 'กรุณากรอก Tenant ID และ Username');
      return;
    }
    if (_pin.length < _minPinLength) {
      setState(() => _errorMessage = 'PIN ต้องมีอย่างน้อย 4 หลัก');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await ref.read(authProvider.notifier).login(
          tenantId: _tenantController.text.trim(),
          username: _usernameController.text.trim(),
          pin: _pin,
          deviceId: 'device-placeholder', // replaced by real device ID in task 3.5
        );

    if (!mounted) return;

    final authState = ref.read(authProvider).valueOrNull;
    if (authState is AuthError) {
      setState(() {
        _errorMessage = authState.message;
        _pin = '';
        _isLoading = false;
      });
    } else if (authState is AuthAuthenticated) {
      final role = authState.role;
      context.go(role == 'super_admin' ? '/super-admin' : '/pos');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo / Title
                  Text(
                    'SOKDEE POS',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ລະບົບຈັດການຮ້ານຄ້າ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Tenant ID field
                  TextField(
                    controller: _tenantController,
                    decoration: const InputDecoration(
                      labelText: 'Tenant ID',
                      prefixIcon: Icon(Icons.store_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),

                  // Username field
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 24),

                  // PIN dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _maxPinLength,
                      (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i < _pin.length
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Error message
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: theme.colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // PIN numpad
                  _PinNumpad(
                    onDigit: _onDigitTap,
                    onBackspace: _onBackspace,
                    onClear: _onClear,
                  ),
                  const SizedBox(height: 24),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _onLogin,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('ເຂົ້າສູ່ລະບົບ / เข้าสู่ระบบ'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PinNumpad extends StatelessWidget {
  const _PinNumpad({
    required this.onDigit,
    required this.onBackspace,
    required this.onClear,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.8,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        ...['1', '2', '3', '4', '5', '6', '7', '8', '9'].map(
          (d) => _NumpadButton(label: d, onTap: () => onDigit(d)),
        ),
        _NumpadButton(label: 'C', onTap: onClear, isAction: true),
        _NumpadButton(label: '0', onTap: () => onDigit('0')),
        _NumpadButton(
          label: '⌫',
          onTap: onBackspace,
          isAction: true,
        ),
      ],
    );
  }
}

class _NumpadButton extends StatelessWidget {
  const _NumpadButton({
    required this.label,
    required this.onTap,
    this.isAction = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: isAction
            ? theme.colorScheme.secondary
            : theme.colorScheme.onSurface,
      ),
      child: Text(
        label,
        style: theme.textTheme.titleLarge,
      ),
    );
  }
}
