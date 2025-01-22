import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tsukulog/models/qualification.dart';

class QualificationForm extends StatefulWidget {
  final String uid; // ユーザーのUID（必須）
  final Qualification? qualification; // 編集時に使用するQualificationインスタンス（任意）
  final VoidCallback onSaveComplete; // 保存完了時のコールバック

  const QualificationForm({
    super.key,
    required this.uid,
    this.qualification,
    required this.onSaveComplete,
  });

  @override
  State<QualificationForm> createState() => _SuggestFormState();
}

class _SuggestFormState extends State<QualificationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedYear;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // 編集の場合、Qualificationインスタンスから値をセット
    if (widget.qualification != null) {
      _nameController.text = widget.qualification!.name;
      _selectedYear = widget.qualification!.year;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveQualification() async {
    if (!_formKey.currentState!.validate()) {
      // フォームが無効の場合は何もしない
      return;
    }

    if (_selectedYear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('取得年を選択してください')),
      );
      return;
    }

    setState(() {
      _isSaving = true; // 保存中のインジケータを表示
    });

    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .collection('qualification');

      if (widget.qualification == null) {
        // 新規登録
        await docRef.add({
          'name': _nameController.text,
          'year': _selectedYear,
        });
      } else {
        // 編集
        await docRef.doc(widget.qualification!.id).update({
          'name': _nameController.text,
          'year': _selectedYear,
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(widget.qualification == null ? '追加しました！' : '更新しました！')),
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

  Future<void> _deleteQualification() async {
    setState(() {
      _isSaving = true; // 削除中のインジケータを表示
    });

    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .collection('qualification')
          .doc(widget.qualification!.id);

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
              '持っている資格や受賞歴について教えてください',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '資格名、受賞歴',
                hintText: '例）基本情報技術者試験',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '資格名、受賞歴を入力してください';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedYear,
              decoration: const InputDecoration(
                labelText: '取得年',
                border: OutlineInputBorder(),
              ),
              hint: const Text('取得年を選択してください'),
              items: List.generate(
                30,
                (index) => (DateTime.now().year - index).toString(),
              ).map((year) {
                return DropdownMenuItem<String>(
                  value: year,
                  child: Text(year),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedYear = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '取得年を選択してください';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _isSaving
                ? const CircularProgressIndicator() // 保存中はインジケータを表示
                : ElevatedButton(
                    onPressed: _saveQualification,
                    child: Text(widget.qualification == null ? '追加' : '更新'),
                  ),
            if (widget.qualification != null)
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
                    await _deleteQualification();
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
