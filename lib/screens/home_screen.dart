import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/threat_level_card.dart';
import '../widgets/security_score_card.dart';
import '../widgets/recent_alerts_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Digital Defense',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Stay Secure',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Consumer<AppState>(
                  builder: (context, state, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ThreatLevelCard(threatLevel: state.currentThreatLevel),
                      const SizedBox(height: 20),
                      
                      SecurityScoreCard(score: state.securityScore),
                      const SizedBox(height: 20),
                      
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF252f3d),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF1e7dd6), width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.trending_up, color: Color(0xFF1e7dd6)),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Learning Progress',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Continue your cybersecurity education',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ..._buildProgressBars(state, context),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1e7dd6),
                                ),
                                child: const Text('Continue Learning'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF252f3d),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  const Icon(Icons.people, color: Color(0xFF1e7dd6), size: 28),
                                  const SizedBox(height: 8),
                                  const Text(
                                    '12.5K',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Active Users',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF252f3d),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  const Icon(Icons.verified, color: Color(0xFF10b981), size: 28),
                                  const SizedBox(height: 8),
                                  const Text(
                                    '98.2%',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Protected',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      Text(
                        'Recent Alerts',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      RecentAlertsCard(threats: state.threats.take(3).toList()),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildProgressBars(AppState state, BuildContext context) {
    final courses = state.courses.take(3).toList();
    return courses.map((course) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  course.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${(course.progress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Color(0xFF1e7dd6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: course.progress,
                minHeight: 6,
                backgroundColor: const Color(0xFF3f4451),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF1e7dd6)),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
