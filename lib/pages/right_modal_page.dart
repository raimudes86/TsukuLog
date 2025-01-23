import 'package:flutter/material.dart';
import 'package:tsukulog/pages/right_future_modal_page.dart';
import 'package:tsukulog/pages/right_grade_modal_page.dart';
import 'package:tsukulog/pages/right_major_modal_page.dart';

class RightModalPage extends StatefulWidget {
  const RightModalPage(
      {super.key,
      required this.grades,
      required this.futures,
      required this.majors});
  final List<String> grades;
  final List<String> futures;
  final List<String> majors;

  @override
  State<RightModalPage> createState() => _RightModalPageState();
}

class _RightModalPageState extends State<RightModalPage> {
  List<String> selectedGrades = [];
  List<String> selectedFutures = [];
  List<String> selectedMajor = [];
  @override
  void initState() {
    super.initState();
    // 呼び出し元からの配列をモーダル内変数に割り当て
    selectedGrades = widget.grades;
    selectedFutures = widget.futures;
    selectedMajor = widget.majors;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // 背景を透過
      body: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // 画面サイズの8割のページを作る
          color: Colors.white,
          child: Column(
            children: [
              AppBar(
                title: Text('絞り込み'),
                //leadingでタイトルに左に配置できる
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    final Map<String, List<String>> selectedparams = {
                      'grades': selectedGrades,
                      'futures': selectedFutures,
                      'majors': selectedMajor,
                    };
                    Navigator.pop(context, selectedparams);
                  },
                ),
                //actionsでタイトルの右に配置できる
                actions: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFutures = [];
                        selectedGrades = [];
                        selectedMajor = [];
                      });
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0), // 左右に余白を追加
                      child: Text('クリア', style: TextStyle(color: Colors.blue)),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          SizedBox(width: 16.0),
                          //学年の絞り込み
                          Text("学年", style: TextStyle(fontSize: 16.0)),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              _showRightGradeSlideModal(
                                  context, selectedGrades);
                            },
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Text(
                                selectedGrades.isEmpty
                                    ? "学年を選択"
                                    : selectedGrades.length == 1
                                        ? selectedGrades[0]
                                        : selectedGrades.length == 2
                                            ? '${selectedGrades[0]}、${selectedGrades[1]}'
                                            : '${selectedGrades[0]}、${selectedGrades[1]}・・',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: selectedGrades.isEmpty
                                        ? Colors.grey
                                        : Colors.black),
                              ),
                              Icon(Icons.arrow_forward_ios, size: 28),
                            ]),
                          ),

                          SizedBox(width: 16.0),
                        ],
                      ),

                      SizedBox(height: 16.0),

                      //進路の絞り込み
                      Row(
                        children: [
                          SizedBox(width: 16.0),
                          Text("進路", style: TextStyle(fontSize: 16.0)),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              _showRightFutureSlideModal(
                                  context, selectedFutures);
                            },
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Text(
                                selectedFutures.isEmpty
                                    ? "進路を選択"
                                    : selectedFutures.length == 1
                                        ? selectedFutures[0]
                                        : selectedFutures.length == 2
                                            ? '${selectedFutures[0]}、${selectedFutures[1]}'
                                            : '${selectedFutures[0]}、${selectedFutures[1]}・・',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: selectedGrades.isEmpty
                                        ? Colors.grey
                                        : Colors.black),
                              ),
                              Icon(Icons.arrow_forward_ios, size: 28),
                            ]),
                          ),
                          SizedBox(width: 16.0),
                        ],
                      ),

                      SizedBox(height: 16.0),

                      //学類の絞り込み
                      Row(
                        children: [
                          SizedBox(width: 16.0),
                          Text("学類/研究群", style: TextStyle(fontSize: 16.0)),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              _showRightMajorSlideModal(context, selectedMajor);
                            },
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Text(
                                selectedMajor.isEmpty
                                    ? "学類/研究群を選択"
                                    : selectedMajor.length == 1
                                        ? selectedMajor[0].length > 6
                                            ? '${selectedMajor[0].substring(0, 6)}・・'
                                            : selectedMajor[0]
                                        : '${selectedMajor[0].substring(0, 6)}・・',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: selectedGrades.isEmpty
                                        ? Colors.grey
                                        : Colors.black),
                              ),
                              Icon(Icons.arrow_forward_ios, size: 28),
                            ]),
                          ),
                          SizedBox(width: 16.0),
                        ],
                      ),

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
                              final Map<String, List<String>> selectedparams = {
                                'grades': selectedGrades,
                                'futures': selectedFutures,
                                'majors': selectedMajor,
                              };
                              Navigator.pop(context, selectedparams);
                            },
                            child: Text('検索する'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRightGradeSlideModal(BuildContext context, selectedValue) async {
    //閉じた時に選択された学年と進路の入ったリストをresultで受け取る
    final resultGrades = await Navigator.of(context).push(
      //出てくるページの設定
      //ここではこのメソッドの下に定義したRightModalPageクラスのWidgetを呼び出す
      PageRouteBuilder(
        opaque: false, // 背景を透過する設定
        // ignore: deprecated_member_use
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (context, animation, secondaryAnimation) {
          //モーダルのウィジェットを呼び出す
          return RightGradeModalPage(grades: selectedValue);
        },
        //画面遷移の設定
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // 右端から開始
          const end = Offset(0.0, 0.0); // 画面の左端まで開く(出てくるぺーじを80%に縮小してるからこれで良い)
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );

    setState(() {
      selectedGrades = resultGrades;
    });
  }

  void _showRightFutureSlideModal(BuildContext context, selectedValue) async {
    //閉じた時に選択された学年と進路の入ったリストをresultで受け取る
    final resultFutures = await Navigator.of(context).push(
      //出てくるページの設定
      //ここではこのメソッドの下に定義したRightModalPageクラスのWidgetを呼び出す
      PageRouteBuilder(
        opaque: false, // 背景を透過する設定
        // ignore: deprecated_member_use
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (context, animation, secondaryAnimation) {
          //モーダルのウィジェットを呼び出す
          return RightFutureModalPage(selectedOptions: selectedValue);
        },
        //画面遷移の設定
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // 右端から開始
          const end = Offset(0.0, 0.0); // 画面の左端まで開く(出てくるぺーじを80%に縮小してるからこれで良い)
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );

    setState(() {
      selectedFutures = resultFutures;
    });
  }

  void _showRightMajorSlideModal(BuildContext context, selectedValue) async {
    //閉じた時に選択された学年と進路の入ったリストをresultで受け取る
    final resultMajors = await Navigator.of(context).push(
      //出てくるページの設定
      //ここではこのメソッドの下に定義したRightModalPageクラスのWidgetを呼び出す
      PageRouteBuilder(
        opaque: false, // 背景を透過する設定
        // ignore: deprecated_member_use
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (context, animation, secondaryAnimation) {
          //モーダルのウィジェットを呼び出す
          return RightMajorModalPage(selectedOptions: selectedValue);
        },
        //画面遷移の設定
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // 右端から開始
          const end = Offset(0.0, 0.0); // 画面の左端まで開く(出てくるぺーじを80%に縮小してるからこれで良い)
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );

    setState(() {
      selectedMajor = resultMajors;
    });
  }
}
