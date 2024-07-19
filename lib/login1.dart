import 'dart:async';
import 'package:tedz/login_screen.dart';
import 'package:tedz/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool end = false;
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage == 3) {
        end = true;
      } else if (_currentPage == 0) {
        end = false;
      }

      if (end == false) {
        _currentPage++;
      } else {
        _currentPage--;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment(-0.9, 0.9),
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 650,
                child: PageView(
                  controller: _pageController,
                  children: [
                    Image.asset('assets/01.jpg', fit: BoxFit.cover),
                    Image.asset('assets/02.jpg', fit: BoxFit.cover),
                    Image.asset('assets/culture.jpg', fit: BoxFit.cover),
                    Image.asset('assets/talks.jpg', fit: BoxFit.cover),
                  ],
                  scrollDirection: Axis.horizontal,
                  reverse: false,
                  physics: AlwaysScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                ),
              ),
              Container(
                width: 90,
                height: 100,
                margin: EdgeInsets.only(bottom: 485),
                child: Image.asset('assets/my.png'),
              ),
              SmoothPageIndicator(
                controller: _pageController,
                count: 4,
                effect: const WormEffect(
                  radius: 10,
                  dotHeight: 16,
                  dotWidth: 15,
                  dotColor: Color.fromARGB(255, 200, 226, 248),
                  activeDotColor: Color.fromARGB(255, 96, 170, 230),
                ),
                onDotClicked: (index) {},
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 650,
                width: MediaQuery.of(context).size.width,
                color: CustomColors.backgroundColor,
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  height: 50,
                  width: 300,
                  child: Container(
                    margin: EdgeInsets.only(left: 23),
                    child: ElevatedButton(
                      onPressed: ()  {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen() ),
                      );
                      },
                      child: Center(
                        child: Row(
                          children: [
                            SizedBox(width: 8.0),
                            Text(
                              '   Continue with Login !',
                              style: GoogleFonts.aBeeZee(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: CustomColors.buttoncolor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
