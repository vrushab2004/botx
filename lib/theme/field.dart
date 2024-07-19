
import 'package:flutter/material.dart';


class CustomTextField extends StatelessWidget {
  final String placeholder;
  final IconData icon;
  final bool obscure;
  const CustomTextField({super.key,required this.placeholder,required this.icon,required this.obscure});

  @override
  Widget build(BuildContext context) {
    return 
        Container(
          margin:const EdgeInsets.only(left: 25,right: 25,),
          child: TextField(
            style: TextStyle(color: Colors.white),
            obscureText: obscure,
            decoration: InputDecoration(
              focusColor: Colors.white,
              contentPadding: EdgeInsets.all(20),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              enabledBorder:OutlineInputBorder(
                borderSide: BorderSide(
                  color:  const Color.fromARGB(255, 255, 255, 255),
              ),
               borderRadius: BorderRadius.circular(20),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:  const Color.fromARGB(255, 255, 255, 255)
                ),
                 borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:  const Color.fromARGB(255, 255, 255, 255)
                ),
                 borderRadius: BorderRadius.circular(20),
              ),
              // hintText:placeholder,
              label: Text(placeholder,style: TextStyle(color: const Color.fromARGB(255, 123, 123, 123)),),
              prefixIcon:Icon(icon,color: Colors.white,)

            ),
            cursorColor:  const Color.fromARGB(255, 255, 255, 255)
          ),
        );

  }
}