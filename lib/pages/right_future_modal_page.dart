import 'package:flutter/material.dart';

class RightFutureModalPage extends StatefulWidget {
  const RightFutureModalPage({super.key, required this.selectedOptions});

  /// 呼び出し元で持っている「すでに選択済みの進路リスト」を受け取る
  final List<String> selectedOptions;

  @override
  State<RightFutureModalPage> createState() => _RightFutureModalPageState();
}

class _RightFutureModalPageState extends State<RightFutureModalPage> {
  /// モーダル内で操作する選択リスト
  late List<String> _selectedOptions;

  /// マルチセレクトの選択肢
  final List<String> _allOptions = [
    "進学",
    "就職",
    "進学or就職",
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
