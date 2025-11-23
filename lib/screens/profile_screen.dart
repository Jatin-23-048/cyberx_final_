import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_state.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        // NestedScrollView creates a scrollable header + tab body
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: theme.scaffoldBackgroundColor,
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                    child: Consumer<AuthProvider>(
                      builder: (context, auth, _) => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: const Color(0xFF1e7dd6),
                            child: Text(
                              auth.username.isNotEmpty ? auth.username[0].toUpperCase() : 'U',
                              style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  auth.username,
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  auth.joinDate != null 
                                    ? 'Member since ${DateFormat('MMM yyyy').format(auth.joinDate!)}'
                                    : 'New Recruit',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: Container(
                    color: theme.cardColor,
                    child: TabBar(
                      isScrollable: true, // Allows tabs to scroll on small screens
                      labelColor: const Color(0xFF1e7dd6),
                      unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
                      indicatorColor: const Color(0xFF1e7dd6),
                      tabs: const [
                        Tab(text: 'Overview'),
                        Tab(text: 'Awards'),
                        Tab(text: 'Settings'),
                        Tab(text: 'Security'),
                      ],
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    color: Colors.white, // Icon on Appbar always white due to blue background
                    onPressed: () => _showLogoutDialog(context),
                  ),
                ],
              ),
            ];
          },
          body: Consumer2<AppState, AuthProvider>(
            builder: (context, state, auth, _) {
              return TabBarView(
                children: [
                  _buildOverviewTab(state, context),
                  _buildPlaceholderTab(context, 'Achievements coming soon', Icons.emoji_events),
                  _buildSettingsTab(state, context),
                  _buildSecurityTab(context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pop(context);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(AppState state, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Security Score Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF10b981).withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text('Security Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: state.securityScore / 100,
                  color: const Color(0xFF10b981),
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(5),
                ),
                const SizedBox(height: 10),
                Text('${state.securityScore.toInt()}%', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF10b981))),
              ],
            ),
          ),
          // Add more stats here as needed
        ],
      ),
    );
  }

  Widget _buildSettingsTab(AppState state, BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSwitchTile(
          context,
          'Email Notifications',
          state.isEmailNotificationEnabled,
          (val) => state.toggleEmailNotifications(val),
        ),
        _buildSwitchTile(
          context,
          'Push Notifications',
          state.isPushNotificationEnabled,
          (val) => state.togglePushNotifications(val),
        ),
        _buildSwitchTile(
          context,
          'Dark Mode',
          state.isDarkModeEnabled,
          (val) => state.toggleDarkMode(val),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(BuildContext context, String title, bool value, Function(bool) onChanged) {
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.only(bottom: 12),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        value: value,
        activeColor: const Color(0xFF1e7dd6),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSecurityTab(BuildContext context) {
     return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildActionTile(context, 'Change Password', Icons.lock_reset),
        _buildActionTile(context, 'Two-Factor Authentication', Icons.phonelink_lock),
      ],
    );
  }

  Widget _buildActionTile(BuildContext context, String title, IconData icon) {
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF1e7dd6)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Security feature coming soon')));
        },
      ),
    );
  }

  Widget _buildPlaceholderTab(BuildContext context, String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}