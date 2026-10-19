import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';

void main() {
  runApp(const NoticeApp());
}

class NoticeApp extends StatelessWidget {
  const NoticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI 바이브 비동기 공지 앱',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const NoticeHomePage(),
    );
  }
}

class NoticeHomePage extends StatefulWidget {
  const NoticeHomePage({super.key});

  @override
  State<NoticeHomePage> createState() => _NoticeHomePageState();
}

class _NoticeHomePageState extends State<NoticeHomePage> {
  // [Stream 관련] 실시간 공지사항 스트림 컨트롤러
  final StreamController<List<String>> _noticeStreamController = StreamController<List<String>>();
  final List<String> _noticeList = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 앱이 켜지면 초기 공지사항 로드
    _loadInitialNotices();
  }

  // 1. [Future 및 async/await 변환] 초기 공지사항 데이터 통신 시뮬레이션
  Future<void> _loadInitialNotices() async {
    setState(() => _isLoading = true);

    // 2초간 서버 통신을 대기하는 비동기 처리
    await Future.delayed(const Duration(seconds: 2));

    _noticeList.addAll([
      '[공지] 2026년 2학기 모바일 프로그래밍 과제 안내',
      '[안내] 플러터 크롬 웹 및 Windows 앱 환경 설정 가이드',
      '[점검] 데이터베이스 서버 안정화 작업 안내 (화요일 02:00)'
    ]);

    // 스트림에 데이터를 흘려보내 화면을 갱신시킵니다.
    _noticeStreamController.add(_noticeList);
    setState(() => _isLoading = false);
  }

  // 2. [Isolate 관련] 백그라운드에서 무거운 공지사항 텍스트 가공 처리
  // Isolate 내부에서는 메인 UI 스레드와 격리되므로 무거운 연산을 처리하기 적합합니다.
  static void _heavyDataProcessing(SendPort sendPort) {
    // 렉을 유발할 수 있는 무거운 연산이나 대용량 문자열 제어 시뮬레이션
    String rawData = "🚨 [긴급 시스템 업데이트] 비동기 Isolate 백그라운드 스레드에서 안전하게 가공 처리된 실시간 공지사항 알림입니다.";
    
    // 메인 Isolate(UI 스레드)로 가공된 결과 전달
    sendPort.send(rawData);
  }

  // 버튼 클릭 시 Isolate를 실행하고 Stream으로 결과를 토스하는 함수
  Future<void> _fetchHeavyNoticeWithIsolate() async {
    // 소통 창구인 ReceivePort 개설
    final receivePort = ReceivePort();
    
    // 새로운 Isolate 생성 (백그라운드 스레드 가동)
    await Isolate.spawn(_heavyDataProcessing, receivePort.sendPort);

    // Isolate로부터 결과를 수신할 때까지 비동기 대기
    final heavyResult = await receivePort.first as String;

    // 받아온 무거운 데이터를 리스트에 추가하고 Stream에 push!
    setState(() {
      _noticeList.insert(0, heavyResult);
    });
    _noticeStreamController.add(_noticeList);
  }

  @override
  void dispose() {
    _noticeStreamController.close(); // 스트림 리소스 해제 필수
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💡 AI 비동기 공지사항 시스템'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        //padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 상단 배너 및 조작 버튼
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Future, async/await, Stream, Isolate가 모두 동작 중입니다.',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.indigo),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _fetchHeavyNoticeWithIsolate,
                      icon: const Icon(Icons.flash_on),
                      label: const Text('Isolate 백그라운드 공지 가져오기'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // 하단 실시간 공지사항 뷰어 영역 (StreamBuilder 사용)
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : StreamBuilder<List<String>>(
                      stream: _noticeStreamController.stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('등록된 공지사항이 없습니다.'));
                        }
                        
                        final notices = snapshot.data!;
                        return ListView.builder(
                          itemCount: notices.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                leading: const Icon(Icons.campaign, color: Colors.deepOrange),
                                title: Text(notices[index]),
                                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                              ),
                            );
                          },
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
