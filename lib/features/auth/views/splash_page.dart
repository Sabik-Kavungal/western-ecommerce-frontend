import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_vm.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  bool _hasTriggered = false;
  late AnimationController _mainController;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<Offset> _logoSlide;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
      ),
    );

    _logoSlide = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
          ),
        );

    _mainController.forward();
    _triggerInit();
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  void _triggerInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_hasTriggered) return;
      _hasTriggered = true;

      // Allow animations to play out for a high-end feel
      await Future.delayed(const Duration(milliseconds: 2800));

      if (mounted) {
        context.read<AuthViewModel>().restoreSession();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with Slide + Fade
                SlideTransition(
                  position: _logoSlide,
                  child: FadeTransition(
                    opacity: _logoFade,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Image.asset(
                        'assets/images/westerngram_logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.shopping_bag_outlined,
                              size: 40,
                              color: Colors.black,
                            ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // Text Content
                FadeTransition(
                  opacity: _textFade,
                  child: Column(
                    children: [
                      const Text(
                        'WESTERN GRAM',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          letterSpacing: 8.0,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: 40,
                        height: 1,
                        color: Colors.black.withOpacity(0.1),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'COLLECTION \'24',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade400,
                          letterSpacing: 4.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Footer - Established
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _textFade,
              child: Column(
                children: [
                  const Text(
                    'ESTABLISHED 2026',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      color: Colors.black12,
                      letterSpacing: 3.0,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Colors.black12,
                      strokeWidth: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
