import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:london_crime/controller/login_controller.dart';
import 'package:london_crime/utils/component/header_widget.dart';
import 'package:london_crime/utils/theme/colors.dart';
import 'package:london_crime/utils/theme/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  LoginScreen({super.key});

  final double _headerHeight = 250;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Obx(()=> Column(
            children: [
              SizedBox(
                height: _headerHeight,
                child: HeaderWidget(_headerHeight),
              ),
              SafeArea(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(children: [
                      const Text(
                        'Welcome Back',
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Sign In to your account',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Skeletonizer(
                        enabled: controller.isLoading.value,
                        enableSwitchAnimation: true,
                        child: Form(
                            child: Column(
                              children: [
                                getTextField(
                                  controller: controller.emailController,
                                  text: 'Email address',
                                  hint: 'Enter your email',
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please enter your email!';
                                    } else if (val.isNotEmpty &&
                                        !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                            .hasMatch(val)) {
                                      return "Enter a valid email";
                                    }
                                    return null;
                                  },
                                ),
                                getPasswordField(
                                  text: 'Password',
                                  hint: 'Enter your password',
                                  obscureText: !controller.isPasswordVisible.value,
                                  controller: controller.passwordController,
                                  iconButton: controller.togglePasswordVisibility,
                                  icons: controller.isPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Please enter the password";
                                    } else if (val.length <= 5) {
                                      return "Password should be 6 characters or more";
                                    }
                                    return null;
                                  }, valError: 'Please enter your password',
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                getSignInButton(),
                                redirectToRegister()
                              ],
                            )),
                      )
                    ]),
                  ))
            ]
        ),)
      ),
    );
  }

  getTextField(
      {String? text,
      String? hint,
      String? valError,
      String? Function(String?)? validator,
      TextEditingController? controller,
      bool? obscureText}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText ?? false,
        decoration: ThemeHelper().textInputDecoration(text!, hint!),
        validator: validator ??
            (val) {
              if (val!.isEmpty) {
                return valError;
              }
              return null;
            },
      ),
    );
  }

  Widget getPasswordField({
    required String text,
    required String hint,
    required String valError,
    required VoidCallback iconButton,
    required IconData icons,
    bool obscureText = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          suffixIcon: IconButton(onPressed: iconButton, icon: Icon(icons)),
          labelText: text,
          labelStyle: const TextStyle(color: Colors.black),
          hintText: hint,
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.black)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey.shade400)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.red.shade900, width: 2.0)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.red.shade900, width: 2.0)),
        ),
        validator: validator ?? (val) => val!.isEmpty ? valError : null,
      ),
    );
  }

  redirectToRegister() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Text.rich(TextSpan(children: [
        const TextSpan(text: "Don't have an account? "),
        TextSpan(
            text: 'Create',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.offAll(() => RegisterScreen(),
                    transition: Transition.rightToLeft);
              },
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.redAccent.shade700))
      ])),
    );
  }

  getSignInButton() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.sp), color: kPrimaryColor),
      child: ElevatedButton(
        style: ThemeHelper().buttonStyle(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
          child: Text(
            'Sign In'.toUpperCase(),
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        onPressed: () async {
          controller.login();
        },
      ),
    );
  }
}
