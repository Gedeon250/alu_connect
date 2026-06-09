import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';

// Login screen — split layout: branded header + floating form card.
// Google and Apple buttons are side-by-side (not stacked) to save vertical space.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey            = GlobalKey<FormState>();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();

  bool _passwordVisible = false;
  bool _isLoading       = false;

  // Nullable so that hot-reload (which preserves state but skips initState)
  // never causes a LateInitializationError.  The build method falls back to
  // "already visible" animations when these are null.
  AnimationController? _headerAnim;
  Animation<double>?   _headerFade;
  Animation<Offset>?   _headerSlide;

  @override
  void initState() {
    super.initState();
    _headerAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _headerFade = CurvedAnimation(parent: _headerAnim!, curve: Curves.easeIn);
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _headerAnim!, curve: Curves.easeOut));
    _headerAnim!.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _headerAnim?.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Please enter your email';
    if (!v.contains('@') || !v.contains('.')) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Please enter your password';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));

    final email = _emailController.text.trim();
    await AuthService.login(
      name:   AuthService.nameFromEmail(email),
      email:  email,
      campus: 'Kigali Campus',
    );

    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> _handleSocialLogin(String provider) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    await AuthService.login(
      name:   provider == 'Google' ? 'ALU Student' : 'Apple User',
      email:  'student@alueducation.com',
      campus: 'Kigali Campus',
    );

    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Branded header (38% of screen) ───────────────────────────────
          SizedBox(
            height: screenHeight * 0.38,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.surfaceElevated, AppColors.background],
                    ),
                  ),
                ),
                FadeTransition(
                  opacity: _headerFade ?? const AlwaysStoppedAnimation(1.0),
                  child: SlideTransition(
                    position: _headerSlide ?? const AlwaysStoppedAnimation(Offset.zero),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gold.withValues(alpha: 0.3),
                                blurRadius: 24,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.change_history_rounded, size: 46, color: AppColors.background),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(text: 'ALU ', style: AppTextStyles.displayMedium),
                            TextSpan(text: 'Connect', style: AppTextStyles.displayMedium.copyWith(color: AppColors.gold)),
                          ]),
                        ),
                        const SizedBox(height: 4),
                        Text('Connect. Collaborate. Lead together.', style: AppTextStyles.labelMedium),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Form card ─────────────────────────────────────────────────────
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.xl),
                  topRight: Radius.circular(AppRadius.xl),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome back', style: AppTextStyles.headingLarge),
                    const SizedBox(height: 4),
                    Text('Sign in to your ALU account', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: AppSpacing.lg),

                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email', style: AppTextStyles.headingMedium),
                          const SizedBox(height: AppSpacing.sm),
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
                          const SizedBox(height: AppSpacing.md),
                          Text('Password', style: AppTextStyles.headingMedium),
                          const SizedBox(height: AppSpacing.sm),
                          TextFormField(
                            controller: _passwordController,
                            validator: _validatePassword,
                            obscureText: !_passwordVisible,
                            style: AppTextStyles.bodyLarge,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible ? Icons.visibility_off : Icons.visibility,
                                  color: AppColors.textMuted,
                                ),
                                onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text('Forgot password?', style: AppTextStyles.labelMedium.copyWith(color: AppColors.gold)),
                            ),
                          ),
                          _isLoading
                              ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
                              : ElevatedButton.icon(
                                  onPressed: _handleLogin,
                                  icon: const Icon(Icons.school_outlined, size: 20),
                                  label: const Text('Sign in with ALU Account'),
                                ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),
                    Row(children: [
                      const Expanded(child: Divider(color: AppColors.border)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                        child: Text('or continue with', style: AppTextStyles.labelMedium),
                      ),
                      const Expanded(child: Divider(color: AppColors.border)),
                    ]),
                    const SizedBox(height: AppSpacing.md),

                    // Side-by-side social buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _handleSocialLogin('Google'),
                            icon: const Text('G', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.redAccent)),
                            label: Text('Google', style: AppTextStyles.headingMedium),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _handleSocialLogin('Apple'),
                            icon: const Icon(Icons.apple, color: AppColors.textPrimary, size: 20),
                            label: Text('Apple', style: AppTextStyles.headingMedium),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.lg),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('New here? ', style: AppTextStyles.bodyMedium),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/signup'),
                            child: Text(
                              'Create account',
                              style: AppTextStyles.headingMedium.copyWith(
                                color: AppColors.gold,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.gold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
