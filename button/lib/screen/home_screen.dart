import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '버튼',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.black,
                ),
                foregroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                  if(states.contains(MaterialState.pressed)) {
                    return Colors.green;
                  }
                  return Colors.red;
                })
              ),
              child: Text(
                'ButtonStyle',
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.black,
                  shadowColor: Colors.green,
                  elevation: 10,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                  padding: EdgeInsets.all(
                    32,
                  ),
                  side: BorderSide(
                    color: Colors.black,
                    width: 4,
                  )),
              child: Text(
                'ElevatedButton',
              ),
            ),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.green,
                elevation: 10,
              ),
              child: Text(
                'OutlinedButton',
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.blue,
              ),
              child: Text(
                'TextButton',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
