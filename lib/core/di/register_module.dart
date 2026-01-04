import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class RegisterModule {
  // Firebase Auth Instance
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  // Firestore Instance
  @lazySingleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  // Shared Preferences (Asynchronous)
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}