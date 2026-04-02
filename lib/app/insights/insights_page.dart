import 'package:flutter/material.dart';
import '../../views/insights/insights_view.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: InsightsView(),
    );
  }
}
