import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _reportTypeController = TextEditingController();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactController = TextEditingController();
  String _selectedThreatType = 'Phishing';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Digital Defense', style: TextStyle(color: Colors.white)),
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
      body: Column(
        children: [
          Container(
            color: const Color(0xFF111111),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF1e7dd6),
              unselectedLabelColor: Colors.white,
              tabs: const [
                Tab(text: 'Submit Report'),
                Tab(text: 'My Reports'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSubmitReportTab(context),
                _buildMyReportsTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitReportTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Consumer<AppState>(
        builder: (context, state, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF252f3d),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF1e7dd6), width: 1),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info, color: Color(0xFF1e7dd6), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Report any cybersecurity threats you encounter. Your reports help protect the entire community.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                      const Icon(Icons.flag, color: Color(0xFF1e7dd6), size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'Submit Security Report',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Provide as much detail as possible to help us investigate the threat',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    'Report Type *',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1f2937),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF3f4451)),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedThreatType,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF252f3d),
                      underline: Container(),
                      items: [
                        'Phishing',
                        'Malware',
                        'Ransomware',
                        'Data Breach',
                        'Suspicious Website',
                        'Social Engineering',
                      ]
                          .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type, style: const TextStyle(color: Colors.white)),
                          ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedThreatType = value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    'Subject *',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _subjectController,
                    decoration: InputDecoration(
                      hintText: 'Brief description of the security concern',
                      filled: true,
                      fillColor: const Color(0xFF1f2937),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF3f4451)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF3f4451)),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    'Detailed Description *',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Provide a detailed description of what happened, when it occurred, and any relevant context...',
                      filled: true,
                      fillColor: const Color(0xFF1f2937),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF3f4451)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF3f4451)),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    'Contact Information (Optional)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _contactController,
                    decoration: InputDecoration(
                      hintText: 'Email or phone number for follow-up questions',
                      filled: true,
                      fillColor: const Color(0xFF1f2937),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF3f4451)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF3f4451)),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1e7dd6),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Submit Report'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF252f3d),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reporting Guidelines',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildGuidelineItem('For phishing attempts:', 'Include email headers, sender information, and any suspicious links', context),
                  _buildGuidelineItem('For suspicious websites:', 'Provide the full URL and describe what seemed suspicious', context),
                  _buildGuidelineItem('For malware detection:', 'Include antivirus logs and file information if available', context),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidelineItem(String title, String description, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF00D9FF), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyReportsTab(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final reports = state.reports;
        
        if (reports.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.folder_open, size: 64, color: Color(0xFF333333)),
                const SizedBox(height: 16),
                Text(
                  'No reports yet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Your submitted reports will appear here',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${reports.length} Total Reports',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ...reports.map((report) => _buildReportCard(report, context)).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReportCard(dynamic report, BuildContext context) {
    final statusColor = report.status == 'Under Review' 
      ? const Color(0xFFFF0080)
      : report.status == 'Investigating'
      ? const Color(0xFFFF0080)
      : const Color(0xFF00D9FF);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252f3d),
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: statusColor, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                report.threatType,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha((255 * 0.2).toInt()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  report.status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Report ID: ${report.id.substring(0, 8)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            report.subject,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Submitted: ${report.timestamp.toString().split('.')[0]}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontSize: 11,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.timeline, size: 16),
                label: const Text('Timeline'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFFF0080),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submitReport() {
    if (_subjectController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Color(0xFFFF0080),
        ),
      );
      return;
    }

    final state = Provider.of<AppState>(context, listen: false);
    state.submitReport(
      _selectedThreatType,
      _subjectController.text,
      _descriptionController.text,
    );

    _subjectController.clear();
    _descriptionController.clear();
    _contactController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report submitted successfully'),
        backgroundColor: Color(0xFF00D9FF),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _reportTypeController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    super.dispose();
  }
}
