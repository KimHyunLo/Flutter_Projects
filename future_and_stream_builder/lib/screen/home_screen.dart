import 'dart:math';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 16,
    );

    return Scaffold(
      body: StreamBuilder<int>(
        stream: streamNumbers(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'StreamBuilder',
                  style: textStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'ContState: ${snapshot.connectionState}',
                  style: textStyle,
                ),
                Row(
                  children: [
                    Text(
                      'Data: ${snapshot.data}',
                      style: textStyle,
                    ),
                    if (snapshot.connectionState == ConnectionState.waiting)
                      const CircularProgressIndicator()
                  ],
                ),
                Text(
                  'Error: ${snapshot.error}',
                  style: textStyle,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text('setState'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<int> getNumber() async {
    await Future.delayed(const Duration(seconds: 3));

    final random = Random();

    // throw Exception('에러가 발생했습니다.');

    return random.nextInt(100);
  }

  Stream<int> streamNumbers() async* {
    for (int i = 0; i < 10; i++) {
      if (i == 5) throw Exception('에러가 발생했습니다.');

      await Future.delayed(const Duration(seconds: 1));

      yield i;
    }
  }
}
