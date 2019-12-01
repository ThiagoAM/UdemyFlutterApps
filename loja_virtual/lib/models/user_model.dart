import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class UserModel extends Model {

  // Properties:
  bool isLoading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser fireBaseUser;
  Map<String, dynamic> userData = Map();

  // Overridden Methods:
  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  // Public Methods:
  void signUp({
    @required Map<String, dynamic> userData,
    @required String password,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    isLoading = true;
    notifyListeners();
    _auth.createUserWithEmailAndPassword(
      email: userData["email"],
      password: password,
    ).then((user) async { // Success:
      fireBaseUser = user;
      await _saveUserData(userData);
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((error) { // Failure:
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn({
    @required String email,
    @required String password,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    isLoading = true;
    notifyListeners();
    _auth.signInWithEmailAndPassword(email: email, password: password).then((user) async {
      fireBaseUser = user;

      await _loadCurrentUser();

      isLoading = false;
      notifyListeners();
      onSuccess();
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      onFail();
    });
  }

  void signOut() async {
    await _auth.signOut();
    userData = Map();
    fireBaseUser = null;
    notifyListeners();
  }

  void recoverPass(String _email) async {
    await _auth.sendPasswordResetEmail(email: _email);
  }

  bool isLoggedIn() {
    return fireBaseUser != null;
  }

  // Private Methods:
  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance.collection("users").document(fireBaseUser.uid).setData(userData);
  }

  Future<Null> _loadCurrentUser() async {
    if (fireBaseUser == null) {
      fireBaseUser = await _auth.currentUser();
    }
    if (fireBaseUser != null) {
      if (userData["name"] == null) {
        DocumentSnapshot userDoc = await Firestore.instance.collection("users")
            .document(fireBaseUser.uid).get();
        userData = userDoc.data;
      }
      notifyListeners();
    }
  }

  // Static Public Methods:
  static UserModel of(BuildContext context) {
    return ScopedModel.of<UserModel>(context);
  }


}