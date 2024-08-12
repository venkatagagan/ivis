import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';



class Term extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg.png',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                SizedBox(height: Height * 0.03),
                Row(
                  children: [
                    SizedBox(width: Width * 0.1),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: Width * 0.05,
                    ),
                    GestureDetector(
                      onTap: () {
                        },
                      child: Image.asset(
                        'assets/logos/logo.png',
                        height: Height * 0.04,
                        width: Width * 0.6,
                      ),
                    )
                  ],
                ),
                SizedBox(height: Height * 0.02),
                Divider(
                  height: Height * 0.001,
                  thickness: 1,
                  color: Colors.white,
                ),
                SizedBox(height: Height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Terms & Conditions ',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Height * 0.02),
                Expanded(
                  child: SfPdfViewer.network(
                    'http://usstaging.ivisecurity.com:8080/common/downloadFile_1_0?assetName=Terms-and-Conditions.pdf&requestName=Terms%26Conditions',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
