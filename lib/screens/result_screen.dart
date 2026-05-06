import 'dart:math';
import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/common_widgets.dart';
import 'learn_screen.dart';

class ResultScreen extends StatefulWidget {
  final String lessonId;
  final String sceneId;
  final String sentenceId;

  const ResultScreen({super.key, required this.lessonId, required this.sceneId, required this.sentenceId});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool showHint = false;
  late final int overall = Random().nextInt(30) + 70;
  late final int consonant = Random().nextInt(30) + 70;
  late final int vowel = Random().nextInt(30) + 70;
  late final int intonation = Random().nextInt(30) + 70;

  PracticeSentence get sentence => sentences.firstWhere((s) => s.id == widget.sentenceId);
  List<PracticeSentence> get sceneSentences => sentences.where((s) => s.sceneId == widget.sceneId).toList();

  Color scoreColor(int s) {
    if (s >= 90) return Colors.green;
    if (s >= 80) return appBlue;
    if (s >= 70) return Colors.orange;
    return Colors.red;
  }

  String headerText() {
    if (overall >= 90) return '완벽해요!';
    if (overall >= 80) return '잘했어요!';
    if (overall >= 70) return '좋아요!';
    return '한 번 더 해보자!';
  }

  void next() {
    final current = sceneSentences.indexWhere((s) => s.id == widget.sentenceId);
    if (current + 1 < sceneSentences.length) {
      final n = sceneSentences[current + 1];
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LearnScreen(lessonId: widget.lessonId, sceneId: widget.sceneId, sentenceId: n.id)));
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final incorrect = sentence.targetWord.length >= 2 ? sentence.targetWord.substring(0, 2) : sentence.targetWord;
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(children: [
        ListView(
          padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 22, 16, 110),
          children: [
            Center(child: Column(children: [
              Container(width: 82, height: 82, decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Color(0xFF22C55E), Color(0xFF16A34A)])), child: const Center(child: Text('🎉', style: TextStyle(fontSize: 38)))),
              const SizedBox(height: 12),
              Text(headerText(), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
            ])),
            const SizedBox(height: 16),
            AppCard(child: Column(children: [
              const Text('종합 점수', style: TextStyle(color: Color(0xFF64748B))),
              const SizedBox(height: 8),
              Text('$overall', style: TextStyle(fontSize: 72, fontWeight: FontWeight.w900, color: scoreColor(overall))),
              const Text('100점 만점', style: TextStyle(color: Color(0xFF64748B))),
            ])),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _scoreCard('자음', consonant)),
              const SizedBox(width: 10),
              Expanded(child: _scoreCard('모음', vowel)),
              const SizedBox(width: 10),
              Expanded(child: _scoreCard('억양', intonation)),
            ]),
            const SizedBox(height: 12),
            AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [Icon(Icons.volume_up, color: appBlue), SizedBox(width: 8), Text('연습한 문장', style: TextStyle(fontWeight: FontWeight.w700))]),
              const SizedBox(height: 12),
              RichText(text: TextSpan(style: const TextStyle(color: Color(0xFF0F172A), fontSize: 20, height: 1.45, fontWeight: FontWeight.w700), children: _highlight(sentence.text, incorrect))),
            ])),
            const SizedBox(height: 12),
            AppCard(onTap: () => setState(() => showHint = true), child: const Row(children: [
              CircleAvatar(backgroundColor: Color(0xFFF1F5F9), child: Icon(Icons.trending_up, color: Color(0xFF475569))),
              SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('억양 힌트 보기', style: TextStyle(fontWeight: FontWeight.w800)), SizedBox(height: 3), Text('원어민 억양과 비교해봐요', style: TextStyle(color: Color(0xFF64748B), fontSize: 12))])),
              Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
            ])),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF2563EB)])),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _feedback('칭찬', '"${sentence.targetWord}" 발음이 정확해요!', Icons.auto_awesome),
                const Divider(color: Colors.white24, height: 26),
                _feedback('개선 포인트', '"$incorrect" 부분의 억양을 더 자연스럽게 해보세요', Icons.trending_up),
                const Divider(color: Colors.white24, height: 26),
                _feedback('실천 팁', '천천히 말하기로 억양 패턴을 따라해보세요', Icons.lightbulb_outline),
              ]),
            ),
          ],
        ),
        Positioned(left: 0, right: 0, bottom: 0, child: Container(padding: const EdgeInsets.all(16), decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, -4))]), child: SafeArea(top: false, child: Row(children: [
          Expanded(child: OutlinedButton.icon(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LearnScreen(lessonId: widget.lessonId, sceneId: widget.sceneId, sentenceId: widget.sentenceId))), icon: const Icon(Icons.restart_alt), label: const Text('다시 해보기'))),
          const SizedBox(width: 10),
          Expanded(child: ElevatedButton.icon(onPressed: next, icon: const Icon(Icons.arrow_forward), label: const Text('다음 문장'))),
        ])))) ,
        if (showHint) _hintSheet(),
      ]),
    );
  }

  List<TextSpan> _highlight(String text, String word) {
    final parts = text.split(word);
    final spans = <TextSpan>[];
    for (var i = 0; i < parts.length; i++) {
      spans.add(TextSpan(text: parts[i]));
      if (i < parts.length - 1) {
        spans.add(TextSpan(text: word, style: const TextStyle(backgroundColor: Color(0xFFFEE2E2), color: Color(0xFF991B1B), decoration: TextDecoration.underline, decorationThickness: 2)));
      }
    }
    return spans;
  }

  Widget _scoreCard(String label, int score) => AppCard(padding: const EdgeInsets.all(14), child: Column(children: [Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)), const SizedBox(height: 7), Text('$score', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: scoreColor(score))), const SizedBox(height: 8), LinearProgressIndicator(value: score / 100, color: scoreColor(score), backgroundColor: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(99))]));

  Widget _feedback(String title, String body, IconData icon) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [CircleAvatar(backgroundColor: Colors.white24, child: Icon(icon, color: Colors.white, size: 20)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Color(0xFFDBEAFE), fontSize: 12)), const SizedBox(height: 4), Text(body, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))]))]);

  Widget _hintSheet() => GestureDetector(
    onTap: () => setState(() => showHint = false),
    child: Container(color: Colors.black54, child: Align(alignment: Alignment.bottomCenter, child: GestureDetector(onTap: () {}, child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: SafeArea(top: false, child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 46, height: 4, decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(99))),
        const SizedBox(height: 18),
        Row(children: [const Text('억양 힌트', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)), const Spacer(), IconButton(onPressed: () => setState(() => showHint = false), icon: const Icon(Icons.close))]),
        const SizedBox(height: 10),
        _intonationBox('원어민 억양', '끝을 내려요 ↓', Colors.green, false),
        const SizedBox(height: 10),
        _intonationBox('내 억양', '끝이 올라갔어요 ↑', Colors.orange, true),
        const SizedBox(height: 12),
        Container(width: double.infinity, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16)), child: const Text('마지막 부분을 조금 더 내려서 말하면 더 자연스러워.')),
        const SizedBox(height: 14),
        Row(children: [Expanded(child: OutlinedButton(onPressed: () => setState(() => showHint = false), child: const Text('닫기'))), const SizedBox(width: 10), Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.play_arrow), label: const Text('원어민 듣기')))]),
      ])),
    ))),
  ));

  Widget _intonationBox(String title, String desc, Color color, bool rising) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [CircleAvatar(radius: 5, backgroundColor: color), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), const Spacer(), Text(desc, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12))]),
      const SizedBox(height: 10),
      CustomPaint(size: const Size(double.infinity, 56), painter: _IntonationPainter(color: color, rising: rising)),
    ]),
  );
}

class _IntonationPainter extends CustomPainter {
  final Color color;
  final bool rising;
  _IntonationPainter({required this.color, required this.rising});

  @override
  void paint(Canvas canvas, Size size) {
    final muted = Paint()..color = const Color(0xFFCBD5E1)..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final active = Paint()..color = color..strokeWidth = 4..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final p1 = Path()..moveTo(8, size.height * .5)..quadraticBezierTo(size.width * .25, size.height * .45, size.width * .58, size.height * .5);
    canvas.drawPath(p1, muted);
    final p2 = Path()..moveTo(size.width * .58, size.height * .5)..quadraticBezierTo(size.width * .75, rising ? size.height * .25 : size.height * .65, size.width - 8, rising ? size.height * .18 : size.height * .82);
    canvas.drawPath(p2, active);
    canvas.drawCircle(Offset(size.width - 8, rising ? size.height * .18 : size.height * .82), 4, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
