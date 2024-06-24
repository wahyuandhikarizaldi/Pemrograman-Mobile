import 'package:flutter/material.dart';
import 'package:porto_flutter/widgets/circle_image.dart';
import 'package:porto_flutter/widgets/custom_dialog.dart';
import 'package:porto_flutter/widgets/info_card.dart';
import 'package:porto_flutter/widgets/name_text.dart';

const github = 'https://github.com/wahyuandhikarizaldi';
const email = 'wahyurizaldi80@gmail.com';
const phone = '+62 823 8745 5975';
const linkedin = 'https://www.linkedin.com/in/wahyu-andhika-rizaldi/';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  void _showDialog(BuildContext context, {String? title, String? msg}) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: title ?? '',
        message: msg ?? '',
        buttonText: 'Close',
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 45, 50, 80),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleImageView(
              imageUrl: 'assets/wahyu.png',
              radius: 50,
              onPressed: () {
                _showDialog(
                  context,
                  title: 'Wahyu Andhika Rizaldi',
                  msg: 'Wahyu Ganteng',
                );
              },
            ),
            NameText(
              text: 'Wahyu Andhika Rizaldi',
              fontSize: 30.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            TitleText(
              text: '5027211003',
              fontSize: 20.0,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.white,
              ),
            ),
            InfoCard(
              text: 'Phone',
              icon: Icons.phone,
              onPressed: () {
                _showDialog(
                  context,
                  title: 'Phone',
                  msg: phone,
                );
              },
            ),
            InfoCard(
              text: 'Email',
              icon: Icons.email,
              onPressed: () {
                _showDialog(
                  context,
                  title: 'Email',
                  msg: email,
                );
              },
            ),
            InfoCard(
              text: 'GitHub',
              icon: Icons.work,
              onPressed: () {
                _showDialog(
                  context,
                  title: 'GitHub',
                  msg: github,
                );
              },
            ),
            InfoCard(
              text: 'LinkedIn',
              icon: Icons.co_present,
              onPressed: () {
                _showDialog(
                  context,
                  title: 'LinkedIn',
                  msg: linkedin,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
