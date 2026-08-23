import 'package:flutter/material.dart';
import 'signup.dart';
import 'login.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // 🔄 Image stretches to notch
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/cosmetics.avif'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // 🔶 Orange box fills bottom half
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: const Color.fromARGB(255, 153, 56, 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'luv.cosmetics',
                          style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 197, 60, 22),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'YOUR JOURNEY STARTS HERE!',
                        style: TextStyle(fontSize: 16, color: Colors.black45),
                      ),
                      SizedBox(height: 30),

                      // 🔘 Buttons side by side
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                234,
                                232,
                                228,
                              ),
                              shape: StadiumBorder(),
                              padding: EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 15,
                              ),
                            ),
                            child: const Text(
                              'LOGIN',
                              style: TextStyle(
                                color: Color.fromARGB(255, 226, 129, 19),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                198,
                                100,
                                9,
                              ),
                              shape: StadiumBorder(),
                              padding: EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 15,
                              ),
                            ),
                            child: const Text(
                              'SIGNUP',
                              style: TextStyle(
                                color: Color.fromARGB(255, 228, 227, 226),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 🔙 Back arrow overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(
                  alpha: 0.8,
                ), // rounded white circle
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context); // ✅ returns to main.dart
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
