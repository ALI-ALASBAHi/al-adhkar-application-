import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'widgets/app_header.dart';
import 'widgets/bottom_navigation.dart';
import 'widgets/sidebar.dart';
import 'screens/home_screen.dart';
import 'screens/dhikr_screen.dart';
import 'screens/placeholders.dart';
import 'package:provider/provider.dart';
import 'viewmodels/navigation_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const AdhkarApp());
}

class AdhkarApp extends StatelessWidget {
  const AdhkarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavigationViewModel(),
      child: MaterialApp(
        title: 'Adhkar - Islamic Remembrance',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _activeTab = 'home';
  late AnimationController _transitionController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(duration: const Duration(milliseconds: 250), vsync: this);
    _fadeAnimation = CurvedAnimation(parent: _transitionController, curve: Curves.easeOut);
    _scaleAnimation = Tween<double>(begin: 0.97, end: 1.0).animate(_fadeAnimation);
    _transitionController.forward();
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  void _performTransition(VoidCallback callback) {
    _transitionController.reverse().then((_) {
      setState(callback);
      _transitionController.forward();
    });
  }

  void _handleTabChange(String tab) {
    if (tab == _activeTab) return;
    _performTransition(() {
      _activeTab = tab;
    });
    HapticFeedback.selectionClick();
  }

  void _handleSidebarNavigate(String screen) {
    _performTransition(() {
      _activeTab = screen;
    });
  }

  Widget _renderScreen() {
    switch (_activeTab) {
      case 'dhikr':
        return const DhikrScreen();
      case 'favorites':
        return const FavoritesScreen();
      case 'settings':
        return const SettingsScreen();
      case 'prayer-times':
        return const PrayerTimesScreen();
      case 'qibla':
        return const QiblaScreen();
      case 'statistics':
        return const StatisticsScreen();
      case 'calendar':
        return const IslamicCalendarScreen();
      case 'backup':
        return const BackupSyncScreen();
      default:
        return const HomeScreen();
    }
  }

  String? _getHeaderTitle() {
    switch (_activeTab) {
      case 'dhikr':
        return 'Dhikr';
      case 'favorites':
        return 'Favorites';
      case 'settings':
        return 'Settings';
      case 'prayer-times':
        return 'Prayer Times';
      case 'qibla':
        return 'Qibla Direction';
      case 'statistics':
        return 'Statistics';
      case 'calendar':
        return 'Islamic Calendar';
      case 'backup':
        return 'Backup & Sync';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF9FAFB),
      drawer: Sidebar(
        onClose: () => Navigator.of(context).pop(),
        onNavigate: (tab) {
          Navigator.of(context).pop();
          _handleSidebarNavigate(tab);
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: const Color(0xFF111827),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('9:41', style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
            AppHeader(
              title: _getHeaderTitle(),
              onMenuClick: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 448),
                  child: AnimatedBuilder(
                    animation: _transitionController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Opacity(opacity: _fadeAnimation.value, child: _renderScreen()),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        activeTab: _activeTab,
        onTabChange: _handleTabChange,
      ),
    );
  }
}
