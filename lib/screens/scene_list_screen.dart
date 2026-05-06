import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/common_widgets.dart';
import 'learn_screen.dart';

class SceneListScreen extends StatelessWidget {
  final String lessonId;

  const SceneListScreen({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context) {
    final lesson = lessons.firstWhere((l) => l.id == lessonId);
    final lessonScenes = scenes.where((s) => s.lessonId == lessonId).toList();
    final completedCount = lessonScenes.where((s) => s.completed).length;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.chevron_left),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(.18),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '뒤로가기',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '씬 선택',
                    style: TextStyle(
                      color: Color(0xFFDBEAFE),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    lesson.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      height: 1.12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    lesson.description,
                    style: const TextStyle(color: Color(0xFFDBEAFE)),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.18),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              '학습 진행률',
                              style: TextStyle(color: Color(0xFFDBEAFE)),
                            ),
                            const Spacer(),
                            Text(
                              '$completedCount / ${lessonScenes.length}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: completedCount / lessonScenes.length,
                          backgroundColor: Colors.white24,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: lessonScenes.length,
                itemBuilder: (_, i) {
                  final scene = lessonScenes[i];
                  final first = sentences.firstWhere((s) => s.sceneId == scene.id);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color(0xFFDBEAFE),
                                foregroundColor: appBlue,
                                child: Text('${i + 1}'),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  scene.title,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              if (scene.completed)
                                const Icon(Icons.check_circle, color: Colors.green),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Icon(Icons.schedule, size: 17, color: Colors.grey.shade600),
                              const SizedBox(width: 5),
                              Text(scene.duration),
                              const SizedBox(width: 18),
                              Icon(Icons.chat_bubble_outline, size: 17, color: Colors.grey.shade600),
                              const SizedBox(width: 5),
                              Text('${scene.sentenceCount}문장'),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '발음 초점',
                                  style: TextStyle(
                                    color: Color(0xFF475569),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  scene.pronunciationFocus,
                                  style: const TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          PrimaryButton(
                            text: scene.completed ? '다시 학습하기' : '학습 시작',
                            icon: Icons.play_arrow,
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LearnScreen(
                                  lessonId: lessonId,
                                  sceneId: scene.id,
                                  sentenceId: first.id,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
