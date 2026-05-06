import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String language = 'ko';
  bool isTesting = false;

  void micTest() {
    setState(() => isTesting = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => isTesting = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 20),
        children: [
          const Text('설정', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          const Text('앱 환경을 설정하세요', style: TextStyle(color: Color(0xFF64748B))),
          const SizedBox(height: 16),
          _section(icon: Icons.language, color: appBlue, title: '언어 설정', sub: '앱 표시 언어', child: Column(children: [
            _languageTile('ko', '한국어'),
            const SizedBox(height: 8),
            _languageTile('en', 'English'),
          ])),
          const SizedBox(height: 14),
          _section(icon: Icons.mic, color: Colors.purple, title: '마이크 설정', sub: '녹음 권한 관리', child: Column(children: [
            Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16)), child: const Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('마이크 권한', style: TextStyle(fontWeight: FontWeight.w800)), Text('녹음 기능 사용', style: TextStyle(color: Color(0xFF64748B), fontSize: 12))])), Pill(text: '허용됨', background: Color(0xFFDCFCE7), foreground: Color(0xFF15803D))])),
            const SizedBox(height: 12),
            PrimaryButton(text: isTesting ? '테스트 중...' : '마이크 테스트', color: Colors.purple, onPressed: isTesting ? null : micTest),
            if (isTesting) ...[
              const SizedBox(height: 12),
              Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFFAF5FF), borderRadius: BorderRadius.circular(16)), child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: List.generate(8, (i) => Container(width: 7, height: 10 + Random().nextInt(28).toDouble(), margin: const EdgeInsets.symmetric(horizontal: 3), decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(99))))),
                const SizedBox(height: 8),
                const Text('마이크 입력 감지 중', style: TextStyle(color: Colors.purple)),
              ])),
            ]
          ])),
          const SizedBox(height: 14),
          _section(icon: Icons.shield_outlined, color: Colors.green, title: '개인정보 보호', sub: '데이터 처리 안내', child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(16)), child: const Text('녹음된 음성 데이터는 발음 분석 목적으로만 사용되며, 모든 처리는 안전하게 이루어집니다.', style: TextStyle(color: Color(0xFF166534), height: 1.45)))),
          const SizedBox(height: 14),
          OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.logout), label: const Text('로그아웃'), style: OutlinedButton.styleFrom(foregroundColor: Colors.red, minimumSize: const Size.fromHeight(54), side: BorderSide.none, backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)))),
        ],
      ),
    );
  }

  Widget _section({required IconData icon, required Color color, required String title, required String sub, required Widget child}) => AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [CircleAvatar(backgroundColor: color.withOpacity(.12), child: Icon(icon, color: color)), const SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)), Text(sub, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12))])]), const SizedBox(height: 16), child]));

  Widget _languageTile(String value, String label) {
    final active = language == value;
    return InkWell(onTap: () => setState(() => language = value), child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: active ? const Color(0xFFEFF6FF) : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: active ? appBlue : const Color(0xFFE2E8F0), width: 2)), child: Row(children: [Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))), if (active) const Icon(Icons.check_circle, color: appBlue)])));
  }
}
