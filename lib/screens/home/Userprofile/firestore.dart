// ignore_for_file: non_constant_identifier_names, unused_local_variable, avoid_print, invalid_return_type_for_catch_error, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> userSet(String name, String email, String location, String Date,
    String contact) async {
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  // FirebaseAuth auth = FirebaseAuth.instance;
  // String? uid = auth.currentUser?.uid.toString();

  final prefs = await SharedPreferences.getInstance();
  String? email;
  if (prefs.containsKey("email")) {
    // setState(() {
    email = prefs.getString("email");
    // });
    // ignore: avoid_print
    // print(email);
  }
  users.where("Email", isEqualTo: email).get().then((res) => {
        FirebaseFirestore.instance
            .collection('users')
            .doc(res.docs[0].id)
            .set({
              'name': name,
              'email': email,
              'location': location,
              'Date': Date,
              'Conatct': contact
            }, SetOptions(merge: true))
            .then((value) =>
                {print("User Info Added"), prefs.setString("name", name)})
            .catchError((error) => print("Failed to add user info: $error")),
      });

  return;
}
