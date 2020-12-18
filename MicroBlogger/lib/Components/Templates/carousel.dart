//add this to dependencies in pubspec.yaml :
/*
dependencies:
  flutter:
    sdk: flutter
  carousel_slider: ^1.3.0
*/

import 'package:flutter/material.dart';
//Import Carousel
import 'package:carousel_slider/carousel_slider.dart';

class Carousel extends StatefulWidget {
  Carousel({Key key}) : super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  int _current = 0;
  List images = [
    "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__340.jpg",
    "https://photojournal.jpl.nasa.gov/jpeg/PIA23689.jpg",
    "https://www.w3schools.com/w3css/img_lights.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              color: Colors.black12,
              border: Border.all(color: Colors.white30, width: 0.1)),
          child: CarouselSlider(
            aspectRatio: 1 / 1,
            initialPage: 0,
            //enlargeCenterPage: true,
            viewportFraction: 1.1,
            height: 300,
            reverse: false,
            enableInfiniteScroll: false,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
            items: images.map<Widget>((imgUrl) {
              return Container(
                width: 300,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.white30, width: 1.0)),
                child: Image.network(
                  imgUrl,
                  fit: BoxFit.cover,
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: map<Widget>(images, (index, url) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index ? Colors.red : Colors.white24),
            );
          }),
        )
      ],
    );
  }
}
