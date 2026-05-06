import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/common_widgets.dart';
import 'result_screen.dart';

enum LearnState { playing, paused, recording, recorded, analyzing, error }

class LearnScreen extends StatefulWidget {
  final String lessonId;
  final String sceneId;
  final String sentenceId;

  const LearnScreen({
    super.key,
    required this.lessonId,
    required this.sceneId,
    required this.sentenceId,
  });

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  LearnState state = LearnState.playing;
  double videoProgress = 0;
  double recordingTime = 0;
  Timer? timer;
  final random = Random();
  String analyzingMessage = '발음을 살펴보고 있어요';

  PracticeSentence get sentence =>
      sentences.firstWhere((s) => s.id == widget.sentenceId);

  List<PracticeSentence> get sceneSentences =>
      sentences.where((s) => s.sceneId == widget.sceneId).toList();

  int get currentIndex =>
      sceneSentences.indexWhere((s) => s.id == widget.sentenceId);

  @override
  void initState() {
    super.initState();
    _playVideo();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _playVideo() {
    timer?.cancel();
    setState(() {
      state = LearnState.playing;
      videoProgress = 0;
    });

    timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      setState(() => videoProgress += 2);
      if (videoProgress >= 45) {
        t.cancel();
        setState(() => state = LearnState.paused);
      }
    });
  }

  void _startRecording() {
    timer?.cancel();
    setState(() {
      state = LearnState.recording;
      recordingTime = 0;
    });

    timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => setState(() => recordingTime += .1),
    );
  }

  void _submit() {
    timer?.cancel();
    setState(() {
      state = LearnState.analyzing;
      analyzingMessage = '발음을 살펴보고 있어요';
    });

    final messages = ['발음을 살펴보고 있어요', '억양을 비교하고 있어요', '점수를 계산하고 있어요'];
    var idx = 0;

    timer = Timer.periodic(const Duration(milliseconds: 1000), (_) {
      idx = (idx + 1) % messages.length;
      setState(() => analyzingMessage = messages[idx]);
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      timer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            lessonId: widget.lessonId,
            sceneId: widget.sceneId,
            sentenceId: widget.sentenceId,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '뒤로가기 · ${currentIndex + 1} / ${sceneSentences.length}',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              for (int i = 0; i < sceneSentences.length; i++)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == currentIndex
                          ? appBlue
                          : i < currentIndex
                              ? Colors.green
                              : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          _videoArea(),
          const SizedBox(height: 18),
          _sentenceCard(),
          const SizedBox(height: 18),
          _stateArea(),
        ],
      ),
    );
  }

  Widget _videoArea() {
    final isPlaying = state == LearnState.playing;

    return Container(
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF020617)],
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.play_circle_fill,
                  color: Colors.white.withOpacity(isPlaying ? 1 : .5),
                  size: 72,
                ),
                const SizedBox(height: 8),
                Text(
                  isPlaying ? '영상 재생 중' : '일시정지',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: LinearProgressIndicator(
              value: videoProgress / 100,
              backgroundColor: Colors.white12,
              color: appBlue,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sentenceCard() {
    final muted = state == LearnState.playing;

    return AnimatedOpacity(
      opacity: muted ? .55 : 1,
      duration: const Duration(milliseconds: 250),
      child: AppCard(
        child: Column(
          children: [
            Text(
              sentence.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: muted ? 19 : 25,
                fontWeight: FontWeight.w900,
                height: 1.45,
                color: const Color(0xFF0F172A),
              ),
            ),
            if (!muted) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '주목할 단어',
                      style: TextStyle(color: Color(0xFF1D4ED8), fontSize: 12),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      sentence.targetWord,
                      style: const TextStyle(
                        color: Color(0xFF1E3A8A),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _stateArea() {
    switch (state) {
      case LearnState.paused:
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _playVideo,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('다시 듣기'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _playVideo,
                    icon: const Icon(Icons.speed),
                    label: const Text('천천히'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              text: '녹음 시작하기',
              icon: Icons.mic,
              onPressed: _startRecording,
            ),
          ],
        );

      case LearnState.recording:
        return Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
            ),
          ),
          child: Column(
            children: [
              const Text(
                '● 녹음 중',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${recordingTime.toStringAsFixed(1)}초',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  12,
                  (i) => Container(
                    width: 6,
                    height: 18 + random.nextInt(45).toDouble(),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                '천천히 따라 말해봐',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => state = LearnState.paused),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                      ),
                      child: const Text('취소'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        timer?.cancel();
                        setState(() => state = LearnState.recorded);
                      },
                      child: const Text('완료'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      case LearnState.recorded:
        return AppCard(
          child: Column(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 56),
              const SizedBox(height: 8),
              const Text(
                '녹음 완료!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.volume_up),
                label: const Text('내 녹음 듣기'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _startRecording,
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('다시 녹음'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: const Text('제출하기'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      case LearnState.analyzing:
        return Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
            ),
          ),
          child: Column(
            children: [
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 20),
              Text(
                analyzingMessage,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '잠시만 기다려주세요',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        );

      case LearnState.error:
        return AppCard(
          child: Column(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const Text('분석 중 오류가 발생했어요'),
              const SizedBox(height: 10),
              PrimaryButton(
                text: '다시 시도하기',
                onPressed: () => setState(() => state = LearnState.paused),
              ),
            ],
          ),
        );

      case LearnState.playing:
        return const SizedBox.shrink();
    }
  }
}
