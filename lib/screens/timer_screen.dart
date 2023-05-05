import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
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
  late TextEditingController moneyController;
  final numberFormat = NumberFormat('#,###');

  String title = '';
  final _valueList = ['dollar', 'won', 'yen', 'yuan'];
  var _selectedValue = 'won';

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final recomTitleList = prefs.getStringList('recomTitleList');
    final moneyPerHour = prefs.getString('MoneyPerHour');
    if (recomTitleList != null) {
      setState(() {
        recomTitle = recomTitleList;
      });
    } else {
      //나중에 ACCCOUNTS에서 최근 3개로 넣을예정
      await prefs
          .setStringList('recomTitleList', ['study', 'work', 'go to gym']);
      setState(() {
        recomTitle = ['study', 'work', 'go to gym'];
      });
    }

    if (moneyPerHour != null) {
      setState(() {
        moneyController.text = numberFormat.format(moneyPerHour);
      });
    } else {
      await prefs.setString('moneyPerHour', '10000');
      setState(() {
        moneyController.text = '10,000';
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController = TextEditingController();
    moneyController = TextEditingController();
    initPrefs();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    moneyController.dispose();
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
                height: 30,
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
                height: 70,
              ),
              Container(
                width: 330,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.amber,
                    width: 2.0,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)),
                          height: 30,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: DropdownButton(
                              value: _selectedValue,
                              items: _valueList.map(
                                (value) {
                                  return DropdownMenuItem(
                                    child: Text(value),
                                    value: value,
                                  );
                                },
                              ).toList(),
                              onChanged: (value) {
                                setState(
                                  () {
                                    if (value != null) {
                                      _selectedValue = value;
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: 130,
                          child: TextField(
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            keyboardType: TextInputType.number, // 숫자 입력 키보드로 설정
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(
                                  9), // 최대 9자리까지 입력 가능
                              // 입력한 숫자를 쉼표(,)를 포함한 문자열로 변환
                              TextInputFormatter.withFunction(
                                  (oldValue, newValue) {
                                final intVal = int.tryParse(newValue.text);
                                if (intVal != null) {
                                  final newString = numberFormat.format(intVal);
                                  return TextEditingValue(
                                    text: newString,
                                    selection: TextSelection.collapsed(
                                        offset: newString.length),
                                  );
                                } else {
                                  return oldValue;
                                }
                              }),
                            ],
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.amber, // focus 상태일 때 적용되는 밑줄 색상
                                  width: 2.0,
                                ),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.amber, // focus 상태일 때 적용되는 밑줄 색상
                                  width: 2.0,
                                ),
                              ),
                              hintText: 'Enter money you got in an hour',
                            ),
                            controller: moneyController,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text('per hour')
                      ],
                    ),
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
                        GestureDetector(
                          onTap: () async {
                            final title = await openDialog();
                            if (title == null || title.isEmpty) return;
                            setState(() {
                              this.title = title;
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 200,
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  5.0), // 20의 반지름을 가진 원형으로 모서리를 둥글게 처리
                              color: Colors.grey,
                            ),
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(20),
              ],
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
              'SAVE',
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
