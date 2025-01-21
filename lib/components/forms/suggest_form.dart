import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tsukulog/models/suggest.dart';

class SuggestForm extends StatefulWidget {
  final String uid; // ユーザーのUID（必須）
  final Suggest? suggest; // 編集時に使用するSuggestインスタンス（任意）
  final VoidCallback onSaveComplete; // 保存完了時のコールバック

  const SuggestForm({
    super.key,
    required this.uid,
    this.suggest,
    required this.onSaveComplete,
  });

  @override
  State<SuggestForm> createState() => _SuggestFormState();
}

class _SuggestFormState extends State<SuggestForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // 編集の場合、Suggestインスタンスから値をセット
    if (widget.suggest != null) {
      _nameController.text = widget.suggest!.name;
      _commentController.text = widget.suggest!.comment;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _saveSuggest() async {
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
          .collection('suggest');

      if (widget.suggest == null) {
        // 新規登録
        await docRef.add({
          'name': _nameController.text,
          'comment': _commentController.text,
        });
      } else {
        // 編集
        await docRef.doc(widget.suggest!.id).update({
          'name': _nameController.text,
          'comment': _commentController.text,
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(widget.suggest == null ? '追加しました！' : '更新しました！')),
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
              '就活においてやっておいて良かったこと、他の人にもオススメしたいことを教えてください',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'タイトル',
                hintText: '例）競プロの勉強をする',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'タイトルを入力してください';
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
                    '例）エンジニア就活の選考フローにはコーディングテストが存在することが多く、競プロを少しでもやっていると楽になると感じた。',
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
                    onPressed: _saveSuggest,
                    child: Text(widget.suggest == null ? '追加' : '更新'),
                  ),
          ],
        ),
      ),
    );
  }
}
