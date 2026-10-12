import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// 1. MaterialApp: 앱의 시작
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Widget Tree Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// 2. Scaffold: 한 화면의 틀
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('위젯 트리 실습'),
        backgroundColor: Colors.blue.shade100,
      ),
      // 3. ListView: 스크롤 본문
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 4. Card: 관련 정보 묶음
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              // 5. Text: 실제 글자 (style 속성을 올바른 위치로 수정)
              child: const Text(
                '첫 번째 관련 정보 묶음입니다.',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                '두 번째 관련 정보 묶음입니다.',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                '세 번째 관련 정보 묶음입니다. (스크롤 가능)',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
