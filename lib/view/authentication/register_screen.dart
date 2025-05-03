import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:london_crime/controller/register_controller.dart';
import 'package:london_crime/utils/component/header_widget.dart';
import 'package:london_crime/utils/theme/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());
  final double _headerHeight = 250;

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: _headerHeight, child: HeaderWidget(_headerHeight)),
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.center,
                  child: Obx(()=> Skeletonizer(
                    enabled: controller.isLoading.value,
                    enableSwitchAnimation: true,
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          getAvatarPicker(),
                          const SizedBox(height: 30),
                          getTextField(
                            text: 'Full Name',
                            hint: 'Enter your full name',
                            valError: 'Please enter your full name',
                            controller: controller.nameController,
                          ),
                          getTextField(
                            text: 'E-mail address',
                            hint: 'Enter your email',
                            controller: controller.emailController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter your email';
                              } else if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                            valError: 'Please enter your email',
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
                          getTermCheckBox(),
                          getRegisterButton(context),
                          redirectToLogin()
                        ],
                      ),
                    ),
                  ),)
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getAvatarPicker() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(width: 5, color: Colors.white),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(5, 5),
            ),
          ],
          image: const DecorationImage(
              image:  NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT98A0_6JOy9FNLcNjipGe4xSgzGiCTfgLybw&usqp=CAU')
              as ImageProvider)),
      child: Icon(
        Icons.person,
        color: Colors.grey.withOpacity(0.02),
        size: 80.0,
      ),
    );
  }

  Widget getTextField({
    required String text,
    required String hint,
    required String valError,
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
        decoration: ThemeHelper().textInputDecoration(text, hint),
        validator: validator ?? (val) => val!.isEmpty ? valError : null,
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

  Widget getTermCheckBox() {
    return FormField<bool>(
      builder: (state) {
        return Column(
          children: [
            Row(
              children: [
                Obx(()=>Checkbox(
                  value: controller.checkboxValue.value,
                  activeColor: Colors.red.shade900,
                  onChanged: controller.toggleCheckbox,
                ),),
                const Expanded(
                  child: Text(
                    "I agree to the Terms and Conditions \nand Privacy Policy.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            if (!controller.checkboxValue.value)
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Please accept the terms and conditions',
                  style: TextStyle(
                      color: Theme.of(Get.context!).colorScheme.error,
                      fontSize: 12),
                ),
              )
          ],
        );
      },
    );
  }

  Widget getRegisterButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        decoration: ThemeHelper().buttonBoxDecoration(context),
        child: ElevatedButton(
          style: ThemeHelper().buttonStyle(),
          onPressed: controller.register,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: Text(
              "Register".toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget redirectToLogin() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: "Already have an account? "),
            TextSpan(
              text: 'Sign In',
              recognizer: TapGestureRecognizer()
                ..onTap = () => Get.offAll(() => LoginScreen(), transition: Transition.leftToRight),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
