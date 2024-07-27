import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:melodyopus/models/user.dart';
import 'package:melodyopus/providers/auth_provider.dart';
import 'package:melodyopus/services/user_service.dart';
import 'package:melodyopus/views/pages/homepage.dart';
import 'package:melodyopus/views/pages/signup.dart';
import 'package:melodyopus/views/widgets/custom_snack_bar.dart';
import 'package:melodyopus/views/widgets/media_button_controller.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  RegExp regex = RegExp(r'^[a-zA-Z0-9_.]*$');

  late UserService _userService;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
    clientId: dotenv.env['GOOGLE_CLIENT_ID'] ?? ''
  );

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userService = UserService();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Color.fromRGBO(84, 46, 93, 1.0),
                  Color.fromRGBO(38, 6, 53, 1.0),
                  Color(0xFF7145F5).withOpacity(1),
                ]
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: MediaButtonController(
                function: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage())
                  );
                },
                icon: Icons.home,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Login", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w500),),
                  SizedBox(height: 10,),
                  Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(
                                color: Color(0xFF7145F5).withOpacity(0.3),
                                blurRadius: 20,
                                offset: Offset(0, 10)
                            )]
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                              ),
                              child: TextField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                    hintText: "Username",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                              ),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 25,),

                      Text("Forgot Password?", style: TextStyle(color: Colors.grey)),

                      SizedBox(height: 25,),
                      MaterialButton(
                        onPressed: _handleLogin,
                        height: 50,
                        // margin: EdgeInsets.symmetric(horizontal: 50),
                        color: Color(0xFF7145F5).withOpacity(1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),

                        ),
                        // decoration: BoxDecoration(
                        // ),
                        child: Center(
                          child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        ),
                      ),
                      SizedBox(height: 20),
                      MaterialButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUp())
                          );
                        },
                        height: 50,
                        // margin: EdgeInsets.symmetric(horizontal: 50),
                        color: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        // decoration: BoxDecoration(
                        // ),
                        child: Center(
                          child: Text("Sign up", style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                      ),
                      SizedBox(height: 40,),
                      Text("Continue with social media", style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 30,),
                      Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: (){},
                              height: 50,
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text("Facebook", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ),
                          SizedBox(width: 30,),
                          Expanded(
                            child: MaterialButton(
                              onPressed: _handleGoogleSignIn,
                              height: 50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),

                              ),
                              color: Colors.grey.shade100,
                              child: Center(
                                child: Text("Google", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleLogin() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      CustomSnackBar.show(
        context: context,
        content: 'You must fill all the fields',
      );
      return;
    }

    if (username.length < 6) {
      CustomSnackBar.show(
        context: context,
        content: 'Username must be at least 6 characters long',
      );
      return;
    }

    if (!regex.hasMatch(username)) {
      CustomSnackBar.show(
        context: context,
        content: 'Username can only contain letters, numbers, underscore, and dot',
      );
      return;
    }

    if (password.length < 6) {
      CustomSnackBar.show(
        context: context,
        content: 'Password must be at least 6 characters long',
      );
      return;
    }

    try {
      User userResponse =  await _userService.login(username, password);
      await Provider.of<AuthProvider>(context, listen: false).login(userResponse);

      CustomSnackBar.show(
          context: context,
          content: "Login successfully"
      );

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homepage())
      );
    } catch (e) {
      CustomSnackBar.show(
          context: context,
          content: "Username or password may not correct"
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication authentication = await googleUser.authentication;
        final idToken = authentication.idToken;

        User userResponse = await _userService.signInGoogle(idToken);
        await Provider.of<AuthProvider>(context, listen: false).login(userResponse);

        CustomSnackBar.show(
            context: context,
            content: "Login successfully"
        );

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homepage())
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
