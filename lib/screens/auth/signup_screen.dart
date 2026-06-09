import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';

// Sign-up screen — collects name, email, campus, and password.
// On success, logs the user in automatically (same as login — saves to SharedPreferences).
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey  = GlobalKey<FormState>();

  final _nameController     = TextEditingController();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController  = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmVisible  = false;
  bool _isLoading       = false;

  // Dropdown value for campus selection
  String _selectedCampus = 'Kigali Campus';

  final List<String> _campuses = [
    'Kigali Campus',
    'Mauritius Campus',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // ── Validation helpers ────────────────────────────────────────────────────

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter your name';
    if (value.trim().length < 2) return 'Name is too short';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter your email';
    if (!value.contains('@') || !value.contains('.')) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirm(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  // ── Sign up logic ─────────────────────────────────────────────────────────

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulated delay

    await AuthService.login(
      name:   _nameController.text.trim(),
      email:  _emailController.text.trim(),
      campus: _selectedCampus,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    // After account creation, go to interests onboarding (not straight to home).
    // This personalises the feed and is a unique ALU-specific feature.
    Navigator.pushReplacementNamed(context, '/interests');
  }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Create Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header text
                Text('Join ALU Connect', style: AppTextStyles.displayMedium),
                const SizedBox(height: 6),
                Text(
                  'Connect with students across campuses',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 32),

                // ── Full Name ─────────────────────────────────────────────
                Text('Full Name', style: AppTextStyles.headingMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  validator: _validateName,
                  textCapitalization: TextCapitalization.words,
                  style: AppTextStyles.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Aline Umuhoza',
                    prefixIcon: Icon(Icons.person_outline, color: AppColors.textMuted),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Email ─────────────────────────────────────────────────
                Text('Email', style: AppTextStyles.headingMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  style: AppTextStyles.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'you@alustudent.com',
                    prefixIcon: Icon(Icons.email_outlined, color: AppColors.textMuted),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Campus ────────────────────────────────────────────────
                Text('Campus', style: AppTextStyles.headingMedium),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCampus,
                      isExpanded: true,
                      dropdownColor: AppColors.surface,
                      style: AppTextStyles.bodyLarge,
                      iconEnabledColor: AppColors.gold,
                      items: _campuses
                          .map((campus) => DropdownMenuItem(
                                value: campus,
                                child: Text(campus),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCampus = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Password ──────────────────────────────────────────────
                Text('Password', style: AppTextStyles.headingMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  validator: _validatePassword,
                  obscureText: !_passwordVisible,
                  style: AppTextStyles.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'At least 6 characters',
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textMuted,
                      ),
                      onPressed: () =>
                          setState(() => _passwordVisible = !_passwordVisible),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Confirm Password ──────────────────────────────────────
                Text('Confirm Password', style: AppTextStyles.headingMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmController,
                  validator: _validateConfirm,
                  obscureText: !_confirmVisible,
                  style: AppTextStyles.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'Repeat your password',
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _confirmVisible ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textMuted,
                      ),
                      onPressed: () =>
                          setState(() => _confirmVisible = !_confirmVisible),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Submit button ─────────────────────────────────────────
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.gold),
                      )
                    : ElevatedButton(
                        onPressed: _handleSignUp,
                        child: const Text('Create Account'),
                      ),

                const SizedBox(height: 20),

                // ── Already have account ──────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ', style: AppTextStyles.bodyMedium),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Sign in',
                        style: AppTextStyles.headingMedium.copyWith(
                          color: AppColors.gold,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.gold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
