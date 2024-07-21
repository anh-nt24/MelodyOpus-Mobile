import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:melodyopus/services/user_service.dart';
import 'package:melodyopus/views/pages/homepage.dart';
import 'package:melodyopus/views/pages/login.dart';
import 'package:melodyopus/views/widgets/custom_snack_bar.dart';
import 'package:melodyopus/views/widgets/media_button_controller.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cfmPasswordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  RegExp regex = RegExp(r'^[a-zA-Z0-9_.]*$');

  RegExp emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );



  late UserService _userService;

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
              child: Mediabuttoncontroller(
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
                  Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w500),),
                  SizedBox(height: 10,),
                  Text("Welcome", style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 20),
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
                      SizedBox(height: 10,),
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
                              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                              ),
                              child: TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                    hintText: "Your name",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                              ),
                              child: TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                    hintText: "Your email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
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
                              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
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
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                              ),
                              child: TextField(
                                controller: _cfmPasswordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: "Confirm your password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 25,),

                      MaterialButton(
                        onPressed: _handleSignup,
                        height: 50,
                        // margin: EdgeInsets.symmetric(horizontal: 50),
                        color: Color(0xFF7145F5).withOpacity(1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),

                        ),
                        // decoration: BoxDecoration(
                        // ),
                        child: Center(
                          child: Text("Sign up", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        ),
                      ),
                      SizedBox(height: 10),
                      MaterialButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login())
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
                          child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text("Continue with social media", style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: (){},
                              height: 40,
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text("Facebook", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ),
                          SizedBox(width: 20,),
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {},
                              height: 40,
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

  void _handleSignup() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String name = _nameController.text;
    String email = _emailController.text;
    String cfmPassword = _cfmPasswordController.text;

    if (username.isEmpty || password.isEmpty || name.isEmpty || email.isEmpty) {
      CustomSnackBar.show(
        context: context,
        content: "All fields must be filled"
      );
      return ;
    }

    if (!emailRegExp.hasMatch(email)) {
      CustomSnackBar.show(
          context: context,
          content: "Please enter a valid email address"
      );
      return;
    }

    if (password.length < 6) {
      CustomSnackBar.show(
          context: context,
          content: "Password should be at least 6 characters"
      );
      return;
    }

    if (password != cfmPassword) {
      CustomSnackBar.show(
          context: context,
          content: "Passwords do not match"
      );
      return;
    }

    try {
      await _userService.signup(name, email, username, password);
      CustomSnackBar.show(
          context: context,
          content: "Your account has been created successfully. Now LOGIN to join"
      );
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => Login())
      );
    } catch (e) {
      CustomSnackBar.show(
          context: context,
          content: e.toString()
      );
    }
  }
}
