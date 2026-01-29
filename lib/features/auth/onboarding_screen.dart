import 'package:flutter/material.dart';
import '../../core/theme/zuno_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "title": "Be Real",
      "desc": "Post real moments.\nNo filters. No pressure.",
    },
    {
      "title": "Be Local",
      "desc": "Your city.\nYour college.\nYour people.",
    },
    {
      "title": "Be Now",
      "desc": "Real-time drops.\nLive culture.\nNo FOMO.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZunoColors.background,
      body: Stack(
        children: [
          // MAIN CONTENT
          PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() => currentIndex = index);
            },
            itemBuilder: (_, index) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: ZunoColors.card,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 20,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          pages[index]["title"]!,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: ZunoColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          pages[index]["desc"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: ZunoColors.textMuted,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // FLOATING BOTTOM ACTION
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: ZunoColors.card,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 25,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // PAGE DOTS
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: List.generate(
                        pages.length,
                            (i) => Container(
                          margin: const EdgeInsets.only(right: 6),
                          width: currentIndex == i ? 16 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: currentIndex == i
                                ? ZunoColors.primary
                                : ZunoColors.textMuted,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // CONTINUE BUTTON
                  GestureDetector(
                    onTap: () {
                      if (currentIndex < pages.length - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                        );
                      } else {
                        // NEXT: Login / Home
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: ZunoColors.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: Colors.black,
                      ),
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
