import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final VoidCallback onClose;
  final ValueChanged<String> onNavigate;

  const Sidebar({super.key, required this.onClose, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 16, backgroundColor: Color(0xFF0EA5E9), child: Icon(Icons.stars, size: 18, color: Colors.white)),
                const SizedBox(width: 8),
                const Expanded(child: Text('Adhkar\nIslamic Remembrance', maxLines: 2)),
                IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 8),
            _sectionTitle('SETTINGS'),
            _tile(context, Icons.dark_mode, 'Dark Mode',trailing: Switch(value: false, onChanged: (_) {})),
            _tile(context, Icons.language, 'Language', trailing: const Text('English')),
            _tile(context, Icons.text_fields, 'Arabic Font Size'),
            _tile(context, Icons.alarm, 'Prayer Reminders', trailing: Switch(value: true, onChanged: (_) {})),
            _tile(context, Icons.volume_up, 'Audio Pronunciation', trailing: Switch(value: false, onChanged: (_) {})),
            const Divider(),
            _sectionTitle('ISLAMIC TOOLS'),
            _nav(context, Icons.access_time, 'Prayer Times', 'prayer-times'),
            _nav(context, Icons.explore, 'Qibla Direction', 'qibla'),
            _nav(context, Icons.calendar_today, 'Islamic Calendar', 'calendar'),
            const Divider(),
            _sectionTitle('APP'),
            _nav(context, Icons.bar_chart, 'Reading Statistics', 'statistics'),
            _nav(context, Icons.cloud_upload_outlined, 'Backup & Sync', 'backup'),
            _nav(context, Icons.info_outline, 'About', 'about'),
            _nav(context, Icons.help_outline, 'Support & FAQ', 'support'),
            const SizedBox(height: 12),
            const Center(child: Text('Adhkar App v1.2.0')),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String title, {Widget? trailing}) {
    return ListTile(leading: Icon(icon), title: Text(title), trailing: trailing);
  }

  Widget _nav(BuildContext context, IconData icon, String title, String tab) {
    return ListTile(leading: Icon(icon), title: Text(title), trailing: const Icon(Icons.chevron_right), onTap: () => onNavigate(tab));
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    );
  }
}


