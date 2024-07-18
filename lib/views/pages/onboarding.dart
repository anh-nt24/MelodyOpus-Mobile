import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../widgets/gradient_button.dart';
import '../pages/homepage.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/onboarding_background.png"),
            fit: BoxFit.cover
          ),
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 100,),
              Image.asset("assets/onboarding_image.png", width: 230),
              SizedBox(height: 50,),
              Text(
                  "Melody Opus",
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )
              ),
              SizedBox(height: 10,),
              Text(
                  "Join us and enhance your music experience!",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )
              ),
              SizedBox(height: 170,),
              GradientButton(
                  text: "Get Started",
                  icon: Icons.arrow_forward_ios,
                onPressed: () {
                  // Handle button press here
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage())
                  );
                },
              )
            ],
          ),
        )
      )
    );
  }
}
