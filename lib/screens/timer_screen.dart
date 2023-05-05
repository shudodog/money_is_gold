import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:modals/modals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  List<String> recomTitle = [];
  late SharedPreferences prefs;

  bool isStarted = false;

  late TextEditingController titleController;

  String title = '';

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final recomTitleList = prefs.getStringList('recomTitleList');
    if (recomTitleList != null) {
      recomTitle = recomTitleList;
    } else {
      //나중에 ACCCOUNTS에서 최근 3개로 넣을예정
      await prefs
          .setStringList('recomTitleList', ['study', 'work', 'go to gym']);
      setState(() {
        recomTitle = ['study', 'work', 'go to gym'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPrefs();
    titleController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.amber[800],
        foregroundColor: Colors.white,
        title: Text(
          '\$ Money is Gold \$',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                'Today time left :',
                style: TextStyle(fontSize: 25),
              ),
              Text(
                '10 : 26 : 42',
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 100,
              ),
              Container(
                width: 300,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.amber,
                    width: 2.0,
                  ),
                ),
                child: Column(children: [
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Title : ',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Money : ',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ]),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Start Now!',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () async {
                      final title = await openDialog();
                      if (title == null || title.isEmpty) return;
                      setState(() {
                        this.title = title;
                      });
                    },
                    icon: Icon(
                      Icons.play_arrow,
                    ),
                    iconSize: 50,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // List<String> recomTitle = ['123', '456', '789'];

  Future<String?> openDialog() {
    // final TextEditingController titleController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Title'),
        content: Column(
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Enter title',
                suffixIcon: IconButton(
                  onPressed: () {
                    titleController.clear();
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Colors.amber[800],
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.amber, // focus 상태일 때 적용되는 밑줄 색상
                    width: 2.0,
                  ),
                ),
              ),
              controller: titleController,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Recommend : ',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Column(
              children: recomTitle
                  .map(
                    (title) => Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: GestureDetector(
                        onTap: () {
                          titleController.text = title;
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.amber[800],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SizedBox(
                            height: 30,
                            child: Center(
                                child: Text(
                              title,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'CANCLE',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          OutlinedButton(
            onPressed: submit,
            child: Text(
              'START',
              style: TextStyle(
                color: Colors.amber[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void submit() {
    Navigator.of(context).pop(titleController.text);
  }
}
