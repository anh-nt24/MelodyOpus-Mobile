import 'dart:io';

import 'package:flutter/material.dart';

class SongCardRec extends StatelessWidget {
  String title;
  String image;
  String author;
  double? percentage;
  Color? backgroundColor;

  SongCardRec({
    required this.title,
    required this.image,
    required this.author,
    this.percentage,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 250,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: this.backgroundColor == null ? Color.fromRGBO(72, 115, 121, 0.3) : this.backgroundColor,
        ),
        child: Column(
          children: [
            Row(
              children: [
                //   place holder image display: width 30%
                ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: SizedBox(
                      height: 75,
                      width: 75,
                      child: FadeInImage.assetNetwork(
                        image: this.image,
                        fit: BoxFit.cover,
                        placeholder: 'assets/music_poster.jpg',
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.file(
                            File(this.image),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/music_poster.jpg', fit: BoxFit.cover);
                            },
                          );
                        },
                      ),
                    )
                ),
                //   place holder text display: width 70%
                Expanded(child: Padding(
                  padding: EdgeInsets.only(left: 10, top: 5, right: 5, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: 45,
                          child: Text(
                            this.title,
                            style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                      ),
                      SizedBox(
                        height: 17,
                        child: Text(
                          this.author,
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                )),
              ],
            ),
            if (this.percentage != null)
              SizedBox(
                height: 4,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height: 5,
                        color: Colors.white24,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height: 5,
                        width: 250 * this.percentage!,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              )
          ],
        )
      )
    );
  }
}
