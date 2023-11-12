import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/screens/address/address_form.dart';
import 'package:ecommerce_int2/services/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api_service.dart';
import '../../models/product.dart';

class AddAddressPage extends StatelessWidget {
  void sendWhatsAppMessage(String phoneNumber, String message) async {
    String url =
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";

    if (await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> sendEmailapi(context) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    // final apiKey = 'YOUR_API_KEY'; // Replace with your EmailJS API key
    String message = await generateEmailBody(cartList);
    Map<String, dynamic> body = {
      'service_id': 'service_rndiofn', // Replace with your EmailJS service ID
      'template_id':
          'template_mzejob3', // Replace with your EmailJS template ID
      'user_id': 'J6E53aVlt-IKNhurQ', // Replace with your EmailJS user ID
      'accessToken': 'qyEo_yQ8qknX2OZe-jn7H',
      'template_params': {
        "from_name": "Moaz",
        "to_name": "ecoplast",
        "message": message,
        "reply_to": emailController.text
      }, // Replace with your template parameters
    };
    print('object');
    print(message);
    sendWhatsAppMessage('+996705670454', message);
    // final response = await http.post(url,
    //     headers: {
    //       'Content-Type': 'application/json',
    //     },
    //     body: jsonEncode(body));
    // print(response.body);
    // if (response.statusCode == 200) {
    //   customToast('Письмо успешно отправлено!');
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => MainPage()),
    //     (Route<dynamic> route) => false,
    //   );
    //   print('Email sent successfully!');
    // } else {
    //   customToast(
    //       'Не удалось отправить электронное письмо. Ошибка: ${response.body}');
    //   print('Failed to send email. Error: ${response.body}');
    // }
  }

  void sendEmail1(String email, List<Product> cartProducts) async {
    final subject = 'Cart Product Data';
    final body = await generateEmailBody(cartProducts);

    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject.replaceAll('+', ' '),
        'body': body.replaceAll('+', ' '),
      },
    );
    print(uri);

    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  String generateEmailBody(List<Product> cartProducts) {
    // Generate the body of the email with cart product data
    // You can format it based on your requirements
    String body = '';
    body += 'Name ' + nameController.text + '\n';
    body += 'phone number ' + phoneController.text + '\n';
    body += 'address ' + addressController.text + '\n';
    body += 'comment ' + commentController.text + '\n\n';
    body += 'Product Data:\n\n';
    for (int i = 0; i < cartProducts.length; i++) {
      final product = cartProducts[i];
      final item = '${i + 1}. ${product.name}: \$${product.price}\n';
      body += item;
    }

    return body;
  }

  @override
  Widget build(BuildContext context) {
    Widget finishButton = InkWell(
      onTap: () {
        // sendEmail('zeezfit@gmail.com', cartList);
        if (emailController.text.isNotEmpty &&
            phoneController.text.isNotEmpty) {
          sendEmailapi(context);
        } else {
          customToast(
              'Пожалуйста, добавьте адрес электронной почты и номер телефона');
        }
      },
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width / 1.5,
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
          child: Text("Заканчивать",
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
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: darkGrey),
        title: Text(
          'Добавить адрес',
          style: const TextStyle(
              color: darkGrey,
              fontWeight: FontWeight.w500,
              fontFamily: "Montserrat",
              fontSize: 18.0),
        ),
      ),
      body: LayoutBuilder(
        builder: (_, viewportConstraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Container(
              padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: MediaQuery.of(context).padding.bottom == 0
                      ? 20
                      : MediaQuery.of(context).padding.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  /*   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          color: Colors.white,
                          elevation: 3,
                          child: SizedBox(
                              height: 100,
                              width: 80,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset(
                                          'assets/icons/address_home.png'),
                                    ),
                                    Text(
                                      'Add New Address',
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: darkGrey,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ))),
                      Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          color: yellow,
                          elevation: 3,
                          child: SizedBox(
                              height: 80,
                              width: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset(
                                        'assets/icons/address_home.png',
                                        color: Colors.white,
                                        height: 20,
                                      ),
                                    ),
                                    Text(
                                      'Simon Philip,\nCity Oscarlad',
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ))),
                      Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          color: yellow,
                          elevation: 3,
                          child: SizedBox(
                              height: 80,
                              width: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset(
                                          'assets/icons/address_work.png',
                                          color: Colors.white,
                                          height: 20),
                                    ),
                                    Text(
                                      'Workplace',
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              )))
                    ],
                  ), */
                  AddAddressForm(),
                  Center(child: finishButton)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
