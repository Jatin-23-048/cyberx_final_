import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // FIX: Missing import for DateFormat
import '../providers/app_state.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  // FIX: Declare the late variable here
  late TabController _tabController; 

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Flexible(
              child: Text(
                'CyberX',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Stay Secure',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout, // FIX: Method now properly defined below
          ),
        ],
      ),
      body: Consumer2<AppState, AuthProvider>(
        builder: (context, state, auth, _) {
          // This CustomScrollView/Sliver structure is common but tricky.
          // The build methods below (now included) will manage their own scrolling
          // to prevent the pixel overflow issue.
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 520;
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: isWide ? 80 : 64,
                                height: isWide ? 80 : 64,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1e7dd6),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    auth.username.isNotEmpty ? auth.username[0].toUpperCase() : 'U',
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            auth.username.isNotEmpty ? auth.username : 'User',
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => _showEditProfileDialog(context, auth),
                                          icon: const Icon(Icons.edit, color: Colors.white),
                                          tooltip: 'Edit Profile',
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      auth.joinDate != null
                                          ? 'Member since ${DateFormat('MMMM yyyy').format(auth.joinDate!)}'
                                          : 'Member since...',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      auth.email,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Container(
                        color: const Color(0xFF252f3d),
                        child: TabBar(
                          controller: _tabController,
                          labelColor: const Color(0xFF1e7dd6),
                          unselectedLabelColor: Colors.white,
                          tabs: const [
                            Tab(text: 'Overview'),
                            Tab(text: 'Awards'),
                            Tab(text: 'Settings'),
                            Tab(text: 'Security'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                // Prevents pixel overflow on the primary axis by making this widget take
                // the remaining space and housing the vertically scrolling TabBarView.
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(state, context),
                    _buildAwardsTab(context),
                    _buildSettingsTab(state, context), // Pass state for persistence
                    _buildSecurityTab(context),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // FIX: _handleLogout must be defined within the State class
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pop(context);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, AuthProvider auth) {
    final _usernameController = TextEditingController(text: auth.username);
    final _emailController = TextEditingController(text: auth.email);

    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final success = await auth.updateProfile(
                newUsername: _usernameController.text.trim(),
                newEmail: _emailController.text.trim(),
              );
              Navigator.pop(c);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated'), backgroundColor: Color(0xFF00D9FF)),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Update failed'), backgroundColor: Color(0xFFFF0080)),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // FIX: All the build methods below were defined correctly in the original file
  // but caused errors due to missing definitions when the file was analyzed.
  // They are now included here for completeness.

  Widget _buildOverviewTab(AppState state, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF252f3d),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF10b981), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.verified, color: Color(0xFF10b981), size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Security Score',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Your overall cybersecurity awareness level',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: state.securityScore / 100,
                    minHeight: 8,
                    backgroundColor: const Color(0xFF3f4451),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF10b981)),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${state.securityScore.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10b981),
                      ),
                    ),
                    Text(
                      'Great progress! Complete the remaining courses to reach 100%.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          Text(
            'Activity Stats',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final cross = constraints.maxWidth > 720 ? 4 : (constraints.maxWidth > 520 ? 3 : 2);
              return GridView.count(
                crossAxisCount: cross,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _buildStatCard(
                    context,
                    'Courses Completed',
                    '${state.courses.where((c) => c.completed).length}',
                    Icons.school,
                    const Color(0xFF1e7dd6),
                  ),
                  _buildStatCard(
                    context,
                    'Community Points',
                    '245',
                    Icons.star,
                    const Color(0xFF1e7dd6),
                  ),
                  _buildStatCard(
                    context,
                    'Reports Submitted',
                    '${state.reports.length}',
                    Icons.flag,
                    const Color(0xFF10b981),
                  ),
                  _buildStatCard(
                    context,
                    'Articles Read',
                    '15',
                    Icons.article,
                    const Color(0xFF1e7dd6),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF252f3d),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Your latest actions on CyberX',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label selected'), backgroundColor: const Color(0xFF1e7dd6)),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF252f3d),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAwardsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF252f3d),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Badges and achievements coming soon',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab(AppState state, BuildContext context) { // Now accepts AppState
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preferences',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF252f3d),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Call _buildSettingItem with the actual state values
                _buildSettingItem(
                  'Email Notifications', 
                  state.isEmailNotificationEnabled,
                  (value) => state.toggleEmailNotifications(value), 
                  context
                ),
                const Divider(color: Color(0xFF3f4451)),
                _buildSettingItem(
                  'Push Notifications', 
                  state.isPushNotificationEnabled,
                  (value) => state.togglePushNotifications(value),
                  context
                ),
                const Divider(color: Color(0xFF3f4451)),
                _buildSettingItem(
                  'Dark Mode', 
                  state.isDarkModeEnabled,
                  (value) => state.toggleDarkMode(value), 
                  context
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: const Text('Reset App'),
                          content: const Text('This will clear all local data and log out. Continue?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                            TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Reset')),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        // Perform reset
                        await Provider.of<AppState>(context, listen: false).resetApp();
                        await Provider.of<AuthProvider>(context, listen: false).logout();
                        // Navigate to login screen and remove all routes
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF0080)),
                    child: const Text('Reset App'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security Options',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF252f3d),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildSecurityOption('Two-Factor Authentication', 'Setup', context),
                const Divider(color: Color(0xFF3f4451)),
                _buildSecurityOption('Login Alerts', 'Enabled', context),
                const Divider(color: Color(0xFF3f4451)),
                _buildSecurityOption('Change Password', 'Update', context),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // NEW/MODIFIED: Consolidated the two item builders and made the Switch fully functional
  Widget _buildSettingItem(String label, bool value, ValueChanged<bool> onChanged, BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF1e7dd6),
            )
          ],
        ),
      );
  }

  // NEW: Separate builder for Security tab actions (Update/Setup buttons)
  Widget _buildSecurityOption(String label, String actionText, BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {
                // Placeholder for future implementation (e.g., navigation to a new screen)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$label clicked. Functionality coming soon.'),
                    backgroundColor: const Color(0xFFFF0080),
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: const Color(0xFF1e7dd6)),
              child: Text(actionText),
            ),
          ],
        ),
      );
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}