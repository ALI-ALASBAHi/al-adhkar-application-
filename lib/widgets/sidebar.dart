import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';

class Sidebar extends StatelessWidget {
  final VoidCallback onClose;
  final ValueChanged<String> onNavigate;

  const Sidebar({super.key, required this.onClose, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
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
                    Expanded(child: Text('${languageService.t('app_title')}\nIslamic Remembrance', maxLines: 2)),
                    IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 8),
                _sectionTitle(languageService.t('settings_section')),
                _tile(context, Icons.dark_mode, languageService.t('dark_mode'), trailing: Switch(value: false, onChanged: (_) {})),
                _tile(context, Icons.language, languageService.t('language'), trailing: Text(languageService.isArabic ? 'عربي' : 'English')),
                _tile(context, Icons.text_fields, languageService.t('arabic_font_size')),
                _tile(context, Icons.alarm, languageService.t('prayer_reminders'), trailing: Switch(value: true, onChanged: (_) {})),
                _tile(context, Icons.volume_up, languageService.t('audio_pronunciation'), trailing: Switch(value: false, onChanged: (_) {})),
                const Divider(),
                _sectionTitle(languageService.t('islamic_tools')),
                _nav(context, Icons.access_time, languageService.t('prayer_times'), 'prayer-times'),
                _nav(context, Icons.explore, languageService.t('qibla_direction'), 'qibla'),
                _nav(context, Icons.calendar_today, languageService.t('islamic_calendar'), 'calendar'),
                const Divider(),
                _sectionTitle(languageService.t('app_section')),
                _nav(context, Icons.bar_chart, languageService.t('reading_statistics'), 'statistics'),
                _nav(context, Icons.cloud_upload_outlined, languageService.t('backup_sync'), 'backup'),
                _nav(context, Icons.info_outline, languageService.t('about'), 'about'),
                _nav(context, Icons.help_outline, languageService.t('support_faq'), 'support'),
                const SizedBox(height: 12),
                Center(child: Text(languageService.t('app_version'))),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
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


