import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tsukulog/models/user.dart';

class ProfileForm extends StatefulWidget {
  final User user; // ユーザー
  final VoidCallback onSaveComplete; // 保存完了時のコールバック

  const ProfileForm({
    super.key,
    required this.user,
    required this.onSaveComplete,
  });

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();
  String? _futurePath;
  String? _grade;
  String? _major;
  int? _selectedIcon;
  List<String>? _tags;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nicknameController.text = widget.user.nickname;
    _futurePath = widget.user.futurePath;
    _grade = widget.user.grade;
    _major = widget.user.major;
    _selectedIcon = widget.user.selectedIcon;
    _tags = widget.user.tags;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      // フォームが無効の場合は何もしない
      return;
    }

    setState(() {
      _isSaving = true; // 保存中のインジケータを表示
    });

    try {
      final docRef =
          FirebaseFirestore.instance.collection('users').doc(widget.user.id);

      // 編集
      await docRef.update({
        'nickname': _nicknameController.text,
        'future_path': _futurePath,
        'grade': _grade,
        'major': _major,
        'selected_icon': _selectedIcon,
        'tags': _tags,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('更新しました！')),
        );
        widget.onSaveComplete(); // 保存完了時のコールバック
        Navigator.pop(context); // フォームを閉じる
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラーが発生しました: $e')),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> futurePaths = [
      '就職',
      '進学',
      '迷い中',
    ];

    final List<String> majors = [
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

    final List<String> grades = [
      'B1',
      'B2',
      'B3',
      'B4',
      'M1',
      'M2',
      'D1',
      'D2',
      'D3'
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: 'ニックネーム',
                hintText: '例）山田太郎',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '10文字以内のニックネームを入力してください';
                }
                if (value.length < 2 || value.length > 10) {
                  return 'ニックネームは2~10文字で入力してください';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _grade,
              decoration: const InputDecoration(
                labelText: '学年',
                border: OutlineInputBorder(),
              ),
              hint: const Text('選択してください'),
              items: grades
                  .map((grade) =>
                      DropdownMenuItem(value: grade, child: Text(grade)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _grade = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '学年を選択してください';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _major,
              decoration: const InputDecoration(
                labelText: '学類・研究群・専攻',
                border: OutlineInputBorder(),
              ),
              hint: const Text('選択してください'),
              items: majors
                  .map((major) =>
                      DropdownMenuItem(value: major, child: Text(major)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _major = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '学年を選択してください';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _futurePath,
              decoration: const InputDecoration(
                labelText: '進路',
                border: OutlineInputBorder(),
              ),
              hint: const Text('選択してください'),
              items: futurePaths
                  .map((futurePath) => DropdownMenuItem(
                      value: futurePath, child: Text(futurePath)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _futurePath = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '進路を選択してください';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // アイコンの選択用ウィジェット
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(9, (index) {
                final iconIndex = index + 1;
                final isSelected = _selectedIcon == iconIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIcon = iconIndex;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/images/icon$iconIndex.webp',
                      width: 50,
                      height: 50,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            // 保存ボタン
            _isSaving
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _saveProfile,
                    child: Text('更新'),
                  ),
          ],
        ),
      ),
    );
  }
}
