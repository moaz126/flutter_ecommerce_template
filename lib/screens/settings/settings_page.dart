import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/custom_background.dart';
import 'package:ecommerce_int2/screens/auth/welcome_back_page.dart';
import 'package:ecommerce_int2/screens/settings/change_country.dart';
import 'package:ecommerce_int2/screens/settings/change_password_page.dart';
import 'package:ecommerce_int2/screens/settings/legal_about_page.dart';
import 'package:ecommerce_int2/screens/settings/notifications_settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'change_language_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MainBackground(),
      child: Scaffold(
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
              builder: (builder, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 24.0, left: 24.0, right: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                'Общий',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ),
                            /*  ListTile(
                              title: Text('Язык A / का'),
                              leading: Image.asset('assets/icons/language.png'),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => ChangeLanguagePage())),
                            ),
                            ListTile(
                              title: Text('Выбрать страну'),
                              leading: Image.asset('assets/icons/country.png'),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => ChangeCountryPage())),
                            ),
                            ListTile(
                              title: Text('Уведомления'),
                              leading:
                                  Image.asset('assets/icons/notifications.png'),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          NotificationSettingsPage())),
                            ),
                            ListTile(
                              title:
                                  Text('Юридическая информация и информация'),
                              leading: Image.asset('assets/icons/legal.png'),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => LegalAboutPage())),
                            ),
                            */
                            ListTile(
                              title: Text('О нас'),
                              leading: Image.asset('assets/icons/about_us.png'),
                              onTap: () {},
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                'Счет',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ),
                            ListTile(
                              title: Text('Изменить пароль'),
                              leading:
                                  Image.asset('assets/icons/change_pass.png'),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => ChangePasswordPage())),
                            ),
                            ListTile(
                              title: Text('выход'),
                              leading: Image.asset('assets/icons/sign_out.png'),
                              onTap: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (_) => WelcomeBackPage()));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
        ),
      ),
    );
  }
}
