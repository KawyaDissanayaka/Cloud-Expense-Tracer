import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onLogOut;
  final String userName;

  const ProfileScreen({
    Key? key,
    required this.onLogOut,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PROFILE',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            
            // Avatar and name
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.accent.withOpacity(0.1),
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                      style: GoogleFonts.outfit(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentLight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userName,
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Developer / Architect',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Profile Actions list
            _buildProfileItem(Icons.cloud_sync_outlined, 'AWS Configuration', 'Configure S3 buckets & secrets'),
            _buildProfileItem(Icons.notifications_active_outlined, 'Notifications', 'Manage alert thresholds'),
            _buildProfileItem(Icons.security_outlined, 'Account Security', 'Firebase Auth security key details'),
            _buildProfileItem(Icons.help_outline, 'Help & Support', 'Documentation on budget settings'),
            
            const SizedBox(height: 32),

            // Log Out Button
            ElevatedButton.icon(
              onPressed: onLogOut,
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Log Out Session'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.expenseColor.withOpacity(0.1),
                foregroundColor: AppTheme.expenseColor,
                side: const BorderSide(color: AppTheme.expenseColor, width: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.02)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.05),
            child: Icon(icon, color: AppTheme.textSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: AppTheme.textSecondary, size: 14),
        ],
      ),
    );
  }
}
