import 'package:flutter/material.dart';
import 'package:melodyopus/models/user.dart';
import 'package:melodyopus/providers/auth_provider.dart';
import 'package:melodyopus/views/pages/login.dart';
import 'package:melodyopus/views/widgets/gradient_button.dart';
import 'package:provider/provider.dart';

class UserTab extends StatefulWidget {
  const UserTab({super.key});

  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    User? user = authProvider.getUser();
    if (user == null || user.id < 0) {
      return Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Column(
                children: [
                  const SizedBox(height: 200,),
                  Container(
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(360),
                      child: Image.asset(
                        user!.avatar,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                          'assets/user.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Sign in to enjoy offline playback\n and other awesome features.',
                    style: TextStyle(color: Colors.white, fontSize: 17,),
                  ),
                ],
              )),


              GradientButton(
                text: "Sign in",
                icon: Icons.login,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login())
                  );
                }),

              SizedBox(height: 50)
            ],
          )
        ),
      );
    } else {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

          ],
        ),
      );
    }
  }
}
