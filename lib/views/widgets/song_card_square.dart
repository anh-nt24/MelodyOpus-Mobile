import 'package:flutter/material.dart';

class SongCardSquare extends StatelessWidget {
  String title;
  String image;
  String author;

  SongCardSquare({
    required this.title,
    required this.image,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    String imageSrc = this.image;
    return Container(
      height: 220,
      width: 150,
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: Color.fromRGBO(72, 115, 121, 0.3),
            borderRadius: BorderRadius.all(Radius.circular(7))
        ),
        child: Container(
          height: 170,
          width: 150,
          child: Column(
            children: [
              Container(
                height: 150,
                width: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(7),
                    topLeft: Radius.circular(7)
                  ),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/music_placeholder.png',
                    image: imageSrc,
                    fit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/music_placeholder.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                        child: Text(
                          this.title,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      SizedBox(
                        height: 20,
                        child: Text(
                          this.author,
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ]
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}


