import 'package:flutter/material.dart';

class RightGradeModalPage extends StatefulWidget {
  const RightGradeModalPage({super.key, required this.grades});

  /// 呼び出し元で持っている「すでに選択済みの学年リスト」を受け取る
  final List<String> grades;

  @override
  State<RightGradeModalPage> createState() => _RightGradeModalPageState();
}

class _RightGradeModalPageState extends State<RightGradeModalPage> {
  /// モーダルで操作する選択リスト
  late List<String> _selectedGrades;

  /// マルチセレクトの選択肢（例として B1, B2, B3, B4, M1, M2, D1, D2, D3）
  final List<String> _allGrades = [
    'B1',
    'B2',
    'B3',
    'B4',
    'M1',
    'M2',
    'D1',
    'D2',
    'D3',
  ];

  @override
  void initState() {
    super.initState();
    // 呼び出し元からの配列を代入
    _selectedGrades = List.from(widget.grades);
  }

  /// grade の選択がトグルされたら、_selectedGrades を更新する
  void _toggleSelectedGrade(String grade) {
    setState(() {
      if (_selectedGrades.contains(grade)) {
        // すでに入っていれば外す
        _selectedGrades.remove(grade);
      } else {
        // 入っていなければ追加する
        _selectedGrades.add(grade);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 背景を透過
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.centerRight,
        child: Container(
          // 画面サイズの 8 割のページ幅
          width: MediaQuery.of(context).size.width * 0.8,
          color: Colors.white,
          child: Column(
            children: [
              AppBar(
                title: Text('学年選択'),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    // 戻るときに現在の選択状態を返す
                    Navigator.pop(context, _selectedGrades);
                  },
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // 全てクリアにしたい場合は空リストへ
                        // もし「B1だけ選択状態で初期化したい」なら ["B1"] を代入
                        _selectedGrades.clear();
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'クリア',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _allGrades.length,
                  itemBuilder: (context, index) {
                    final grade = _allGrades[index];
                    return CheckboxListTile(
                      title: Text(grade),
                      value: _selectedGrades.contains(grade),
                      onChanged: (bool? checked) {
                        if (checked != null) {
                          _toggleSelectedGrade(grade);
                        }
                      },
                    );
                  },
                ),
              ),
              // 下部に「決定する」ボタン
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      minimumSize: Size(100, 50),
                    ),
                    onPressed: () {
                      // 決定時に選択リストを戻す
                      Navigator.pop(context, _selectedGrades);
                    },
                    child: Text('決定する'),
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
