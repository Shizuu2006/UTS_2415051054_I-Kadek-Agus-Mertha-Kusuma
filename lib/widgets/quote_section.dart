import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quote_provider.dart';
import '../theme.dart';

class QuoteSection extends StatelessWidget {
  const QuoteSection({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<QuoteProvider>();

    Widget child;
    if (p.isLoading) {
      child = const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    } else if (p.error != null) {
      child = Row(
        children: [
          const Icon(Icons.cloud_off, color: AppColors.blue),
          const SizedBox(width: 10),
          Expanded(child: Text(p.error!, style: const TextStyle(fontSize: 12))),
          TextButton(onPressed: p.loadQuotes, child: const Text('Retry')),
        ],
      );
    } else if (p.isEmpty) {
      child = const Text('Belum ada kutipan.');
    } else {
      final q = p.quotes.first;
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"${q.text}"',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '- ${q.author}',
            style: const TextStyle(fontSize: 12, color: AppColors.blue),
          ),
        ],
      );
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      padding: const EdgeInsets.all(14),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.ice.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
