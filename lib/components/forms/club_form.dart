import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tsukulog/models/club.dart';

class ClubForm extends StatefulWidget {
  final String uid; // ユーザーのUID（必須）
  final Club? club; // 編集時に使用するClubインスタンス（任意）
  final VoidCallback onSaveComplete; // 保存完了時のコールバック

  const ClubForm({
    super.key,
    required this.uid,
    this.club,
    required this.onSaveComplete,
  });

  @override
  State<ClubForm> createState() => _ClubFormState();
}

class _ClubFormState extends State<ClubForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // 編集の場合、Clubインスタンスから値をセット
    if (widget.club != null) {
      _nameController.text = widget.club!.name;
      _commentController.text = widget.club!.comment;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _saveClub() async {
    if (!_formKey.currentState!.validate()) {
      // フォームが無効の場合は何もしない
      return;
    }

    setState(() {
      _isSaving = true; // 保存中のインジケータを表示
    });

    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .collection('club');

      if (widget.club == null) {
        // 新規登録
        await docRef.add({
          'name': _nameController.text,
          'comment': _commentController.text,
        });
      } else {
        // 編集
        await docRef.doc(widget.club!.id).update({
          'name': _nameController.text,
          'comment': _commentController.text,
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.club == null ? '追加しました！' : '更新しました！')),
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

  Future<void> _deleteClub() async {
    setState(() {
      _isSaving = true; // 削除中のインジケータを表示
    });

    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .collection('club')
          .doc(widget.club!.id);

      await docRef.delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('削除しました！')),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 説明文
            const Text(
              '所属している部活、サークル、団体等について教えてください',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '団体名',
                hintText: '例）硬式テニス愛好会Forest',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '団体名を入力してください';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'コメント',
                hintText:
                    '例）めちゃくちゃ雰囲気のいいサークルです！一の矢にあるので、一の矢宿舎に入った人はぜひ参加してください！',
                hintStyle: TextStyle(fontSize: 12),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'コメントを入力してください';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _isSaving
                ? const CircularProgressIndicator() // 保存中はインジケータを表示
                : ElevatedButton(
                    onPressed: _saveClub,
                    child: Text(widget.club == null ? '追加' : '更新'),
                  ),
            if (widget.club != null)
              TextButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('削除の確認'),
                        content: const Text('削除しますか？この操作は取り消せません。'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('キャンセル'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('削除',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm == true) {
                    await _deleteClub();
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red, // 背景色を設定
                  foregroundColor: Colors.white, // テキストの色を設定
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // 角丸の形状に設定
                  ),
                ),
                child: const Text(
                  '削除',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
