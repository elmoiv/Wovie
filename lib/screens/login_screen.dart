import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:wovie/api/tmdb_helper.dart';
import 'package:wovie/screens/main_screen.dart';
import '../controllers/sharedprefs_controller.dart';
import 'package:wovie/widgets/msg_box.dart';

class LoginScreen extends StatefulWidget {
  final String? customApiKey;
  LoginScreen({this.customApiKey = ''});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _userApi = TextEditingController();

  String API_KEY = '';
  Widget loadingSpinner = SizedBox();
  bool _passwordVisible = false;
  bool isLoginFocused = false;

  void tryConnect() async {
    // Show Loading Cicle
    setState(() {
      loadingSpinner = SpinKitFadingFour(
        color: Theme.of(context).accentColor,
        size: MediaQuery.of(context).size.width / 7,
      );
    });

    String tmpApiKey = API_KEY;

    // Check for Internet issues first
    try {
      // Checking if API_KEY is correct
      if (await TMDB.isNotValidApiKey(apiKey: tmpApiKey) == false) {
        showDialog(
          context: context,
          builder: (BuildContext context) => MsgBox(
            title: 'Invalid Access Token Auth!',
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
      connectionErrorMsg(context);

      // Hide Loading Circle
      setState(() {
        loadingSpinner = SizedBox();
      });

      return;
    }

    // Adding API_KEY to Shared Prefs
    SharedPrefs().setApiKey(tmpApiKey);

    /// First Time init only for TMDB will save the api key
    TMDB(apiKey: tmpApiKey);
    TMDB().API_KEY = tmpApiKey;

    // Go to MainScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MainScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    /// Setting custom api key if came from settings menu
    API_KEY = widget.customApiKey!;
    _userApi.text = API_KEY;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String iconType =
        'images/icon_letter_${Get.isDarkMode ? "dark" : "light"}.png';
    return Scaffold(
      body: FocusScope(
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus!.unfocus();
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Focus(
                    onFocusChange: (focus) {
                      setState(() {
                        isLoginFocused = focus;
                      });
                    },
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                            tag: 'wovie',
                            child: Container(
                              width: screenWidth / 4,
                              height: screenWidth / 4,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(iconType),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'Wovie Login',
                            style:
                                Theme.of(context).textTheme.headline4!.copyWith(
                                      fontSize: screenWidth / 10,
                                    ),
                          ),
                          SizedBox(
                            height: screenWidth / 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                            child: TextFormField(
                              cursorColor: Theme.of(context).accentColor,
                              style: TextStyle(
                                color: Theme.of(context).shadowColor,
                                fontWeight: FontWeight.normal,
                              ),
                              obscureText: !_passwordVisible,
                              onChanged: (value) => API_KEY = value,
                              controller: _userApi,
                              validator: (value) => value!.isEmpty
                                  ? 'Access Token Auth Required'
                                  : null,
                              decoration: InputDecoration(
                                labelText: 'Access Token Auth',
                                labelStyle: TextStyle(
                                  color: isLoginFocused
                                      ? Theme.of(context).accentColor
                                      : Theme.of(context)
                                          .shadowColor
                                          .withOpacity(0.6),
                                ),
                                hintText: 'Enter Your Access Token Auth',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                      fontSize: screenWidth / 22,
                                      color: Theme.of(context)
                                          .shadowColor
                                          .withOpacity(0.6),
                                      fontWeight: FontWeight.normal,
                                    ),
                                prefixIcon: Icon(
                                  Icons.vpn_key,
                                  color: isLoginFocused
                                      ? Theme.of(context).accentColor
                                      : Theme.of(context)
                                          .shadowColor
                                          .withOpacity(0.6),
                                ),
                                suffixIcon: IconButton(
                                  splashRadius: 30,
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: isLoginFocused
                                        ? Theme.of(context).accentColor
                                        : Theme.of(context)
                                            .shadowColor
                                            .withOpacity(0.6),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context)
                                        .shadowColor
                                        .withOpacity(0.6),
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    width: 1,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Theme.of(context).accentColor,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context)
                                        .shadowColor
                                        .withOpacity(0.6),
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
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
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context).accentColor),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
