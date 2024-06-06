import 'package:first_flutter/listview_demo/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sliver_demo.g.dart';

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
  List<Member> _members = [];

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
          title: Text(widget.title),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _members = [];
            });
            await _refresh();
          },
          child: Scrollbar(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(),
                _buildItemHeader("Team SII", const Color(0xff91cdeb)),
                _buildItemView("SII"),
                _buildItemHeader("Team NII", const Color(0xffae86bb)),
                _buildItemView("NII"),
                _buildItemHeader("Team HII", const Color(0xfff39800)),
                _buildItemView("HII"),
                _buildItemHeader("Team X", const Color(0xffa9cc29)),
                _buildItemView("X"),
                _buildItemHeader("Team 荣誉毕业生", const Color(0xff91cdeb)),
                _buildItemView("荣誉毕业生"),
                _buildItemHeader("Team S预备生", const Color(0xffa7b0ba)),
                _buildItemView("S预备生"),
                _buildItemHeader("Team 预备生", const Color(0xffa7b0ba)),
                _buildItemView("预备生"),
              ],
            ),
          ),
        ));
  }

  _buildItemHeader(String title, Color color) {
    return SliverPersistentHeader(
        delegate: MyDelegate(title, color), pinned: true);
  }

  _buildItemView(String team) {
    List<Member> ms = _members.where((m) => m.tname == team).toList();
    return SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return DetailPage(member: ms[index]);
              }));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: ms[index].avatarUrl,
                  child: CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(ms[index].avatarUrl)),
                ),
                const SizedBox(height: 10),
                Text(
                  ms[index].sname,
                  style: const TextStyle(fontSize: 15),
                )
              ],
            ),
          );
        }, childCount: ms.length),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 120, childAspectRatio: 4 / 5));
  }

  _refresh() async {
    var response =
        await dio.get("https://h5.48.cn/resource/jsonp/allmembers.php?gid=10");
    var json = response.data["rows"];
    List<Member> ms = (json as List).map((e) {
      return Member.fromJson(e);
    }).toList();
    setState(() {
      _members = ms;
    });
  }
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final Color color;

  MyDelegate(this.title, this.color);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: double.infinity,
      color: color,
      child: Center(
        child: Text(title),
      ),
    );
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 30;

  @override
  bool shouldRebuild(covariant MyDelegate oldDelegate) {
    return oldDelegate.title == title;
  }
}

@JsonSerializable()
class Member {
  final String sid;
  final String sname;
  final String pinyin;
  final String abbr;
  final String tid;
  final String tname;
  final String pid;
  final String pname;
  final String nickname;
  final String company;
  final String join_day;
  final String height;
  final String birth_day;
  final String star_sign_12;
  final String star_sign_48;
  final String birth_place;
  final String speciality;
  final String hobby;
  final String experience;
  final String tcolor;

  String get avatarUrl => "https://www.snh48.com/images/member/zp_$sid.jpg";

  const Member(
      this.sid,
      this.sname,
      this.pinyin,
      this.abbr,
      this.tid,
      this.tname,
      this.pid,
      this.pname,
      this.nickname,
      this.company,
      this.join_day,
      this.height,
      this.birth_day,
      this.star_sign_12,
      this.star_sign_48,
      this.birth_place,
      this.speciality,
      this.hobby,
      this.experience,
      this.tcolor);

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

  Map<String, dynamic> toJson() => _$MemberToJson(this);

  @override
  String toString() {
    return 'Member{sid: $sid, sname: $sname, pinyin: $pinyin, abbr: $abbr, tid: $tid, tname: $tname, pid: $pid, pname: $pname, nickname: $nickname, company: $company, join_day: $join_day, height: $height, birth_day: $birth_day, star_sign_12: $star_sign_12, star_sign_48: $star_sign_48, birth_place: $birth_place, speciality: $speciality, hobby: $hobby, experience: $experience, tcolor: $tcolor}';
  }
}

class DetailPage extends StatelessWidget {
  final Member member;

  const DetailPage({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Color(int.parse("ff${member.tcolor}", radix: 16))
                .withOpacity(0.5),
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(member.sname, style: const TextStyle(fontSize: 18)),
              background: Padding(
                padding: const EdgeInsets.all(100.0),
                child: Hero(
                    tag: member.avatarUrl,
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(member.avatarUrl))),
              ),
              stretchModes: const [
                StretchMode.blurBackground,
                StretchMode.fadeTitle
              ],
              collapseMode: CollapseMode.pin,
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            _buildDetail("别名", member.nickname),
            _buildDetail("身高", member.height),
            _buildDetail("拼音", member.pinyin),
            _buildDetail("简写", member.abbr),
            _buildDetail("生日", member.birth_day),
            _buildDetail("出生地", member.birth_place),
            _buildDetail("加入时间", member.join_day),
            _buildDetail("爱好", member.hobby),
            _buildDetail("公司", member.company),
            _buildDetail("星座", member.star_sign_12),
            _buildDetail("特长", member.speciality),
            _buildDetail("经历", member.experience, true),
          ]))
        ],
      ),
    );
  }

  _buildDetail(String label, String content, [bool isHtml = false]) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 16, color: Colors.black54),
              overflow: TextOverflow.clip,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label),
                  const SizedBox(width: 50),
                  Flexible(child: isHtml ? Html(data: content) : Text(content))
                ],
              ),
            )));
  }
}
