import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tsukulog/models/career_history.dart';

class CareerHistoryForm extends StatefulWidget {
  final String uid; // ユーザーのUID
  final String bestCareerId; // ベストキャリアのID
  final CareerHistory? careerHistory; // 編集時に使用するCareerHistoryインスタンス
  final VoidCallback onSaveComplete; // 保存完了時のコールバック

  const CareerHistoryForm({
    super.key,
    required this.uid,
    required this.bestCareerId,
    this.careerHistory,
    required this.onSaveComplete,
  });

  @override
  State<CareerHistoryForm> createState() => _CareerHistoryFormState();
}

class _CareerHistoryFormState extends State<CareerHistoryForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  String? _selectedCategory;
  String? _startGrade;
  int? _startMonth;
  String? _span;
  int _difficultLevel = 0;
  int _recommendLevel = 0;
  bool _isBestCareer = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // 編集の場合、初期値を設定
    if (widget.careerHistory != null) {
      _titleController.text = widget.careerHistory!.title;
      _selectedCategory = widget.careerHistory!.category;
      _startGrade = widget.careerHistory!.startGrade;
      _startMonth = widget.careerHistory!.startMonth;
      _span = widget.careerHistory!.span;
      _difficultLevel = widget.careerHistory!.difficultLevel;
      _recommendLevel = widget.careerHistory!.recommendLevel;
      _reasonController.text = widget.careerHistory!.reason;
      _commentController.text = widget.careerHistory!.comment;
      _isBestCareer = widget.careerHistory!.id == widget.bestCareerId;
      _companyController.text = widget.careerHistory!.company;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _reasonController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _saveCareerHistory() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(widget.uid);
      final careerHistoryCollectionRef =
          userDocRef.collection('career_history');
      final String? company =
          _companyController.text.isNotEmpty ? _companyController.text : null;

      DocumentReference docRef;

      // 保存または更新処理
      if (widget.careerHistory == null) {
        // 新規登録
        docRef = await careerHistoryCollectionRef.add({
          'title': _titleController.text,
          'category': _selectedCategory,
          'start_grade': _startGrade,
          'start_month': _startMonth,
          'span': _span,
          'difficult_level': _difficultLevel,
          'recommend_level': _recommendLevel,
          'reason': _reasonController.text,
          'comment': _commentController.text,
          'company': company,
        });
      } else {
        // 編集
        docRef = careerHistoryCollectionRef.doc(widget.careerHistory!.id);
        await docRef.update({
          'title': _titleController.text,
          'category': _selectedCategory,
          'start_grade': _startGrade,
          'start_month': _startMonth,
          'span': _span,
          'difficult_level': _difficultLevel,
          'recommend_level': _recommendLevel,
          'reason': _reasonController.text,
          'comment': _commentController.text,
          'company': company,
        });
      }

      // ベストキャリアの更新
      if (_isBestCareer) {
        await userDocRef.update({'best_career_id': docRef.id});
      }

      // companies リストの更新
      if (company != null) {
        final userSnapshot = await userDocRef.get();
        final List<dynamic> companies = userSnapshot.data()?['companies'] ?? [];

        if (!companies.contains(company)) {
          companies.add(company);
          await userDocRef.update({'companies': companies});
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(widget.careerHistory == null ? '追加しました！' : '更新しました！')),
        );
        widget.onSaveComplete();
        Navigator.pop(context);
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

  Future<void> _deleteCareerHistory() async {
    setState(() {
      _isSaving = true; // 削除中のインジケータを表示
    });

    try {
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(widget.uid);
      final docRef =
          userDocRef.collection('career_history').doc(widget.careerHistory!.id);

      // キャリアヒストリー削除前にcompanyを取得
      final careerHistorySnapshot = await docRef.get();
      final String? company = careerHistorySnapshot.data()?['company'];

      // キャリアヒストリードキュメントを削除
      await docRef.delete();

      // companyが設定されている場合、companiesリストから削除
      if (company != null) {
        final userSnapshot = await userDocRef.get();
        final List<dynamic> companies = userSnapshot.data()?['companies'] ?? [];

        if (companies.contains(company)) {
          companies.remove(company);
          await userDocRef.update({'companies': companies});
        }
      }

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
    final List<String> categories = [
      '短期インターン',
      '長期インターン',
      'アルバイト',
      'ハッカソン',
      '学生組織',
      '授業',
      'コンペ',
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

    final List<String> months = List.generate(12, (index) => '${index + 1}月');
    final List<String> spans = [
      '1週間未満',
      '1週間',
      '2週間',
      '3週間',
      '1ヶ月',
      '2ヶ月',
      '3ヶ月',
      '4ヶ月',
      '5ヶ月',
      '半年',
      '1年',
      '1年半',
      '2年',
      '2年半',
      '3年',
      '3年以上',
      '現在まで'
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // 説明文
            const Text(
              'バイト、インターン、学生団体、ハッカソン等に参加した際の経験について教えてください',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '経歴タイトル',
                hintText: '例）株式会社〇〇, 〇〇ハッカソン',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '経歴タイトルを入力してください';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'カテゴリー',
                border: OutlineInputBorder(),
              ),
              hint: const Text('選択してください'),
              items: categories
                  .map((category) =>
                      DropdownMenuItem(value: category, child: Text(category)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'カテゴリーを選択してください';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _startGrade,
                    decoration: const InputDecoration(
                      labelText: '開始学年',
                      border: OutlineInputBorder(),
                    ),
                    items: grades
                        .map((grade) => DropdownMenuItem(
                              value: grade,
                              child: Text(grade),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _startGrade = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '開始学年を選択してください';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _startMonth != null ? '$_startMonth月' : null,
                    decoration: const InputDecoration(
                      labelText: '開始月',
                      border: OutlineInputBorder(),
                    ),
                    items: months
                        .map((month) => DropdownMenuItem(
                              value: month,
                              child: Text(month),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        // 選択された値から '月' を削除して数値に変換
                        _startMonth = int.tryParse(value!.replaceAll('月', ''));
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '開始月を選択してください';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _span,
              decoration: const InputDecoration(
                labelText: '期間',
                border: OutlineInputBorder(),
              ),
              hint: const Text('選択してください'),
              items: spans
                  .map((span) =>
                      DropdownMenuItem(value: span, child: Text(span)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _span = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '期間を選択してください';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ハードル'),
                      Slider(
                        value: _difficultLevel.toDouble(),
                        min: 0,
                        max: 5,
                        divisions: 5,
                        label: '$_difficultLevel',
                        onChanged: (value) {
                          setState(() {
                            _difficultLevel = value.toInt();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('おすすめ度'),
                      Slider(
                        value: _recommendLevel.toDouble(),
                        min: 0,
                        max: 5,
                        divisions: 5,
                        label: '$_recommendLevel',
                        onChanged: (value) {
                          setState(() {
                            _recommendLevel = value.toInt();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: '入ったきっかけ・目的・応募経路等',
                hintText:
                    '例）エンジニアとして働く上で技術力を身につけたいと思い、Railsを使っている企業という条件でWantedlyを使って探しました。',
                hintStyle: TextStyle(fontSize: 12),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'きっかけ等を入力してください';
                }
                return null;
              },
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'コメント',
                hintText:
                    '例）やりたいことをやらせてくれる環境があり、私自身最初はバックエンドでしたが、希望を伝えてフロントエンドのタスクに取り組めました。勉強会も頻繁に開催されており、成長を求める人には最高の環境だと思います。',
                hintStyle: TextStyle(fontSize: 12),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'コメントを入力してください';
                }
                return null;
              },
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _companyController,
              decoration: const InputDecoration(
                labelText: 'この経歴に関連する企業名（任意）',
                hintText: '例）株式会社〇〇',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _isBestCareer,
                  onChanged: (value) {
                    setState(() {
                      _isBestCareer = value ?? false;
                    });
                  },
                ),
                const Text('これをベストキャリアにする'),
              ],
            ),
            const SizedBox(height: 16),
            // 保存ボタン
            _isSaving
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _saveCareerHistory,
                    child: Text(widget.careerHistory == null ? '追加' : '更新'),
                  ),
            if (widget.careerHistory != null)
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
                    await _deleteCareerHistory();
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
