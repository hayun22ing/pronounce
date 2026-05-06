class Lesson {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final String pronunciationType;
  final int sceneCount;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.pronunciationType,
    required this.sceneCount,
  });
}

class SceneItem {
  final String id;
  final String lessonId;
  final String title;
  final String duration;
  final int sentenceCount;
  final String pronunciationFocus;
  final bool completed;

  const SceneItem({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.duration,
    required this.sentenceCount,
    required this.pronunciationFocus,
    required this.completed,
  });
}

class PracticeSentence {
  final String id;
  final String sceneId;
  final String text;
  final String targetWord;

  const PracticeSentence({
    required this.id,
    required this.sceneId,
    required this.text,
    required this.targetWord,
  });
}

class Attempt {
  final String id;
  final String sentenceText;
  final String date;
  final int overallScore;
  final int consonantScore;
  final int vowelScore;
  final int intonationScore;

  const Attempt({
    required this.id,
    required this.sentenceText,
    required this.date,
    required this.overallScore,
    required this.consonantScore,
    required this.vowelScore,
    required this.intonationScore,
  });
}

const lessons = [
  Lesson(id: '1', title: '기본 인사 연습', description: '짧은 문장으로 자연스럽게 인사하기', difficulty: 'easy', pronunciationType: '모음', sceneCount: 2),
  Lesson(id: '2', title: '학교 생활 표현', description: '학교에서 자주 쓰는 표현 연습', difficulty: 'medium', pronunciationType: '억양', sceneCount: 3),
  Lesson(id: '3', title: '감정 표현하기', description: '상황에 맞는 말투와 억양 연습', difficulty: 'hard', pronunciationType: '받침', sceneCount: 2),
];

const scenes = [
  SceneItem(id: 's1', lessonId: '1', title: '첫 만남', duration: '00:28', sentenceCount: 3, pronunciationFocus: 'ㅓ/ㅗ 구분, 문장 끝 억양', completed: false),
  SceneItem(id: 's2', lessonId: '1', title: '친구에게 인사하기', duration: '00:34', sentenceCount: 3, pronunciationFocus: '받침 연음', completed: true),
  SceneItem(id: 's3', lessonId: '2', title: '수업 전 대화', duration: '00:41', sentenceCount: 4, pronunciationFocus: '질문 억양', completed: false),
  SceneItem(id: 's4', lessonId: '2', title: '발표 준비', duration: '00:37', sentenceCount: 3, pronunciationFocus: '문장 강세', completed: false),
  SceneItem(id: 's5', lessonId: '3', title: '놀람 표현', duration: '00:31', sentenceCount: 3, pronunciationFocus: '감정 억양', completed: false),
];

const sentences = [
  PracticeSentence(id: 'p1', sceneId: 's1', text: '안녕하세요, 처음 뵙겠습니다.', targetWord: '처음'),
  PracticeSentence(id: 'p2', sceneId: 's1', text: '만나서 정말 반가워요.', targetWord: '반가워요'),
  PracticeSentence(id: 'p3', sceneId: 's1', text: '오늘 날씨가 참 좋네요.', targetWord: '좋네요'),
  PracticeSentence(id: 'p4', sceneId: 's2', text: '오랜만이야, 잘 지냈어?', targetWord: '오랜만'),
  PracticeSentence(id: 'p5', sceneId: 's3', text: '숙제는 다 했어?', targetWord: '숙제'),
  PracticeSentence(id: 'p6', sceneId: 's4', text: '발표는 언제 시작해?', targetWord: '발표'),
  PracticeSentence(id: 'p7', sceneId: 's5', text: '정말 깜짝 놀랐어!', targetWord: '깜짝'),
];

const attemptHistory = [
  Attempt(id: 'a1', sentenceText: '안녕하세요, 처음 뵙겠습니다.', date: '2026-04-21', overallScore: 88, consonantScore: 86, vowelScore: 90, intonationScore: 84),
  Attempt(id: 'a2', sentenceText: '만나서 정말 반가워요.', date: '2026-04-21', overallScore: 82, consonantScore: 80, vowelScore: 85, intonationScore: 81),
  Attempt(id: 'a3', sentenceText: '숙제는 다 했어?', date: '2026-04-19', overallScore: 76, consonantScore: 78, vowelScore: 74, intonationScore: 76),
  Attempt(id: 'a4', sentenceText: '정말 깜짝 놀랐어!', date: '2026-04-18', overallScore: 91, consonantScore: 92, vowelScore: 89, intonationScore: 93),
];
