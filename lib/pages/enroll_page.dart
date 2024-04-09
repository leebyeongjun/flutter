import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'loading_page.dart';

class EnrollPage extends StatefulWidget {
  @override
  _EnrollPageState createState() => _EnrollPageState();
}

class _EnrollPageState extends State<EnrollPage> {
  late String imagePath = '';

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // 알림창 배경색을 흰색으로 설정
          title: Text(
            '알림',
            style: TextStyle(color: Colors.black), // 글자 색상을 검정색으로 설정
          ),
          content: Text(
            '등록이 완료되었습니다.',
            style: TextStyle(color: Colors.black), // 글자 색상을 검정색으로 설정
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black), // 버튼 배경색을 검정색으로 설정
              ),
              child: Text(
                '확인',
                style: TextStyle(color: Colors.white), // 버튼 안의 글자 색상을 흰색으로 설정
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('등록하기'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imagePath.isNotEmpty
                ? Image.file(
              File(imagePath),
              height: 200,
            )
                : Container(),
            SizedBox(height: 20),
            IconButton(
              onPressed: () {
                _pickImage();
              },
              icon: Icon(Icons.image),
              iconSize: 40,
              color: Colors.black,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 등록이 완료되었음을 알리는 다이얼로그를 표시하고, LoadingPage로 이동합니다.
                _showCompletionDialog(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Text('등록하기'),
            ),
          ],
        ),
      ),
    );
  }
}