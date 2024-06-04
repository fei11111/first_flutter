import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,v
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// 类似RecorderableListView
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//将数据转换，累加
class DataTransformer implements StreamTransformer<int,int> {
  int sum = 0;
  final StreamController<int> _controller = StreamController();

  @override
  Stream<int> bind(Stream<int> stream) {
    stream.listen((event) {
      sum += event;
      _controller.add(sum);
    });
    return _controller.stream;
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    return StreamTransformer.castFrom(this);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final StreamController _streamController = StreamController.broadcast();
  final StreamController<int> _scoreController = StreamController.broadcast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Center(
            child: StreamBuilder(
                stream: _scoreController.stream.transform(DataTransformer()),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return Text("积分为：${snapshot.data}",
                        style: const TextStyle(fontSize: 20));
                  }
                 return const  Text("积分为：0",
                      style: TextStyle(fontSize: 20));
                }),
          ),
        ),
        body: Stack(children: [
          ...List.generate(10, (_) {
            return Puzzle(_streamController.stream, _scoreController);
          }),
          Align(
              alignment: Alignment.bottomCenter,
              child: KeyPad(_streamController, _scoreController))
        ]));
  }
}

class Puzzle extends StatefulWidget {
  final Stream _stream;

  final StreamController _scoreController;

  const Puzzle(this._stream, this._scoreController, {super.key});

  @override
  State<Puzzle> createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> with SingleTickerProviderStateMixin {
  late Color _color;
  double _left = 0;
  int _a = 0;
  int _b = 0;

  late double _height = 0.0;
  late double _width = 0.0;
  late AnimationController _controller;
  final double _boxWidth = 60;

  _reset() {
    if (_width > 0) {
      _left = Random().nextDouble() * (_width - _boxWidth);
    }
    int result = Random().nextInt(9) + 1;
    _a = Random().nextInt(result);
    _b = result - _a;
    _color = Colors.primaries[Random().nextInt(Colors.primaries.length)][200]!;
    _controller.reset();
    _controller.duration = Duration(seconds: Random().nextInt(5) + 5);
    _controller.forward();
  }

  @override
  void initState() {
    super.initState();
    widget._stream.listen((event) {
      if (_a + _b == event) {
        //加5分
        widget._scoreController.add(5);
        _reset();
      }
    });
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        _reset();
        //减3分
        widget._scoreController.add(-3);
      }
    });
    _reset();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    _left = Random().nextDouble() * (_width - _boxWidth);
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Positioned(
            left: _left,
            top: _controller.value * _height - 150,
            child: Container(
              alignment: Alignment.center,
              width: _boxWidth,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: _color.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))),
              child: Text(
                "$_a + $_b",
                style: const TextStyle(fontSize: 15.0),
              ),
            ),
          );
        });
  }
}

class KeyPad extends StatelessWidget {
  final StreamController _streamController;

  final StreamController _scoreController;

  const KeyPad(this._streamController, this._scoreController, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: 2 / 1,
        children: List.generate(9, (index) {
          return TextButton(
              onPressed: () {
                //先扣两分
                _scoreController.add(-2);
                _streamController.add(index + 1);
              },
              style: ButtonStyle(
                  shape:
                      WidgetStateProperty.all(const RoundedRectangleBorder()),
                  backgroundColor:
                      WidgetStateProperty.all(Colors.primaries[index][200])),
              child: Text(
                "${index + 1}",
                style: const TextStyle(fontSize: 25),
              ));
        }));
  }
}
