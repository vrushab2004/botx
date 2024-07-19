
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tedz/theme/colors.dart';

class ongo extends StatefulWidget {
  const ongo({super.key});

  @override
  State<ongo> createState() => _ongoState();
}

class _ongoState extends State<ongo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.buttoncolor,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.keyboard_backspace_sharp,color: Colors.white,)),
        title: Text('On-Going',style: GoogleFonts.aBeeZee(color:Colors.white,fontSize:18,),),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 130),
              child: Icon(Icons.live_tv_outlined,size: 40,)),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text('No Event is Being On-Going',style: GoogleFonts.aBeeZee(color:Colors.black,fontSize:16,),),
            ),
          ],
        ),
      ),
    );
  }
}