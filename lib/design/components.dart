import 'package:flutter/material.dart';
import 'colors.dart';
import 'text.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const GradientAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      flexibleSpace: Container(
        decoration: const BoxDecoration(gradient: aiPrimaryGradient),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool loading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onPressed,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: aiPrimaryGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.20),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child:
              loading
                  ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                  : Text(
                    text,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
        ),
      ),
    );
  }
}

class FormCard extends StatelessWidget {
  final String title;
  final Widget child;

  const FormCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.only(bottom: 18),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppText.h2),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
