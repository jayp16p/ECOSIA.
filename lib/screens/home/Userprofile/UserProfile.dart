// ignore_for_file: file_names, non_constant_identifier_names, prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers, duplicate_ignore, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecosia/screens/home/EcoCount/EcoCount.dart';
import 'package:ecosia/screens/home/Userprofile/firestore.dart';
import 'package:ecosia/screens/home/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ecosia/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/loading.dart';
import '../../wrapper.dart';
import '../informativepg/informativepage.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final AuthService _auth = AuthService();

  // late Map<String, dynamic>? data;
  String? userEmail;
  TextEditingController name = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController Contact = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController enterDate = TextEditingController();

  @override
  initState() {
    userGet();
    super.initState();
  }

  Future<String?> userGet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("email")) {
      userEmail = prefs.getString("email");
      // print(userEmail);
    }
    return userEmail;
  }

  @override
  Widget build(BuildContext context) {
    // Map<String, dynamic> data = userGet() as Map<String, dynamic>;
    // String email = userGet() as String;
    var UserData;
    final Stream<QuerySnapshot> _tasksStream = FirebaseFirestore.instance
        .collection('users')
        .where("Email", isEqualTo: userEmail)
        .snapshots(includeMetadataChanges: true);

    return StreamBuilder<QuerySnapshot>(
      stream: _tasksStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        UserData = snapshot.data!.docs[0].data()! as Map;
        print(UserData);
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green[300],
            elevation: 5.0,
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                const UserAccountsDrawerHeader(
                  accountName: null,
                  accountEmail: null,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/flag.png',
                    ),
                  ),
                ),
                ListTile(
                  tileColor: Colors.green[300],
                  leading: const Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Dashboard()));
                  },
                  title: const Text(
                    "Dasboard",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  tileColor: Colors.green[300],
                  leading: const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const InformativePage()));
                  },
                  title: const Text(
                    "Informative Page",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  tileColor: Colors.green[300],
                  leading: const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const EcoCount()));
                  },
                  title: const Text(
                    "Eco Count",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  tileColor: Colors.green[300],
                  leading: const Icon(
                    Icons.logout_outlined,
                    color: Colors.white,
                  ),
                  onTap: () async {
                    await _auth.signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Wrapper()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  title: const Text(
                    "Log out",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    const Opacity(
                      opacity: 0.7,
                      child: Image(
                        image: NetworkImage(
                            "https://images.pexels.com/photos/2382325/pexels-photo-2382325.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 120),
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(80),
                                color: Colors.teal),
                            height: 150,
                            width: 150,
                            child: const Image(
                              image: AssetImage("assets/images/flag.png"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                    child: Text(
                  UserData['name'] ?? "User Name",
                  style: const TextStyle(fontSize: 25, color: Colors.black),
                )),
                Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                  child: ListTile(
                    leading: const Icon(
                      Icons.phone,
                    ),
                    title: Text(UserData['Conatct'] ?? "Contact Detail"),
                  ),
                ),
                Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                  child: ListTile(
                    leading: const Icon(
                      Icons.email,
                    ),
                    title: Text(UserData['Email'] ?? "Email ID"),
                  ),
                ),
                Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                  child: ListTile(
                    leading: const Icon(
                      Icons.date_range_sharp,
                    ),
                    title: Text(UserData['Date'] ?? "Date of Birth"),
                  ),
                ),
                Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                  child: ListTile(
                    leading: const Icon(
                      Icons.location_city,
                    ),
                    title: Text(UserData['location'] ?? "Location Detail"),
                  ),
                ),
                Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 20, right: 20),
                    child: InkWell(
                      child: Container(
                        height: 50,
                        // width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.green[300],
                        ),
                        child: const Center(
                          child: Text(
                            'Edit User Details',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const UserProfile()));
                      },
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController enterDate = TextEditingController();

  @override
  void initState() {
    enterDate.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        // backgroundColor: ,
        flexibleSpace: Container(
          height: 150,
          width: 600,
          decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(30),
              color: Colors.green[300]),
          child: const Padding(
            padding: EdgeInsets.only(top: 30),
            child: Center(
              child: Text(
                'Edit User profile',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const Opacity(
              opacity: 0.7,
              child: Image(
                image: NetworkImage(
                    "https://images.pexels.com/photos/2382325/pexels-photo-2382325.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 120),
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        color: Colors.teal),
                    height: 150,
                    width: 150,
                    child: const Image(
                      image: AssetImage("assets/images/flag.png"),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 230),
              // height: 200,
              width: double.infinity,
              // color: Colors.,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 60, left: 20, right: 20),
                    child: TextField(
                      controller: name,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.supervised_user_circle,
                          size: 30,
                        ),
                        hintText: "Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 20, right: 20),
                    child: TextField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.email,
                          size: 30,
                        ),
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 20, right: 20),
                    child: TextField(
                      controller: contact,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.phone,
                          size: 30,
                        ),
                        hintText: "Contact Info",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 20, right: 20),
                    child: TextField(
                      controller: location,
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.location_city,
                          size: 30,
                        ),
                        hintText: "Location",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding:
                          const EdgeInsets.only(top: 15, left: 20, right: 20),
                      child: TextField(
                          controller: enterDate,
                          readOnly: true,
                          // keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            icon: const Icon(
                              Icons.date_range_sharp,
                              size: 30,
                            ),
                            hintText: "User's Birth Date",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onTap: () async {
                            // ignore: non_constant_identifier_names
                            DateTime? UserPickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1960),
                                lastDate: DateTime(2101));
                            if (UserPickedDate != null) {
                              // ignore: avoid_print
                              print(
                                  UserPickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate = DateFormat('yyyy-MM-dd')
                                  .format(UserPickedDate);
                              // ignore: avoid_print
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                enterDate.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            }
                          })),
                  // Padding(
                  //     padding:
                  //         const EdgeInsets.only(top: 15, left: 20, right: 20),
                  //     child: InkWell(
                  //       child: Container(
                  //         height: 50,
                  //         // width: double.infinity,
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(30),
                  //             color: Colors.green[300]),
                  //         child: const Center(
                  //           child: Text(
                  //             'Change password',
                  //             style:
                  //                 TextStyle(fontSize: 24, color: Colors.white),
                  //           ),
                  //         ),
                  //       ),
                  //       onTap: () {},
                  //     )
                  //     ),
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 15, left: 20, right: 20, bottom: 15),
                      child: InkWell(
                        child: Container(
                          height: 50,
                          // width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.green[300]),
                          child: const Center(
                            child: Text(
                              'Save',
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                            ),
                          ),
                        ),
                        onTap: () {
                          userSet(name.text, email.text, location.text,
                              enterDate.text, contact.text);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Dashboard()));
                        },
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}