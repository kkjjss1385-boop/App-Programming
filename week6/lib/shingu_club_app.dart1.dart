import 'package:flutter/material.dart';

void main() {
  runApp(const ShinguClubApp());
}

class ShinguClubApp extends StatelessWidget {
  const ShinguClubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '신구대학교 동아리',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF003B72),
          primary: const Color(0xFF003B72),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF003B72),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const ClubHomePage(),
    );
  }
}

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

final List<Club> sampleClubs = [
  Club(
    id: '1',
    name: '비트컴퓨터 (BIT)',
    category: '학술/IT',
    description: '코딩 및 앱 개발 스터디와 프로젝트 실습을 진행하는 컴퓨터 동아리입니다.',
    location: '우촌관 402호',
    leaderContact: '010-1234-5678',
    imageUrl: 'https://picsum.photos/id/1/500/300',
  ),
  Club(
    id: '2',
    name: '소울뮤직 (Soul Music)',
    category: '공연/예술',
    description: '보컬, 기타, 드럼 등 세션 공연 및 정기 버스킹을 진행하는 밴드 동아리입니다.',
    location: '학생회관 지하 101호',
    leaderContact: '010-2345-6789',
    imageUrl: 'https://picsum.photos/id/453/500/300',
  ),
  Club(
    id: '3',
    name: '신구 슛돌이',
    category: '체육/운동',
    description: '축구 및 풋살을 즐기며 교내 리그에 참가하는 축구동아리입니다.',
    location: '대운동장 라커룸 3호',
    leaderContact: '010-3456-7890',
    imageUrl: 'https://picsum.photos/id/1058/500/300',
  ),
  Club(
    id: '4',
    name: '신구 봉사단',
    category: '봉사/사회',
    description: '지역사회 봉사활동, 유기견 봉사 등 나눔을 실천합니다.',
    location: '학생회관 204호',
    leaderContact: '010-4567-8901',
    imageUrl: 'https://picsum.photos/id/823/500/300',
  ),
];

class ClubHomePage extends StatefulWidget {
  const ClubHomePage({super.key});

  @override
  State<ClubHomePage> createState() => _ClubHomePageState();
}

class _ClubHomePageState extends State<ClubHomePage> {
  String selectedCategory = '전체';
  String searchQuery = '';
  final List<String> categories = ['전체', '학술/IT', '공연/예술', '체육/운동', '봉사/사회'];

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
        title: const Text(
          '신구대학교 동아리 연합회',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF003B72),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: '동아리 이름 또는 설명 검색...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: const Color(0xFF003B72),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (bool selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: filteredClubs.isEmpty
                ? const Center(
                    child: Text(
                      '해당하는 동아리가 없습니다.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredClubs.length,
                    itemBuilder: (context, index) {
                      final club = filteredClubs[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClubDetailPage(club: club),
                              ),
                            );
                          },
                          child: Column(
                            //crossAxisAlignment: CrossAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.network(
                                  club.imageUrl,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    height: 150,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.group, size: 50),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  //crossAxisAlignment: CrossAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          club.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Chip(
                                          label: Text(
                                            club.category,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF003B72),
                                            ),
                                          ),
                                          backgroundColor:
                                              const Color(0xFFE8F0FE),
                                          visualDensity: VisualDensity.compact,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      club.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
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
    );
  }
}

class ClubDetailPage extends StatelessWidget {
  final Club club;

  const ClubDetailPage({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(club.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAlignment.start,
          children: [
            Image.network(
              club.imageUrl,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 220,
                color: Colors.grey[300],
                child: const Icon(Icons.group, size: 60),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                //crossAxisAlignment: CrossAlignment.start,
                children: [
                  Chip(
                    label: Text(
                      club.category,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: const Color(0xFF003B72),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '동아리 소개',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    club.description,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                  const Divider(height: 32),
                  ListTile(
                    leading: const Icon(Icons.location_on, color: Color(0xFF003B72)),
                    title: const Text('동아리방 위치'),
                    subtitle: Text(club.location),
                    contentPadding: EdgeInsets.zero,
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone, color: Color(0xFF003B72)),
                    title: const Text('문의처'),
                    subtitle: Text(club.leaderContact),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003B72),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClubApplyPage(clubName: club.name),
                ),
              );
            },
            child: const Text(
              '동아리 가입 신청하기',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class ClubApplyPage extends StatefulWidget {
  final String clubName;

  const ClubApplyPage({super.key, required this.clubName});

  @override
  State<ClubApplyPage> createState() => _ClubApplyPageState();
}

class _ClubApplyPageState extends State<ClubApplyPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _deptController = TextEditingController();
  final _phoneController = TextEditingController();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _deptController.dispose();
    _phoneController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('신청 완료'),
          content: Text('${widget.clubName} 가입 신청이 성공적으로 접수되었습니다!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.clubName} 가입 신청'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            //crossAxisAlignment: CrossAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '이름',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? '이름을 입력해주세요.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _studentIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '학번',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? '학번을 입력해주세요.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deptController,
                decoration: const InputDecoration(
                  labelText: '학과',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? '학과를 입력해주세요.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: '연락처',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone_android),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? '연락처를 입력해주세요.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _reasonController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: '지원 동기 및 포부',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? '지원 동기를 작성해주세요.' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003B72),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    '제출하기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}