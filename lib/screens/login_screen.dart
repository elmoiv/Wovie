import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/screens/main_screen.dart';
import 'package:wovie/widgets/msg_box.dart';

class LoginScreen extends StatefulWidget {
  final SharedPreferences? prefs;
  LoginScreen({this.prefs});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _userApi = TextEditingController();

  String API_KEY = '';
  TMDB apiHelper = TMDB();
  Widget loadingSpinner = SizedBox();

  void tryConnect() async {
    // Show Loading Cicle
    setState(() {
      loadingSpinner = SpinKitFadingCircle(
        color: Color(0xff1e96f0),
        size: 50.0,
      );
    });

    apiHelper.API_KEY = API_KEY;

    // Check for Internet issues first
    try {
      // Checking if API_KEY is correct
      if (await apiHelper.isNotValidApiKey()) {
        showDialog(
          context: context,
          builder: (BuildContext context) => MsgBox(
            title: 'Invalid API Key!',
            content: 'Please check your key or get one from TMDB',
          ),
        );

        // Hide Loading Circle
        setState(() {
          loadingSpinner = SizedBox();
        });

        return;
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) => MsgBox(
          title: 'Network Error!',
          content: e.toString(),
        ),
      );

      // Hide Loading Circle
      setState(() {
        loadingSpinner = SizedBox();
      });

      return;
    }

    // Adding API_KEY to Shared Prefs
    widget.prefs!.setString('API_KEY', apiHelper.API_KEY);

    // Go to MainScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MainScreen(apiKey: apiHelper.API_KEY),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                  child: TextFormField(
                    obscureText: true,
                    onChanged: (value) => API_KEY = value,
                    controller: _userApi,
                    validator: (value) =>
                        value!.isEmpty ? 'API Key Required' : null,
                    decoration: InputDecoration(
                      labelText: 'API Key',
                      hintText: 'Enter Your API Key',
                      prefixIcon: Icon(Icons.vpn_key),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          width: 1,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        this.tryConnect();
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      child: Center(
                        child: Text(
                          'Connect',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: loadingSpinner,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
