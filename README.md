# first_flutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the 
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


###滚动
ListView 
ListView.Builder
ListView.separated
####拖动删除   Dismissible
GridView
GridView.extend
####下拉刷新   RefreshIndicator 
####防止越界添加滚动   SingleChildScrollView

###异步
####多线程 Isolate
####事件循环
FutureBuilder
StreamBuilder 
StreamController.broadcast();   //变成广播，可以有多个监听者，广播机制不会有缓存
stream  //可以加过滤条件



###限制
FractionallySizedBox
ConstraintBox 
LayoutBuilder //可以查看当前布局限制

###其他
DefaultTextStyle //可以使子集都继承所写样式
Directionlity //可以使子集改变方向
LayoutId

Flex/Column/Row原理
分为弹性和非弹性
找出不是弹性，给它无限高度
计算出不是弹性布局的高度
再计算出弹性布局的高度

Stack原理 + Position
分为有位置和没位置
1.先把没有位置的布局好
2.再把大小设置为没有位置的最大大小
3.所有子控件都有位置，大小会是越大越好
4.clipBehavior:Clip.none //不裁剪

###sliver
CustomScrollView + SliverToBoxAdapter/SliverList 
SliverFixedExtentList
SliverPrototypeExtentList
SliverFillViewport  //占整个页面
SliverAppBar 