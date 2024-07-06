
import 'package:flutter/material.dart';
import 'package:geminina/pages/chat/chat_screen.dart';

/// home page 
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("GeminiNa"),
        elevation: 4.0,
        centerTitle: true,
      ),
      extendBody: true,
      body: 
      Column(
        children: [
            /// a topHEader contianer with radius on bottomLeft and right with greenColor for the 1/3 of screen
            Container(
              height: screenSize.height * 0.3,
              padding: EdgeInsets.all(10),
             child: /// animatedtext for sowcase the app
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("GeminiNa", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                  /// desc 
                  Text("GeminiNa est une application de génération de texte, d'image et de code", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                ],
              )
            ),

            /// a container of body for the 2/3 of screen with 3 cardview button of different colors for test gemini : Text Generaton, Image Generation, Code Generation
            Container(
              height: screenSize.height * 0.7 - kBottomNavigationBarHeight,
              width: screenSize.width,
               decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)
                )
              ),
              child: Column(
                children: [
                  /// Text Generation button
                  Padding(padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
                    },
                    child: const Text("Genertion de texte"),
                  ),
                  ),

                  Padding(padding: const EdgeInsets.all(10), 
                  child: 
                  /// Image Generation button
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ImageGenerationPage()));
                    },
                    child: const Text("Generation d'image"),
                  ),),


                  /// Code Generation button
                 Padding(padding: const EdgeInsets.all(10), 
                 child:  ElevatedButton(
                    onPressed: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => CodeGenerationPage()));
                    },
                    child: Text("Code Generation"),
                  ),
                  )
                ],
              ),
            )
        ],
      )
    );
  }
}