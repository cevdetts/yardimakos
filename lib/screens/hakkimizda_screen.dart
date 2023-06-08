import 'package:flutter/material.dart';

class HakkimizdaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10),
          child: Column(children: [
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.all(20),
              child: Image.asset("images/yardimakos.png"),
            ),
            SizedBox(height: 50),
            Text(
              "Hakkımızda",
              style: TextStyle(
                color: Color(0xFF00242e),
                fontSize: 35,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                wordSpacing: 2,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Bu uygulama 2023-Haziran tarihinde Cevdet Solmaz ve Muhammed Kerem Erdoğan tarafından geliştirilmiştir, Hiç bir kar amaclamadan tamamen evdeki hastalarımızın sağlığı için tasarlanmıştır ve geliştirilmeye devam etmektedir.",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ])),
    );
  }
}
