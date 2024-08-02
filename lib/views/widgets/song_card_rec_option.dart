import 'dart:io';

import 'package:flutter/material.dart';

class SongCardRecOption extends StatelessWidget {
  String title;
  String image;
  String author;
  double? percentage;
  Color? backgroundColor;

  SongCardRecOption({
    required this.title,
    required this.image,
    required this.author,
    this.percentage,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
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
                    width: 100,  // Set your desired width
                    height: 90, // Set your desired height
                    child: FadeInImage.assetNetwork(
                      image: this.image,
                      fit: BoxFit.cover,
                      placeholder: 'assets/music_poster.jpg',
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/music_poster.jpg', fit: BoxFit.cover);
                      },
                    ),
                  ),
                ),

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


                PopupMenuButton<String>(
                  onSelected: (String result) {
                    // Handle menu item selection
                    if (result == 'Edit') {
                      // Handle edit action
                    } else if (result == 'Delete') {
                      // Handle delete action
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'Edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Delete',
                      child: Text('Delete'),
                    ),
                  ],
                  icon: Icon(Icons.more_vert, color: Colors.white),
                )
                // Flexible(
                //   flex: 1,
                //   child: ,
                // ),
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
