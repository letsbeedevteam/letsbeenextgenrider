import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/ui/login/login_controller.dart';
import 'package:letsbeenextgenrider/utils/config.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                () => Container(
                  alignment: Alignment.center,
                  child: controller.isKeyboardActive.value
                      ? Container()
                      : SizedBox(
                          height: 240,
                          width: 240,
                          child:
                              Image.asset(Config.PNG_PATH + 'letsbee_logo.png'),
                        ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Username',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300)),
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          GetX<LoginController>(
                            builder: (_) {
                              return IgnorePointer(
                                ignoring: _.isLoading.value,
                                child: TextFormField(
                                  controller: controller.emailTF,
                                  focusNode: controller.emailTFFocusNode,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    fillColor: Colors.grey.shade200,
                                    filled: true,
                                    contentPadding: EdgeInsets.only(left: 10),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  enableSuggestions: false,
                                  cursorColor: Colors.black,
                                ),
                              );
                            },
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                          Text('Password',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300)),
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          GetBuilder<LoginController>(
                            builder: (_) {
                              return IgnorePointer(
                                ignoring: _.isLoading.value,
                                child: TextFormField(
                                  controller: controller.passwordTF,
                                  focusNode: controller.passwordTFFocusNode,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    fillColor: Colors.grey.shade200,
                                    filled: true,
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                  cursorColor: Colors.black,
                                  obscureText: true,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                    GetX<LoginController>(
                      builder: (_) {
                        return IgnorePointer(
                          ignoring: _.isLoading.value,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.blue,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: _.isLoading.value
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator())
                                    : Text('LOGIN',
                                        style: TextStyle(color: Colors.white)),
                              ),
                              onPressed: () => controller.login()),
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
