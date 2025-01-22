import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tsukulog/models/lesson.dart';

class LessonForm extends StatefulWidget {
  final String uid; // ユーザーのUID（必須）
  final Lesson? lesson; // 編集時に使用するLessonインスタンス（任意）
  final VoidCallback onSaveComplete; // 保存完了時のコールバック

  const LessonForm({
    super.key,
    required this.uid,
    this.lesson,
    required this.onSaveComplete,
  });

  @override
  State<LessonForm> createState() => _LessonFormState();
}

class _LessonFormState extends State<LessonForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // 編集の場合、Suggestインスタンスから値をセット
    if (widget.lesson != null) {
      _nameController.text = widget.lesson!.name;
      _commentController.text = widget.lesson!.comment;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _saveLesson() async {
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
          .collection('lesson');

      if (widget.lesson == null) {
        // 新規登録
        await docRef.add({
          'name': _nameController.text,
          'comment': _commentController.text,
        });
      } else {
        // 編集
        await docRef.doc(widget.lesson!.id).update({
          'name': _nameController.text,
          'comment': _commentController.text,
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(widget.lesson == null ? '追加しました！' : '更新しました！')),
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

  Future<void> _deleteLesson() async {
    setState(() {
      _isSaving = true; // 削除中のインジケータを表示
    });

    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .collection('lesson')
          .doc(widget.lesson!.id);

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
              '筑波大学の授業の中で他の人にオススメしたい授業を教えてください',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '授業名',
                hintText: '例）プログラミングチャレンジ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '授業名を入力してください';
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
                    '例）毎週競プロの問題が出題されて、それを解けば単位がもらえる授業。課題は難しくて大変なのは間違いないが、やり切ったら確実に実力が付いたのを実感できる',
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
                    onPressed: _saveLesson,
                    child: Text(widget.lesson == null ? '追加' : '更新'),
                  ),
            if (widget.lesson != null)
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
                    await _deleteLesson();
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
