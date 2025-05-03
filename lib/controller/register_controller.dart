import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:london_crime/models/user_model.dart';
import 'package:london_crime/utils/component/bottom_bar.dart';
import 'package:london_crime/utils/theme/colors.dart';


class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var user = UserModel().obs;

  var checkboxValue = false.obs;

  void toggleCheckbox(bool? value) {
    checkboxValue.value = value ?? false;
  }

  // Signup function
  Future<void> register() async {
    if (!_validateInputs()) return;

    isLoading.value = true;

    try {
      final response = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = response.user!;
      await user.updateDisplayName(nameController.text.trim());
      await user.reload();

      // Create user model
      final newUser = UserModel(
        uid: user.uid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Save user to Firestore
      await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

      fetchLoggedInUser();

      isLoading.value = false;

      Get.snackbar(
        'Signup Success',
        'Account created successfully!',
        colorText: kWhiteColor,
        backgroundColor: kPrimaryColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
      );

      Get.offAll(() => CustomBottomBar(), transition: Transition.fadeIn);

      nameController.clear();
      emailController.clear();
      passwordController.clear();
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;

      String errorMessage = switch (e.code) {
        'email-already-in-use' => 'Email is already in use.',
        'weak-password' => 'The password provided is too weak.',
        _ => e.message ?? 'An unexpected error occurred.',
      };

      Get.snackbar(
        'Signup Failed',
        errorMessage,
        colorText: kWhiteColor,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again later.',
        colorText: kWhiteColor,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
      );
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool _validateInputs() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Name is required',
        colorText: kWhiteColor,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
      );
      return false;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        'Error',
        'Enter a valid email address',
        colorText: kWhiteColor,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
      );
      return false;
    }
    if (passwordController.text.trim().length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters',
        colorText: kWhiteColor,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
      );
      return false;
    }
    return true;
  }

  // Fetch the logged-in user's data
  Future<void> fetchLoggedInUser() async {
    isLoading.value = true;
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot doc =
        await _firestore.collection('users').doc(currentUser.uid).get();
        if (doc.exists) {
          user.value = UserModel.fromSnapshot(doc);
        } else {
          user.value = UserModel();
          if (kDebugMode) {
            print("No user data found in Firestore");
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user data: $e");
      }
      user.value = UserModel();
    } finally {
      isLoading.value = false;
    }
  }
}

