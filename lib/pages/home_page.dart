import 'package:flutter/material.dart';
import 'package:flutter_login/components/logo.dart';
import 'package:flutter_login/pages/select_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 200),
            const Logo("애니멀봐"),
            const SizedBox(height: 50),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SelectPage()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black), // 검정색 배경
                foregroundColor: MaterialStateProperty.all(Colors.white), // 흰색 글자
              ),
              child: const Text("Start"),
            ),
          ],
        ),
      ),
    );
  }
}