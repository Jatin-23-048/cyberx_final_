import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/course_card.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({Key? key}) : super(key: key);

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = ['Courses', 'Articles', 'Quizzes'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Hub'),
        elevation: 0,
      ),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          return Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: List.generate(tabs.length, (index) {
                      final isSelected = _selectedTab == index;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTab = index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF1e7dd6)
                                  : const Color(0xFF252f3d),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tabs[index],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Expanded(
                child: _selectedTab == 0
                    ? ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.courses.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: CourseCard(course: state.courses[index]),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'Coming Soon',
                          style:
                              Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
