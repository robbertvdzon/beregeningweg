import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:html' as html;

String myData = "Test";
var _uuid = Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // final _db = FirebaseFirestore.instance;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beregening Robbert\'s moestuin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthStateChecker(),
    );
  }
}

class AuthStateChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Toon een laadscherm terwijl de status wordt gecontroleerd
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // Gebruiker is ingelogd, ga naar MyHomePage
          return MyHomePage(title: 'Beregening Robbert\'s moestuin');
        } else {
          // Gebruiker is niet ingelogd, ga naar LoginPage
          return LoginPage();
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? _timer;
  bool _isPageVisible = true;

  @override
  void initState() {
    super.initState();
    _startPeriodicCall();

    // Luister naar veranderingen in tab-/venstervisibiliteit
    html.document.onVisibilityChange.listen((event) {
      setState(() {
        _isPageVisible = html.document.visibilityState == "visible";
      });

      if (_isPageVisible) {
        _makeRestCall();
        _makeVisible();
      } else {
        _makeInvisible();
      }
    });
  }

  void _startPeriodicCall() {
    _timer = Timer.periodic(Duration(seconds: 60), (timer) {
      if (_isPageVisible) {
        _makeRestCall();
      }
    });
    _makeRestCall();
    _makeVisible();
  }

  void _stopPeriodicCall() {
    _timer?.cancel();
    _makeInvisible();
  }

  Future<void> _makeRestCall() async {
    final _db = FirebaseFirestore.instance;
    DateTime now = DateTime.now();
    String dateTimeString = now.toString();
    final jsonKeyValue = <String, String>{'updaterequest': dateTimeString};
    return _db
        .collection('bewatering')
        .doc('updatecommands')
        .set(jsonKeyValue, SetOptions(merge: true))
        .onError((e, _) => print("Error writing document: $e"));
  }

  Future<void> _makeVisible() async {
    final _db = FirebaseFirestore.instance;
    final jsonKeyValue = <String, String>{'visible': 'true'};
    return _db
        .collection('bewatering')
        .doc('updatecommands')
        .set(jsonKeyValue, SetOptions(merge: true))
        .onError((e, _) => print("Error writing document: $e"));
  }

  Future<void> _makeInvisible() async {
    final _db = FirebaseFirestore.instance;
    final jsonKeyValue = <String, String>{'visible': 'false'};
    return _db
        .collection('bewatering')
        .doc('updatecommands')
        .set(jsonKeyValue, SetOptions(merge: true))
        .onError((e, _) => print("Error writing document: $e"));
  }


  @override
  void dispose() {
    _stopPeriodicCall();
    super.dispose();
  }

  Future<void> saveData(String data) async {
    final _db = FirebaseFirestore.instance;
    String randomUuid = _uuid.v4();
    final jsonKeyValue = <String, String>{randomUuid: data};
    return _db
        .collection('bewatering')
        .doc('commands')
        .set(jsonKeyValue, SetOptions(merge: true))
        .onError((e, _) => print("Error writing document: $e"));
  }

  void _incrementCounter() {
    setState(() {
      saveData("5");
    });
  }

  void _decrementCounter() {
    setState(() {
      saveData("-5");
    });
  }

  void _nothing() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 1000,
          // Stel een vaste breedte in
          height: double.infinity,
          // Vul de volledige hoogte
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/beregening.png'),
                // Jouw afbeeldingsbestand
                fit: BoxFit.cover,
                // Past de afbeelding aan zodat deze de hele achtergrond bedekt
                alignment: Alignment.topCenter),
          ),
          child:
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 450),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Centreer de widgets horizontaal
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: _decrementCounter,
                      child: Text('-5 minuten'),
                    ),
                    SizedBox(width: 10), // Voeg een beetje ruimte tussen de widgets
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('bewatering')
                          .doc('status') // Specificeer je document
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Toon een laadindicator
                        }
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return Text('Document niet gevonden');
                        }

                        // Haal de data op uit het document
                        Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;

                        // Toon de inhoud van een specifiek veld (bijv. 'status')
                        return ElevatedButton(
                          onPressed: _nothing,
                          child: Text('Timer: ${data['klok'] ?? 'Geen klok'}'),
                        );
                      },
                    ),
                    SizedBox(width: 10), // Voeg een beetje ruimte tussen de widgets
                    ElevatedButton(
                      onPressed: _incrementCounter,
                      child: Text('+5 minuten'),
                    ),
                  ],
                ),

              ],
            ),
        ),
      ),
    );
  }
}

//---------
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
    try {
      // Login met Firebase
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Als login succesvol is, ga naar de volgende pagina
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                MyHomePage(title: 'Robbert' 's tuinsproeiers')),
      );
    } catch (e) {
      // Toon foutbericht
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Gebruikersnaam',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                autofillHints: [
                  AutofillHints.username
                ], // Autofill voor gebruikersnaam
              ),
              SizedBox(height: 10), // Ruimte tussen velden
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Wachtwoord',
                  border: OutlineInputBorder(),
                ),
                obscureText: true, // Maakt tekst verborgen
                autofillHints: [
                  AutofillHints.password
                ], // Autofill voor wachtwoord
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

//--------
