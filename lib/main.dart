import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crud/models/users_model.dart';
import 'package:firebase_crud/splash_scrren.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'snackbar.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

final formKey = GlobalKey<FormState>();

class _HomePageState extends State<HomePage> {
  final controllerName = TextEditingController();
  final controllerAge = TextEditingController();
  final controllerDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Your Favorite Player'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              TextFormField(
                validator: (value) =>
                    value != null && value.isEmpty ? 'Enter name' : null,
                controller: controllerName,
                decoration: const InputDecoration(
                    labelText: 'Name',
                    contentPadding: const EdgeInsets.only(bottom: 0)),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: (value) =>
                    value != null && value.isEmpty ? 'Enter Jersey No' : null,
                controller: controllerAge,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'No',
                  contentPadding: EdgeInsets.only(bottom: 0),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: (value) =>
                    value != null && value.isEmpty ? 'Enter Position' : null,
                controller: controllerDate,
                decoration: const InputDecoration(
                    labelText: 'position',
                    contentPadding: const EdgeInsets.only(bottom: 0)),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () {
                    final form = formKey.currentState!;
                    if (form.validate()) {
                      final user = User(
                          name: controllerName.text,
                          age: int.parse(controllerAge.text),
                          birthday: controllerDate.text);
                      CreateUser(user: user);
                      Navigator.pop(context);
                      final snackbar =
                          displaySnackbar(context, 'Created New Player');
                    } else {
                      final snackbar = displaySnackbar(
                          context, 'Form is not Valid,pls fill details');
                    }
                  },
                  child: const Text('Create'))
            ],
          ),
        ),
      ),
    );
  }
}

// create user
Future CreateUser({required User user}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Reference to Document
  final docUser = FirebaseFirestore.instance.collection('users').doc();

  user.id = docUser.id;
  final UID = prefs.getString('currentuserid');
  user.userId = UID.toString();
  print(user.userId);
// Create document and write data to Firebase
  await docUser.set(user.toJson());
}
