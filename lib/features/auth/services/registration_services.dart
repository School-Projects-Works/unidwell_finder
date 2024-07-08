import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:unidwell_finder/features/auth/data/user_model.dart';
import 'package:unidwell_finder/features/local_storage.dart';
import '../../../core/functions/sms_api.dart';

class RegistrationServices{
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _users = _firestore.collection('users');
  static final FirebaseStorage _storage = FirebaseStorage.instance;
   static String getId() {
    return _firestore.collection('users').doc().id;
  }

  static Future<(String, User?)> loginUser(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return ('Login Successfully', userCredential.user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ('No user found for that email.', null);
      } else if (e.code == 'wrong-password') {
        return ('Wrong password provided for that user.', null);
      } else if (e.toString().contains('invalid') ||
          e.toString().contains('incorrect')) {
        return ('No user found for that email.', null);
      }
      return (e.message.toString(), null);
    } catch (e) {
      return ('An error occurred while logging in.', null);
    }
  }

  static Future<(String, User?)> registerUser(UserModel user) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
              email: user.email, password: user.password!);
      //send verification email
      if (!userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
      }
      //send user sms notifying them of their registration
      var extraMessage = user.role != 'student'
          ? 'Create your hostels and rooms to start receiving booking requests.'
          : '';
       await SmsApi().sendMessage(user.phone,
          'Welcome ${user.name} to Unidwell Finder, your registration was successful. Open your email to virify your account.$extraMessage');

      user.id = userCredential.user!.uid;
      await _users.doc(user.id).set(user.toMap());
      return ('User created successfully', userCredential.user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ('The password provided is too weak.', null);
      } else if (e.code == 'email-already-in-use') {
        return ('The account already exists for that email.', null);
      }
      return (e.message.toString(), null);
    } catch (e) {
      return ('An error occurred while registering the user.', null);
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    LocalStorage.removeData('user');
  }

  static Future<UserModel?> getUserData(String uid) async {
    try {
      final DocumentSnapshot documentSnapshot = await _users.doc(uid).get();
      if (documentSnapshot.exists) {
        return UserModel.fromMap(
            documentSnapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (error) {
      return null;
    }
  }

  static createUser(UserModel item) async {
    await _users.doc(item.id).set(item.toMap());
  }

  static Stream<List<UserModel>> getUsers() {
    return _users.snapshots().map((event) => event.docs
        .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>))
        .toList());
  }

  static Future<bool> updateUser(UserModel doctor) async {
    try {
      await _users.doc(doctor.id).update(doctor.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<String> uploadImage(Uint8List image) async {
    try {
      var ref = _storage.ref().child('images/${getId()}');
      await ref.putData(image);
      return await ref.getDownloadURL();
    } catch (e) {
      return '';
    }
  }

  static Stream<List<UserModel>>getmanagers() {
    return _users.where('role', isEqualTo: 'manager').snapshots().map((event) => event.docs
        .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>))
        .toList());
  }

  static Stream<List<UserModel>> getStudents() {
    return _users.where('role', isEqualTo: 'student').snapshots().map((event) => event.docs
        .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>))
        .toList());
  }


  static Future<List<UserModel>> getManagers (){
    return _users.where('role', isEqualTo: 'manager').get().then((value) => value.docs.map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>)).toList());
  }


}