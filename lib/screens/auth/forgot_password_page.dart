import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/services/global_variable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/colors.dart';
import 'confirm_otp_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController phoneController = TextEditingController();

  GlobalKey prefixKey = GlobalKey();
  double prefixWidth = 0;

  TextEditingController _codeController = TextEditingController();

  Future<void> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async {
        Navigator.of(context).pop();

        //This callback would gets called when verification is done auto maticlly
      },
      verificationFailed: (exception) {
        print(exception);
      },
      codeSent: (String verificationId, int? resendToken) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text("Give the code?"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _codeController,
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Confirm"),
                    onPressed: () async {
                      final code = _codeController.text.trim();
                      AuthCredential credential = PhoneAuthProvider.credential(
                          verificationId: verificationId, smsCode: code);
                    },
                  )
                ],
              );
            });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // The verification code auto-retrieval timed out.
        // Handle the case if the user did not receive the verification code.
      },
    );
  }

  void sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print('Password reset email sent successfully.');
      customToast('Письмо для сброса пароля успешно отправлено.');
      Get.back();
    } catch (error) {
      print('Error sending password reset email: $error');
      customToast(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget background = Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        /*  image: DecorationImage(
            image: AssetImage('assets/background.jpg'), fit: BoxFit.cover), */
      ),
      foregroundDecoration: BoxDecoration(color: transparentYellow),
    );

    Widget title = Text(
      'Забыли пароль?',
      style: TextStyle(
          color: Colors.white,
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ]),
    );

    Widget subTitle = Padding(
        padding: const EdgeInsets.only(right: 56.0),
        child: Text(
          'Введите свой зарегистрированный номер мобильного телефона, чтобы получить OTP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ));

    Widget sendButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 40,
      child: InkWell(
        onTap: () async {
          await loginUser(phoneController.text, context);
          /* Navigator.push(context,
              MaterialPageRoute(builder: (context) => ConfirmOtpPage())); */
          // sendPasswordResetEmail(phoneController.text);
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 80,
          child: Center(
              child: new Text("Отправлять OTP",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0))),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(236, 60, 3, 1),
                    Color.fromRGBO(234, 60, 3, 1),
                    Color.fromRGBO(216, 78, 16, 1),
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  offset: Offset(0, 5),
                  blurRadius: 10.0,
                )
              ],
              borderRadius: BorderRadius.circular(9.0)),
        ),
      ),
    );

    Widget phoneForm = Container(
      height: 210,
      child: Stack(
        children: <Widget>[
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 32.0, right: 12.0, bottom: 30),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.8),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextField(
                      controller: phoneController,
                      style: TextStyle(fontSize: 16.0),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(hintText: '+12345678'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          sendButton,
        ],
      ),
    );

    Widget resendAgainText = Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Не получили OTP? ",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Color.fromRGBO(255, 255, 255, 0.5),
                fontSize: 14.0,
              ),
            ),
            InkWell(
              onTap: () {},
              child: Text(
                'Отправить еще раз',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ));
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          /*  image: DecorationImage(
                image: AssetImage('assets/background.jpg'), fit: BoxFit.cover) */
        ),
        child: Container(
          decoration: BoxDecoration(color: transparentYellow),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(flex: 3),
                      title,
                      Spacer(),
                      subTitle,
                      Spacer(flex: 2),
                      phoneForm,
                      Spacer(flex: 2),
                      /* resendAgainText */
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
