import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: '반응속도 테스트', home: ReactionPage());
  }
}

class ReactionPage extends StatefulWidget {
  const ReactionPage({super.key});

  @override
  _ReactionPageState createState() => _ReactionPageState();
}

class _ReactionPageState extends State<ReactionPage> {
  bool waiting = false;
  bool canTap = false;
  int startTime = 0;
  int reaction = 0;
  Timer? delayTimer;

  Color currentColor = Colors.red;
  String message = "탭 해서 시작";

  void startTest() {
    setState(() {
      waiting = true;
      canTap = false;
      reaction = 0;
      currentColor = Colors.red;
      message = "기다리기";
    });

    final random = Random();
    final randomDelay = Duration(
      seconds: 3 + random.nextInt(7), // 3~10초 랜덤
    );

    delayTimer = Timer(randomDelay, () {
      setState(() {
        canTap = true;
        waiting = false;
        currentColor = Colors.green;
        startTime = DateTime.now().millisecondsSinceEpoch;
      });
    });
  }

  void handleTap() {
    // 빨간색인데 누름
    if (waiting && !canTap) {
      delayTimer?.cancel();
      setState(() {
        message = "다시 시도";
        currentColor = Colors.red;
        waiting = false;
      });
      return;
    }

    // 잘누름
    if (canTap) {
      final endTime = DateTime.now().millisecondsSinceEpoch;
      setState(() {
        reaction =
            endTime -
            startTime -
            50; //직접 체험해보고 대충 오차보정, 다른 사이트에서 했을때는 200~270 나왔는데 이거로 하니까 300~340나옴
        if (reaction < 150) {
          message = "반응속도: ${reaction}ms 굉장히 빠름\n다시 탭해서 시작하세요.";
        } else if (reaction < 230) {
          message = "반응속도: ${reaction}ms 빠름\n다시 탭해서 시작하세요.";
        } else if (reaction < 300) {
          message = "반응속도: ${reaction}ms 보통\n다시 탭해서 시작하세요.";
        } else if (reaction < 400) {
          message = "반응속도: ${reaction}ms 느림\n다시 탭해서 시작하세요.";
        } else {
          message = "반응속도: ${reaction}ms 굉장히 느림\n다시 탭해서 시작하세요.";
        }
        currentColor = Colors.white;
        canTap = false;
      });
      return;
    }

    startTest(); //초기화
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: currentColor,
        child: Center(
          child: ElevatedButton(
            onPressed: handleTap,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              backgroundColor: Colors.black.withValues(),
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Text(message, textAlign: TextAlign.left),
          ),
        ),
      ),
    );
  }
}
