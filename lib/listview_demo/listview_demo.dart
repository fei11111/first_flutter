import 'package:first_flutter/listview_demo/rest_client.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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

class _MyHomePageState extends State<MyHomePage> {
  final List<Event> _events = [];
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: GestureDetector(child: Text(widget.title),onTapUp: (_){
            _controller.animateTo(0.0, duration: const Duration(seconds: 1), curve: Curves.linear);
          }),
        ),
        body: RefreshIndicator(

          onRefresh: () async {
            await _refresh();
          },
          child: ListView.separated(
            controller: _controller,
            physics: const BouncingScrollPhysics(),
            itemCount: _events.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: ValueKey(_events[index].id),
                onDismissed: (_) {
                  setState(() {
                    _events.removeAt(index);
                  });
                },
                child: ListTile(
                  leading: Image.network(_events[index].actor!.avatarUrl!),
                  title: Text(_events[index].actor!.login!),
                  subtitle: Text(_events[index].repo!.name!),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ),
        ));
  }

  _refresh() async {
    final client = RestClient(dio);
    var content = await client.getEvents();
    setState(() {
      _events.removeRange(0, _events.length);
      _events.addAll(content);
    });
  }
}
