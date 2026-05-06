import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/common_widgets.dart';
import 'scene_list_screen.dart';

class LessonListScreen extends StatefulWidget {
  const LessonListScreen({super.key});

  @override
  State<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> {
  String filter = 'all';

  String difficultyLabel(String d) =>
      {'easy': '쉬움', 'medium': '보통', 'hard': '어려움'}[d] ?? d;

  Color difficultyBg(String d) => {
        'easy': const Color(0xFFDCFCE7),
        'medium': const Color(0xFFFEF3C7),
        'hard': const Color(0xFFFEE2E2),
      }[d] ??
      const Color(0xFFE2E8F0);

  Color difficultyFg(String d) => {
        'easy': const Color(0xFF15803D),
        'medium': const Color(0xFFB45309),
        'hard': const Color(0xFFB91C1C),
      }[d] ??
      const Color(0xFF475569);

  @override
  Widget build(BuildContext context) {
    final filtered = filter == 'all'
        ? lessons
        : lessons.where((l) => l.difficulty == filter).toList();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
          children: [
            const AppHeader(
              label: '학습 레슨',
              title: '원하는 레슨을\n선택하세요',
            ),
            const SizedBox(height: 18),
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.filter_list, size: 18, color: Color(0xFF475569)),
                        SizedBox(width: 6),
                        Text(
                          '난이도',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _filterButton('all', '전체'),
                        _filterButton('easy', '쉬움'),
                        _filterButton('medium', '보통'),
                        _filterButton('hard', '어려움'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            for (final lesson in filtered)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        lesson.description,
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Pill(
                            text: difficultyLabel(lesson.difficulty),
                            background: difficultyBg(lesson.difficulty),
                            foreground: difficultyFg(lesson.difficulty),
                          ),
                          const SizedBox(width: 8),
                          Pill(
                            text: lesson.pronunciationType,
                            background: const Color(0xFFF1F5F9),
                            foreground: const Color(0xFF475569),
                          ),
                          const Spacer(),
                          Text(
                            '${lesson.sceneCount}개 장면',
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        text: '시작하기',
                        icon: Icons.chevron_right,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SceneListScreen(lessonId: lesson.id),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _filterButton(String value, String label) {
    final active = filter == value;

    return ChoiceChip(
      label: Text(label),
      selected: active,
      onSelected: (_) => setState(() => filter = value),
      selectedColor: appBlue,
      backgroundColor: const Color(0xFFF1F5F9),
      showCheckmark: false,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      labelStyle: TextStyle(
        color: active ? Colors.white : const Color(0xFF475569),
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
