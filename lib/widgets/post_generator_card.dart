import 'package:flutter/material.dart';
import '../models/post_generator_models.dart';

class PostGeneratorCard extends StatelessWidget {
  final PostGeneratorResponse post;

  const PostGeneratorCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(top: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "פוסט שנוצר:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(post.post),

            const SizedBox(height: 16),
            const Text("Hook:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(post.hook),

            const SizedBox(height: 16),
            const Text("CTA:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(post.cta),
          ],
        ),
      ),
    );
  }
}
