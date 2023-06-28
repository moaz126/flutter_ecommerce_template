import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/screens/address/add_address_page.dart';
import 'package:ecommerce_int2/screens/auth/forgot_password_page.dart';
import 'package:ecommerce_int2/screens/main/main_page.dart';
import 'package:ecommerce_int2/services/global_variable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/colors.dart';
import '../settings/change_password_page.dart';
import 'register_page.dart';

class WelcomeBackPage extends StatefulWidget {
  @override
  _WelcomeBackPageState createState() => _WelcomeBackPageState();
}

class _WelcomeBackPageState extends State<WelcomeBackPage> {
  TextEditingController phoneController = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController _codeController = TextEditingController();

  bool isScreenInStack(String routeName, BuildContext context) {
    final navigator = Navigator.of(context);
    bool isFound = false;

    navigator.popUntil((route) {
      if (route.settings.name == routeName) {
        isFound = true;
      }
      return true;
    });

    return isFound;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signinUserWithPhoneNumber(String phoneNumber) async {
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

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email + '@aa.com',
        password: password,
      );
      User? user = userCredential.user;
      print('User logged in successfully. User ID: ${user!.uid}');
      if (isScreenInStack('CheckOutPage', context)) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => AddAddressPage()));
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => MainPage()));
      }
    } catch (error) {
      print('Error logging in: $error');
      customToast(error.toString());
      // You can handle specific error codes here if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget welcomeBack = Text(
      'С возвращением Роберто,',
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
          'Войдите в свою учетную запись, используя\nНомер мобильного телефона',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ));

    Widget loginButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 50,
      child: InkWell(
        onTap: () {
          if (phoneController.text.isNotEmpty) {
            signinUserWithPhoneNumber(phoneController.text);
          }
          /*  Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => RegisterPage())); */
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 80,
          child: Center(
              child: new Text("Авторизоваться",
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

    Widget loginForm = Container(
      height: 240,
      child: Stack(
        children: <Widget>[
          Container(
            height: 140,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 32.0, right: 12.0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.8),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                    decoration: InputDecoration(hintText: '********'),
                    obscureText: true,
                  ),
                ), */
              ],
            ),
          ),
          loginButton,
        ],
      ),
    );

    Widget forgotPassword = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              Get.to(() => RegisterPage());
            },
            child: Text(
              'Зарегистрироваться',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
          /* Text(
            ' или ',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Color.fromRGBO(255, 255, 255, 0.5),
              fontSize: 14.0,
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => ForgotPasswordPage());
            },
            child: Text(
              'Сброс пароля',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ), */
        ],
      ),
    );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              /* image: DecorationImage(
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
              children: <Widget>[
                Spacer(flex: 3),
                welcomeBack,
                Spacer(),
                subTitle,
                Spacer(flex: 2),
                loginForm,
                Spacer(flex: 2),
                forgotPassword
              ],
            ),
          )
        ],
      ),
    );
  }
}
