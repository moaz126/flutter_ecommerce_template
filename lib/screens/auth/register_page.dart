import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/screens/auth/welcome_back_page.dart';
import 'package:ecommerce_int2/services/global_variable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/colors.dart';
import '../main/main_page.dart';
import 'forgot_password_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController phoneController = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController cmfPassword = TextEditingController();

  TextEditingController _codeController = TextEditingController();

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email + '@aa.com',
        password: password,
      );
      User? user = userCredential.user;
      print('User created successfully. User ID: ${user!.uid}');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => WelcomeBackPage()));
    } catch (error) {
      print('Error creating user account: $error');
      customToast(error.toString());
      // You can handle specific error codes here if needed
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUserWithPhoneNumber(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // This callback will be invoked automatically for instant verification,
        // where the code is directly sent to the user's phone number.
        // You can handle the credential here or let it be handled automatically.
        // For the registration flow, we can skip implementing this.
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle verification failure, such as an invalid phone number.
        print('Verification failed: $e');
        customToast('Проверка не удалась: $e');
      },
      codeSent: (String verificationId, int? resendToken) async {
        // The verification code is successfully sent to the user's phone number.
        // Save the verification ID and proceed to the next step.
        // You can store the verification ID in a secure location, such as Firestore or SharedPreferences.
        // Pass the verification ID to the completePhoneNumberRegistration function to complete the registration process.
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              _codeController.clear();
              return AlertDialog(
                title: Text("Дайте код?"),
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
                    child: Text("Подтверждать"),
                    onPressed: () async {
                      try {
                        AuthCredential credential =
                            PhoneAuthProvider.credential(
                          verificationId: verificationId,
                          smsCode: _codeController
                              .text, // Use the phone number as the verification code
                        );
                        UserCredential userCredential =
                            await _auth.signInWithCredential(credential);
                        // Registration successful
                        User? user = userCredential.user;
                        print('Registration successful for user: ${user!.uid}');
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => MainPage()));
                      } catch (e) {
                        // Error occurred during registration
                        print('Error registering user: $e');
                        customToast('Ошибка регистрации пользователя: $e');
                      }
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

  @override
  Widget build(BuildContext context) {
    Widget title = Text(
      'Рад познакомиться с вами',
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
          'Создайте новую учетную запись для использования в будущем.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ));

    Widget alreadyAccount = Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: <Widget>[
            Text(
              'У вас уже есть аккаунт? ',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Color.fromRGBO(255, 255, 255, 0.5),
                fontSize: 14.0,
              ),
            ),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Text(
                'Авторизоваться',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ));

    Widget registerButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 110,
      child: InkWell(
        onTap: () {
          registerUserWithPhoneNumber(phoneController.text);
          /* if (phoneController.text.isNotEmpty &&
              password.text.isNotEmpty &&
              cmfPassword.text.isNotEmpty) {
            if (password.text == cmfPassword.text) {
              createUserWithEmailAndPassword(
                  phoneController.text, password.text);
            } else {
              customToast('Пароль не подходит');
            }
          } */
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 80,
          child: Center(
              child: new Text("Регистрация",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0))),
          decoration: BoxDecoration(
              gradient: mainButton,
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

    Widget registerForm = Container(
      height: 300,
      child: Stack(
        children: <Widget>[
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 32.0, right: 12.0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.8),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10))),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(fontSize: 16.0),
                      decoration: InputDecoration(hintText: '+12345678'),
                    ),
                  ),
                  /* Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextField(
                      controller: password,
                      style: TextStyle(fontSize: 16.0),
                      obscureText: true,
                      decoration: InputDecoration(hintText: 'password'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextField(
                      controller: cmfPassword,
                      style: TextStyle(fontSize: 16.0),
                      decoration: InputDecoration(hintText: 'confirm password'),
                      obscureText: true,
                    ),
                  ), */
                ],
              ),
            ),
          ),
          registerButton,
        ],
      ),
    );

    Widget socialRegister = Column(
      children: <Widget>[
        Text(
          'You can sign in with',
          style: TextStyle(
              fontSize: 12.0, fontStyle: FontStyle.italic, color: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.find_replace),
              onPressed: () {},
              color: Colors.white,
            ),
            IconButton(
                icon: Icon(Icons.find_replace),
                onPressed: () {},
                color: Colors.white),
          ],
        )
      ],
    );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              /*   image: DecorationImage(
                    image: AssetImage('assets/background.jpg'),
                    fit: BoxFit.cover) */
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: transparentYellow,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Spacer(flex: 3),
                title,
                Spacer(),
                subTitle,
                Spacer(flex: 2),
                registerForm,
                Spacer(flex: 2),
                alreadyAccount
                /*  Padding(
                    padding: EdgeInsets.only(bottom: 20), child: socialRegister) */
              ],
            ),
          ),
          Positioned(
            top: 35,
            left: 5,
            child: IconButton(
              color: Colors.white,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
