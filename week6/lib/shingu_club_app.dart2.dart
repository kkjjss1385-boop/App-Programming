import 'package:flutter/material.dart';

void main() {
  runApp(const ShinguClubApp());
}

// 신구대학교 대표 연두색 테마 컬러
const Color shinguGreen = Color(0xFF8DC63F);
const Color shinguDarkGreen = Color(0xFF6DA22B);

class ShinguClubApp extends StatelessWidget {
  const ShinguClubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '신구대학교 동아리',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: shinguGreen,
          primary: shinguGreen,
          secondary: shinguDarkGreen,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F9F6),
        appBarTheme: const AppBarTheme(
          backgroundColor: shinguGreen,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const ClubHomePage(),
    );
  }
}

// 동아리 데이터 모델
class Club {
  final String id;
  final String name;
  final String category;
  final String description;
  final String location;
  final String leaderContact;
  final String imageUrl;

  Club({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.location,
    required this.leaderContact,
    required this.imageUrl,
  });
}

// 게시글 데이터 모델
class Post {
  final String id;
  final String author;
  final String title;
  final String content;
  final String date;

  Post({
    required this.id,
    required this.author,
    required this.title,
    required this.content,
    required this.date,
  });
}

final List<Club> sampleClubs = [
  Club(
    id: '1',
    name: '비트컴퓨터 (BIT)',
    category: '학술/IT',
    description: '코딩 및 앱 개발 스터디와 프로젝트 실습을 진행하는 신구대 대표 컴퓨터 동아리입니다.',
    location: '우촌관 402호',
    leaderContact: '010-1234-5678 (회장)',
    imageUrl: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800&q=80',
  ),
  Club(
    id: '2',
    name: '소울뮤직 (Soul Music)',
    category: '공연/예술',
    description: '보컬, 기타, 드럼 등 세션 공연 및 정기 버스킹을 진행하는 밴드 동아리입니다.',
    location: '학생회관 지하 101호',
    leaderContact: '010-2345-6789 (회장)',
    imageUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=800&q=80',
  ),
  Club(
    id: '3',
    name: '신구 슛돌이',
    category: '체육/운동',
    description: '축구 및 풋살을 즐기며 교내 리그 및 외부 대회에 참가하는 축구동아리입니다.',
    location: '대운동장 라커룸 3호',
    leaderContact: '010-3456-7890 (회장)',
    imageUrl: 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?w=800&q=80',
  ),
  Club(
    id: '4',
    name: '신구 봉사단',
    category: '봉사/사회',
    description: '지역사회 봉사활동, 유기견 봉사 등 따뜻한 나눔을 실천하는 봉사 동아리입니다.',
    location: '학생회관 204호',
    leaderContact: '010-4567-8901 (회장)',
    imageUrl: 'https://images.unsplash.com/photo-1559027615-cd4628902d4a?w=800&q=80',
  ),
];

// 신구대학교 로고 마크 위젯
class ShinguLogoMark extends StatelessWidget {
  final double size;
  const ShinguLogoMark({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.25),
        border: Border.all(color: shinguGreen, width: 2),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size * 0.18,
              height: size * 0.18,
              decoration: const BoxDecoration(
                color: shinguGreen,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              '新丘',
              style: TextStyle(
                fontSize: size * 0.28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClubHomePage extends StatefulWidget {
  const ClubHomePage({super.key});

  @override
  State<ClubHomePage> createState() => _ClubHomePageState();
}

class _ClubHomePageState extends State<ClubHomePage> {
  String selectedCategory = '전체';
  String searchQuery = '';
  final List<String> categories = ['전체', '학술/IT', '공연/예술', '체육/운동', '봉사/사회'];

  // 더미 로그인 상태
  bool isLoggedIn = false;
  String userName = '신구인';

  @override
  Widget build(BuildContext context) {
    final filteredClubs = sampleClubs.where((club) {
      final matchesCategory =
          selectedCategory == '전체' || club.category == selectedCategory;
      final matchesSearch =
          club.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              club.description.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: