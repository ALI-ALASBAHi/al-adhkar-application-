import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/adhkar_data.dart';
import '../services/recent_service.dart';
import '../services/language_service.dart';

class DhikrReaderScreen extends StatefulWidget {
  final String categoryId;
  final String title;

  const DhikrReaderScreen({
    super.key,
    required this.categoryId,
    required this.title,
  });

  @override
  State<DhikrReaderScreen> createState() => _DhikrReaderScreenState();
}

class _DhikrReaderScreenState extends State<DhikrReaderScreen> {
  late List<Dhikr> _items;
  int _currentIndex = 0;
  int _currentCount = 0;

  @override
  void initState() {
    super.initState();
    _items = AdhkarData.getAdhkarList(widget.categoryId);
  }

  void _handleTapNext() {
    if (_items.isEmpty) return;
    final target = _items[_currentIndex].count;
    setState(() {
      _currentCount += 1;
      if (_currentCount >= target) {
        _currentCount = 0;
        if (_currentIndex < _items.length - 1) {
          _currentIndex += 1;
        } else {
          // Completed
          context.read<RecentService?>()?.addRecent(widget.categoryId);
          _showCompleted();
        }
      }
    });
  }

  void _handleReset() {
    if (_items.isEmpty) return;
    setState(() {
      _currentIndex = 0;
      _currentCount = 0;
    });
  }

  void _showCompleted() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final language = context.read<LanguageService>();
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundColor: Color(0xFF10B981),
                child: Icon(Icons.check, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 12),
              Text(
                language.isArabic ? 'تم الإنتهاء!' : 'Completed!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 6),
              Text(
                widget.title,
                style: const TextStyle(color: Color(0xFF3B82F6)),
              ),
              const SizedBox(height: 12),
              Text(
                language.isArabic
                    ? 'نسأل الله أن يتقبل ذكرك ويمنحك بركاته.'
                    : 'May Allah accept your dhikr and grant you His blessings.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                      ..pop()
                      ..pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0EA5E9),
                  ),
                  child: Text(
                    language.isArabic
                        ? 'العودة إلى الرئيسية'
                        : 'Return to Home',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageService>();
    final item = _items.isNotEmpty ? _items[_currentIndex] : null;
    final total = item?.count ?? 0;
    final media = MediaQuery.of(context);
    final double clampedTextScale =
        media.textScaleFactor.clamp(0.9, 1.2).toDouble();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), // خلفية فاتحة بدل الأسود
      body: SafeArea(
        child: MediaQuery(
          data: media.copyWith(textScaleFactor: clampedTextScale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 AppBar مخصص
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 20),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      onPressed: () => Navigator.of(context).pop(),
                      color: const Color.fromARGB(255, 4, 5, 6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_items.isEmpty ? 0 : _currentIndex + 1} / ${_items.length}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 4, 4, 5),
                        fontSize: 12,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 5, 6, 8),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // 🔹 Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: 0,
                    end:
                        total == 0
                            ? 0
                            : (_currentCount / total).clamp(0, 1).toDouble(),
                  ),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      minHeight: 5,
                      borderRadius: const BorderRadius.all(Radius.circular(13)),
                      backgroundColor: const Color(0xFFE5E7EB),
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF3B82F6),
                      ),
                    );
                  },
                ),
              ),

              // 🔹 Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _handleTapNext,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      padding: const EdgeInsets.all(16),
                      child:
                          _items.isEmpty
                              ? const Center(child: Text('No items'))
                              : Column(
                                children: [
                                  Expanded(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        return SingleChildScrollView(
                                          padding: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              minHeight: constraints.maxHeight,
                                            ),
                                            child: Center(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 16,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFFE5E7EB,
                                                    ),
                                                  ),
                                                ),
                                                child: DefaultTextStyle.merge(
                                                  style: const TextStyle(
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 80,
                                                              horizontal: 12,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: const Color(
                                                            0xFFF9FAFB,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          border: Border.all(
                                                            color: const Color(
                                                              0xFFE5E7EB,
                                                            ),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          item!.arabic,
                                                          textAlign:
                                                              TextAlign.center,
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          style: const TextStyle(
                                                            fontSize: 18,
                                                            height: 1.6,
                                                            color: Color(
                                                              0xFF111827,
                                                            ),
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        item.transliteration,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                          color: Color(
                                                            0xFF2563EB,
                                                          ),
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontSize: 13,
                                                          height: 1.6,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        item.translation,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          color: Color(
                                                            0xFF111827,
                                                          ),
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        item.source,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                          color: Color.fromARGB(
                                                            255,
                                                            9,
                                                            9,
                                                            11,
                                                          ),
                                                          fontSize: 11,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        245,
                                        246,
                                        247,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: const Color(0xFFE5E7EB),
                                      ),
                                    ),
                                    child: Text(
                                      '${_currentCount} / ${item!.count}',
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 3, 46, 163),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(width: 6),
                                      TextButton(
                                        onPressed: _handleReset,
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 6,
                                          ),
                                          visualDensity: VisualDensity.compact,
                                        ),
                                        child: Text(
                                          language.isArabic ? 'إعادة' : 'Reset',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            decoration: TextDecoration.none,
                                            color: Color.fromARGB(255, 4, 4, 4),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 140,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        251,
                                        251,
                                        252,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFE5E7EB),
                                      ),
                                    ),
                                    child: Text(
                                      language.isArabic
                                          ? 'إضغط للقراءة '
                                          : 'Tap to read',
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 2, 3, 3),
                                        fontSize: 13,
                                        decoration: TextDecoration.none,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
