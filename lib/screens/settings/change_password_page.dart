import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/screens/auth/welcome_back_page.dart';
import 'package:ecommerce_int2/services/global_variable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController oldPasswordController = TextEditingController();

  TextEditingController newPasswordController = TextEditingController();

  TextEditingController repeatPasswordController = TextEditingController();

  Future<void> changePasswordWithValidation(
      String oldPassword, String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Create a credential with the old password
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPassword,
        );

        // Reauthenticate the user with the credential
        await user.reauthenticateWithCredential(credential);

        // If reauthentication is successful, update the password
        await user.updatePassword(newPassword);
        print('Password changed successfully.');
        customToast('Пароль успешно изменен.');
        Get.back();
      } catch (error) {
        print('Error changing password: $error');
        customToast(error.toString());
        // Handle specific error codes here if needed
      }
    } else {
      customToast('Пожалуйста, войдите сначала');
      Get.to(WelcomeBackPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    Widget changePasswordButton = InkWell(
      onTap: () {
        if (newPasswordController.text == repeatPasswordController.text) {
          changePasswordWithValidation(
              oldPasswordController.text, newPasswordController.text);
        } else {
          customToast('Пароль не подходит');
        }
      },
      child: Container(
        height: 80,
        width: width / 1.5,
        alignment: Alignment.center,
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
        child: Center(
          child: Text("Подтвердить",
              style: const TextStyle(
                  color: const Color(0xfffefefe),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0)),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        title: Text(
          'Настройки',
          style: TextStyle(color: darkGrey),
        ),
        elevation: 0,
      ),
      body: SafeArea(
          bottom: true,
          child: LayoutBuilder(
            builder: (b, constraints) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 48.0, top: 16.0),
                            child: Text(
                              'Изменить пароль',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Text(
                              'Введите ваш текущий пароль',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: TextField(
                                controller: oldPasswordController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Существующий пароль',
                                    hintStyle: TextStyle(fontSize: 12.0)),
                              )),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 24, bottom: 12.0),
                            child: Text(
                              'Введите новый пароль',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: TextField(
                                controller: newPasswordController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Новый пароль',
                                    hintStyle: TextStyle(fontSize: 12.0)),
                              )),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 24, bottom: 12.0),
                            child: Text(
                              'Введите повторно новый пароль',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: TextField(
                                controller: repeatPasswordController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Введите пароль еще раз',
                                    hintStyle: TextStyle(fontSize: 12.0)),
                              )),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 8.0,
                              bottom: bottomPadding != 20 ? 20 : bottomPadding),
                          width: width,
                          child: Center(child: changePasswordButton),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
