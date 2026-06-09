import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController? _logoController;
  AnimationController? _textController;

  Animation<double>? _logoScale;
  Animation<double>? _logoFade;
  Animation<double>? _textFade;
  Animation<Offset>?  _textSlide;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _logoController!, curve: Curves.elasticOut),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController!,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController!, curve: Curves.easeIn),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController!, curve: Curves.easeOut));

    _logoController!.forward().then((_) {
      _textController!.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 1200), _checkLoginState);
      });
    });
  }

  Future<void> _checkLoginState() async {
    final loggedIn = await AuthService.isLoggedIn();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, loggedIn ? '/home' : '/login');
  }

  @override
  void dispose() {
    _logoController?.dispose();
    _textController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _logoController ?? const AlwaysStoppedAnimation(1.0),
                builder: (_, __) => FadeTransition(
                  opacity: _logoFade ?? const AlwaysStoppedAnimation(1.0),
                  child: Transform.scale(
                    scale: _logoScale?.value ?? 1.0,
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold.withValues(alpha: 0.35),
                            blurRadius: 32,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.change_history_rounded,
                        size: 60,
                        color: AppColors.background,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              FadeTransition(
                opacity: _textFade ?? const AlwaysStoppedAnimation(1.0),
                child: SlideTransition(
                  position: _textSlide ?? const AlwaysStoppedAnimation(Offset.zero),
                  child: Column(
                    children: [
                      Text('ALU', style: AppTextStyles.displayLarge.copyWith(letterSpacing: 3)),
                      Text('Intercampus', style: AppTextStyles.bodyMedium.copyWith(fontSize: 16)),
                      Text('Connect', style: AppTextStyles.displayMedium.copyWith(color: AppColors.gold)),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Connect. Collaborate. Lead together.', style: AppTextStyles.labelMedium),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              FadeTransition(
                opacity: _textFade ?? const AlwaysStoppedAnimation(1.0),
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: AppColors.gold, strokeWidth: 2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
