// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

// start colors fonction
/*
 For change the colors
 And in primarySwatch call " colors_of_the_app" valure
 I note that the color here is #4dd1e1 and I add FF that mean full opaque
 because  flutter uses color AARRGGBB format
*/
const MaterialColor Colors_of_the_app = const MaterialColor(
    0xFF4dd1e1,
    const <int, Color>{
      50: const Color(0xFF4dd1e1),
      100: const Color(0xFF4dd1e1),
      200: const Color(0xFF4dd1e1),
      300: const Color(0xFF4dd1e1),
      400: const Color(0xFF4dd1e1),
      500: const Color(0xFF4dd1e1),
      600: const Color(0xFF4dd1e1),
      700: const Color(0xFF4dd1e1),
      800: const Color(0xFF4dd1e1),
      900: const Color(0xFF4dd1e1),
    }
);

const MaterialColor body_background = const MaterialColor(
    0xFF333333,
    const <int, Color>{
      50: const Color(0xFF333333),
      100: const Color(0xFF333333),
      200: const Color(0xFF333333),
      300: const Color(0xFF333333),
      400: const Color(0xFF333333),
      500: const Color(0xFF333333),
      600: const Color(0xFF333333),
      700: const Color(0xFF333333),
      800: const Color(0xFF333333),
      900: const Color(0xFF333333),
    }
);
// End colors fonction

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MQTT dashboard',

      debugShowCheckedModeBanner:false, //to remove the red debug banner

      home: Scaffold(
        backgroundColor:body_background,
        appBar: AppBar(
            backgroundColor: Colors_of_the_app,
            title: const Text('Bottom App Bar')
        ),

        floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          backgroundColor: Colors_of_the_app,
          child: const Icon(Icons.add),
          onPressed: () {},
        ),

        //if you need to change the FAB to text button recomment the next code
        //FAB with text
        /*
         floatingActionButton: FloatingActionButton.extended(
          elevation: 0.0,
          backgroundColor: Colors_of_the_app,
          icon: const Icon(Icons.add),
          label: const Text(''),
          onPressed: () {},
        ),
         */
        //end FAB with text


        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(), // this line to fix Notch for Docked FloatingActionButton Missing in BottomAppBar
                                             //found it in https://stackoverflow.com/questions/51251722/notch-for-docked-floatingactionbutton-missing-in-bottomappbar
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(icon: Icon(Icons.menu), onPressed: () {},),
                IconButton(icon: Icon(Icons.search), onPressed: () {},),
              ],
            ),

        ),
        body: Center(
         child: Text('MQTT dashboard'), //text in the center of the page
      ),

    ),
    );
  }
}