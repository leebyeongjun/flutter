import 'package:flutter/material.dart';
import 'package:flutter_login/components/logo.dart';
import 'package:flutter_login/pages/shooting_page.dart';
import 'package:flutter_login/pages/enroll_page.dart';
import 'package:flutter_login/pages/noticeboard_page.dart';
import 'package:flutter_login/pages/information_page.dart';

class SelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            minimumSize: MaterialStateProperty.all(Size(200, 60)),
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(''),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Logo("애니멀봐"),
              SizedBox(height: 40),
              //"촬영하기" 버튼
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShootingPage()),
                  );
                },
                child: Text('촬영하기'),
              ),
              SizedBox(height: 8),
              // "등록하기" 버튼
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EnrollPage(imagePath: '')), // 수정된 부분
                  );
                },
                child: Text('등록하기'),
              ),
              SizedBox(height: 8),
              // "게시판" 버튼
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NoticeboardPage()),
                  );
                },
                child: Text('게시판'),
              ),
              SizedBox(height: 8),
              // "내정보" 버튼
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InformationPage()),
                  );
                },
                child: Text('내정보'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}