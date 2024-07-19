
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tedz/theme/colors.dart';

class complete extends StatefulWidget {
  const complete({super.key});

  @override
  State<complete> createState() => _completeState();
}

class _completeState extends State<complete> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.buttoncolor,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.keyboard_backspace_sharp,color: Colors.white,)),
        title: Text('Completed',style: GoogleFonts.aBeeZee(color:Colors.white,fontSize:18,),),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 150),
              child: Icon(Icons.no_backpack_outlined,size: 40,)),
            Container(
              child: Text('No Event Has Been Attended !!!!',style: GoogleFonts.aBeeZee(color:Colors.black,fontSize:18,),),
            ),
          ],
        ),
      ),
    );
  }
}