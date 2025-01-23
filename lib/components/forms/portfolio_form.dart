import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tsukulog/models/portfolio.dart';

class PortfolioForm extends StatefulWidget {
  final String uid; // ユーザーのUID（必須）
  final PortFolio? portfolio; // 編集時に使用するPortfolioインスタンス（任意）
  final VoidCallback onSaveComplete; // 保存完了時のコールバック

  const PortfolioForm({
    super.key,
    required this.uid,
    this.portfolio,
    required this.onSaveComplete,
  });

  @override
  State<PortfolioForm> createState() => _PortfolioFormState();
}

class _PortfolioFormState extends State<PortfolioForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // 編集の場合、Suggestインスタンスから値をセット
    if (widget.portfolio != null) {
      _nameController.text = widget.portfolio!.name;
      _commentController.text = widget.portfolio!.comment;
      _linkController.text = widget.portfolio!.link;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _savePortfolio() async {
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
          .collection('portfolio');

      if (widget.portfolio == null) {
        // 新規登録
        await docRef.add({
          'name': _nameController.text,
          'comment': _commentController.text,
          'link': _linkController.text,
        });
      } else {
        // 編集
        await docRef.doc(widget.portfolio!.id).update({
          'name': _nameController.text,
          'comment': _commentController.text,
          'link': _linkController.text,
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(widget.portfolio == null ? '追加しました！' : '更新しました！')),
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

  Future<void> _deletePortfolio() async {
    setState(() {
      _isSaving = true; // 削除中のインジケータを表示
    });

    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .collection('portfolio')
          .doc(widget.portfolio!.id);

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
              '公開しても良い制作物や成果物、ポートフォリオについて教えてください',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '制作物名',
                hintText: '例）カレンダーアプリ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '制作物名を入力してください';
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
                    '例）ハッカソンに参加した際に作成したカレンダーアプリです。Flutterを使用しています。いろんな人と予定を簡単に共有できるように設計しました。',
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
            TextFormField(
              controller: _linkController,
              decoration: const InputDecoration(
                labelText: '制作物リンク（任意）',
                hintText: '例）https://example.com',
                hintStyle: TextStyle(fontSize: 12),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            _isSaving
                ? const CircularProgressIndicator() // 保存中はインジケータを表示
                : ElevatedButton(
                    onPressed: _savePortfolio,
                    child: Text(widget.portfolio == null ? '追加' : '更新'),
                  ),
            if (widget.portfolio != null)
              ElevatedButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('削除の確認'),
                        content: const Text('この項目を削除しますか？この操作は取り消せません。'),
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
                    await _deletePortfolio();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // 背景色を設定
                  foregroundColor: Colors.white, // テキストの色を設定
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
