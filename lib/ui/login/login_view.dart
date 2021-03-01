import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';
import 'package:letsbeenextgenrider/ui/login/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (_) {
      return Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                () => Container(
                  alignment: Alignment.center,
                  child: _.isKeyboardActive.value
                      ? const SizedBox.shrink()
                      : SizedBox(
                          height: 240,
                          width: 240,
                          child:
                              Image.asset(Config.PNG_PATH + 'letsbee_logo.png'),
                        ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Username',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300)),
                          const Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5)),
                          GetBuilder<LoginController>(
                            builder: (_) {
                              return IgnorePointer(
                                ignoring: _.isLoading.value,
                                child: TextFormField(
                                  controller: _.emailTF,
                                  focusNode: _.emailTFFocusNode,
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
                          const Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10)),
                          const Text('Password',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300)),
                          const Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5)),
                          GetBuilder<LoginController>(
                            builder: (_) {
                              return IgnorePointer(
                                ignoring: _.isLoading.value,
                                child: TextFormField(
                                  controller: _.passwordTF,
                                  focusNode: _.passwordTFFocusNode,
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
                    const Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20)),
                    GetBuilder<LoginController>(
                      builder: (_) {
                        return IgnorePointer(
                          ignoring: _.isLoading.value,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.blue,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: _.isLoading.value
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child:
                                            const CircularProgressIndicator())
                                    : const Text('LOGIN',
                                        style: const TextStyle(
                                            color: Colors.white)),
                              ),
                              onPressed: () => _.login()),
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
