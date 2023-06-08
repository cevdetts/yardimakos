import 'package:yardimakos/helper/helper_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yardimakos/service/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late BuildContext context;
  // login
  Future loginWithUserNameAndPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = userCredential.user!;
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // register
  Future registerUserWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = userCredential.user!;
      await DatabaseService(uid: user.uid)
          .savingUserData(fullName, email, password);
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // signout
  Future signOut() async {
    try {
      List<String> userGroups = await HelperFunctions.getLoggedInUserGroupsSF();
      bool confirmSignOut = await showSignOutConfirmationDialog();

      if (confirmSignOut) {
        await HelperFunctions.saveUserLoggedInStatus(false);
        await HelperFunctions.saveUserEmailSF("");
        await HelperFunctions.saveUserNameSF("");
        await HelperFunctions.saveUserGroupsSF(userGroups);
        await firebaseAuth.signOut();
      }
    } catch (e) {
      return null;
    }
  }

  late BuildContext _dialogContext;
  // Çıkış onayı için bir diyalog göstermek için aşağıdaki fonksiyonu kullanabilirsiniz

  Future showSignOutConfirmationDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        _dialogContext = context; // dialog context'ini değişkene atayın
        return AlertDialog(
          title: Text("Çıkış Yap"),
          content: Text("Emin misiniz?"),
          actions: [
            TextButton(
              child: Text("Evet"),
              onPressed: () {
                Navigator.of(_dialogContext)
                    .pop(true); // _dialogContext'i kullanın
              },
            ),
            TextButton(
              child: Text("Hayır"),
              onPressed: () {
                Navigator.of(_dialogContext)
                    .pop(false); // _dialogContext'i kullanın
              },
            ),
          ],
        );
      },
    );
  }

  // getCurrentUserUID
  String getCurrentUserUID() {
    User? user = firebaseAuth.currentUser;
    return user?.uid ?? "";
  }
}
