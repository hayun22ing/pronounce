import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/common_widgets.dart';

class RecordHistoryScreen extends StatelessWidget {
  const RecordHistoryScreen({super.key});

  Color bg(int s) => s >= 80 ? const Color(0xFFDCFCE7) : s >= 60 ? const Color(0xFFFEF3C7) : const Color(0xFFFEE2E2);
  Color fg(int s) => s >= 80 ? const Color(0xFF15803D) : s >= 60 ? const Color(0xFFB45309) : const Color(0xFFB91C1C);

  @override
  Widget build(BuildContext context) {
    final average = (attemptHistory.map((e) => e.overallScore).reduce((a, b) => a + b) / attemptHistory.length).round();
    final weekly = attemptHistory.length;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 20),
        children: [
          const Text('학습 기록', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          const Text('나의 발음 연습 히스토리', style: TextStyle(color: Color(0xFF64748B))),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _statCard('이번 주', '$weekly회', '연습 완료', Icons.calendar_today, const [Color(0xFF3B82F6), Color(0xFF2563EB)])),
            const SizedBox(width: 10),
            Expanded(child: _statCard('평균 점수', '$average점', '전체 평균', Icons.emoji_events, const [Color(0xFFA855F7), Color(0xFF9333EA)])),
          ]),
          const SizedBox(height: 14),
          AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Row(children: [Icon(Icons.trending_up, color: Colors.green), SizedBox(width: 8), Text('발전 현황', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800))]),
            SizedBox(height: 16),
            _ProgressLine(label: '자음 발음', score: 81, color: appBlue),
            SizedBox(height: 12),
            _ProgressLine(label: '모음 발음', score: 79, color: Colors.purple),
            SizedBox(height: 12),
            _ProgressLine(label: '억양 정확도', score: 78, color: Colors.green),
          ])),
          const SizedBox(height: 14),
          AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('최근 연습 내역', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            for (final a in attemptHistory)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(18)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [Expanded(child: Text(a.sentenceText, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800))), Pill(text: '${a.overallScore}점', background: bg(a.overallScore), foreground: fg(a.overallScore))]),
                  const SizedBox(height: 5),
                  Text(a.date, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                  const SizedBox(height: 10),
                  Row(children: [_mini('자음', a.consonantScore), const SizedBox(width: 8), _mini('모음', a.vowelScore), const SizedBox(width: 8), _mini('억양', a.intonationScore)]),
                ]),
              ),
          ])),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, String sub, IconData icon, List<Color> colors) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: LinearGradient(colors: colors)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: Colors.white70), const SizedBox(height: 8), Text(title, style: const TextStyle(color: Colors.white70)), const SizedBox(height: 4), Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)), Text(sub, style: const TextStyle(color: Colors.white70))]),
  );

  Widget _mini(String label, int score) => Expanded(child: Container(padding: const EdgeInsets.all(9), decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)), child: Column(children: [Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))), const SizedBox(height: 4), Text('$score', style: const TextStyle(fontWeight: FontWeight.w800))])));
}

class _ProgressLine extends StatelessWidget {
  final String label;
  final int score;
  final Color color;
  const _ProgressLine({required this.label, required this.score, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: Color(0xFF64748B))), Text('평균 $score점', style: const TextStyle(fontWeight: FontWeight.w700))]),
      const SizedBox(height: 6),
      LinearProgressIndicator(value: score / 100, color: color, backgroundColor: const Color(0xFFE2E8F0), minHeight: 8, borderRadius: BorderRadius.circular(99)),
    ]);
  }
}
