import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../view/authentication/login_screen.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  var currentUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
  }

  void _loadCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _db.collection('users').doc(user.uid).get();
      if (doc.exists) {
        currentUser.value = UserModel.fromSnapshot(doc);
      }
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAll(()=> LoginScreen(), transition: Transition.rightToLeft); // or wherever your login screen is
  }
}
