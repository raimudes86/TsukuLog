import 'package:flutter/material.dart';

class RightMajorModalPage extends StatefulWidget {
  const RightMajorModalPage({super.key, required this.selectedOptions});

  /// 呼び出し元で持っている「すでに選択済みの進路リスト」を受け取る
  final List<String> selectedOptions;

  @override
  State<RightMajorModalPage> createState() => _RightMajorModalPageState();
}

class _RightMajorModalPageState extends State<RightMajorModalPage> {
  /// モーダル内で操作する選択リスト
  late List<String> _selectedOptions;

  /// マルチセレクトの選択肢
  final List<String> _allOptions = [
    "情報科学類",
    "情報メディア創成学類",
    "知識情報図書館学類",
    "数学類",
    "物理学類",
    "化学類",
    "応用理工学類",
    "工学システム学類",
    "社会工学類",
    "生物学類",
    "地球学類",
    "生物資源学類",
    "医学類",
    "看護学類",
    "医療科学類",
    "体育専門学群",
    "芸術専門学群",
    "人文学類",
    "比較文化学類",
    "日本語・日本文化学類",
    "社会学類",
    "国際総合学類",
    "総合学域群文系",
    "総合学域群第一類",
    "総合学域群第二類",
    "総合学域群第三類",
    "心理学類",
    "教育学類",
    "障害科学類",
    "人文社会科学研究群",
    "ビジネス科学研究群",
    "法曹専攻",
    "国際経営プロフェッショナル",
    "数理物質科学研究群",
    "システム情報工学研究群",
    "生命地球科学研究群",
    "国際連携持続環境科学",
    "人間総合科学研究群",
    "スポーツ国際開発学共同",
    "大学体育スポーツ高度化共同",
    "国際連携食料健康科学",
    "グローバル教育院",
  ];

  @override
  void initState() {
    super.initState();
    // 呼び出し元からの配列を代入
    _selectedOptions = List.from(widget.selectedOptions);
  }

  /// 選択がトグルされたら、_selectedOptions を更新する
  void _toggleSelected(String option) {
    setState(() {
      if (_selectedOptions.contains(option)) {
        // すでに入っていれば外す
        _selectedOptions.remove(option);
      } else {
        // 入っていなければ追加する
        _selectedOptions.add(option);
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
                title: const Text('進路選択'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    // 戻るときに現在の選択状態を返す
                    Navigator.pop(context, _selectedOptions);
                  },
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // 全てクリアにしたい場合は空リストへ
                        _selectedOptions.clear();
                      });
                    },
                    child: const Padding(
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
                  itemCount: _allOptions.length,
                  itemBuilder: (context, index) {
                    final option = _allOptions[index];
                    return CheckboxListTile(
                      title: Text(option),
                      value: _selectedOptions.contains(option),
                      onChanged: (bool? checked) {
                        if (checked != null) {
                          _toggleSelected(option);
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
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {
                      // 決定時に選択リストを戻す
                      Navigator.pop(context, _selectedOptions);
                    },
                    child: const Text('決定する'),
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
