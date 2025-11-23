import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/discussion_card.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedCategory = 'General Question';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        elevation: 0,
      ),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Start a Discussion'),
                  onPressed: () => _showCreateDiscussionDialog(context, state),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1e7dd6),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 44),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.discussions.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DiscussionCard(
                        discussion: state.discussions[index],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCreateDiscussionDialog(BuildContext context, AppState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1f2937),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start a Discussion',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF252f3d),
                  items: [
                    'General Question',
                    'Best Practices',
                    'Incident Response',
                    'Resource Sharing',
                  ]
                      .map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedCategory = value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Discussion title',
                    filled: true,
                    fillColor: const Color(0xFF252f3d),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _contentController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'What\'s on your mind?',
                    filled: true,
                    fillColor: const Color(0xFF252f3d),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isNotEmpty &&
                        _contentController.text.isNotEmpty) {
                      state.addDiscussion(
                        _titleController.text,
                        _selectedCategory,
                        _contentController.text,
                      );
                      _titleController.clear();
                      _contentController.clear();
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1e7dd6),
                    minimumSize: const Size(double.infinity, 44),
                  ),
                  child: const Text('Post Discussion'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
