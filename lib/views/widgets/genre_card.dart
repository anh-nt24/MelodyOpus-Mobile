import 'package:flutter/material.dart';

class GenreCard extends StatelessWidget {
  
  String image, genre;
  
  GenreCard({
    required this.image,
    required this.genre,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 150,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Stack(
          children: [
            Image.asset(this.image, fit: BoxFit.cover, width: 150, height: 90),

            Positioned(
              top: 10,
              left: 15,
              child: Text(
                this.genre,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
