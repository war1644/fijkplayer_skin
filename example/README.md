# 具体例子

## 完整例子（剧集，播放速度，锁）

```dart

import 'package:flutter/material.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:fijkplayer_skin/fijkplayer_skin.dart';
import 'package:fijkplayer_skin/schema.dart' show VideoSourceFormat;

class Demo1 extends StatefulWidget {
  @override
  Demo1State createState() => Demo1State();
}

class Demo1State extends State<Demo1> {
  @override
  Widget build(BuildContext context) {
    // return VideoDetailPage();
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            VideoDetailPage(),
          ],
        ),
      ),
    );
  }
}

// 定制UI配置项
class PlayerShowConfig implements ShowConfigAbs {
  @override
  bool drawerBtn = true;
  @override
  bool nextBtn = true;
  @override
  bool speedBtn = true;
  @override
  bool topBar = true;
  @override
  bool lockBtn = true;
  @override
  bool autoNext = true;
  @override
  bool bottomPro = true;
  @override
  bool stateAuto = true;
  @override
  bool isAutoPlay = false;
}

class VideoDetailPage extends StatefulWidget {
  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  final FijkPlayer player = FijkPlayer();
  Map<String, List<Map<String, dynamic>>> videoList = {
    "video": [
      {
        "name": "天空资源",
        "list": [
          {
            "url": "https://n1.szjal.cn/20210428/lsNZ6QAL/index.m3u8",
            "name": "综艺"
          },
          {
            "url": "https://static.smartisanos.cn/common/video/t1-ui.mp4",
            "name": "锤子1"
          },
          {
            "url": "https://static.smartisanos.cn/common/video/video-jgpro.mp4",
            "name": "锤子2"
          }
        ]
      },
      {
        "name": "天空资源",
        "list": [
          {
            "url": "https://n1.szjal.cn/20210428/lsNZ6QAL/index.m3u8",
            "name": "综艺"
          },
          {
            "url": "https://static.smartisanos.cn/common/video/t1-ui.mp4",
            "name": "锤子1"
          },
          {
            "url": "https://static.smartisanos.cn/common/video/video-jgpro.mp4",
            "name": "锤子2"
          }
        ]
      },
    ]
  };

  VideoSourceFormat? _videoSourceTabs;
  late TabController _tabController;

  int _curTabIdx = 0;
  int _curActiveIdx = 0;

  ShowConfigAbs vCfg = PlayerShowConfig();

  @override
  void dispose() {
    player.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // 钩子函数，用于更新状态
  void onChangeVideo(int curTabIdx, int curActiveIdx) {
    this.setState(() {
      _curTabIdx = curTabIdx;
      _curActiveIdx = curActiveIdx;
    });
  }

  @override
  void initState() {
    super.initState();
    // 格式化json转对象
    _videoSourceTabs = VideoSourceFormat.fromJson(videoList);
    // tabbar初始化
    _tabController = TabController(
      length: _videoSourceTabs!.video!.length,
      vsync: this,
    );
    // 这句不能省，必须有
    speed = 1.0;
  }

  // build 剧集
  Widget buildPlayDrawer() {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(24),
        child: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          primary: false,
          elevation: 0,
          title: TabBar(
            tabs: _videoSourceTabs!.video!
                .map((e) => Tab(text: e!.name!))
                .toList(),
            isScrollable: true,
            controller: _tabController,
          ),
        ),
      ),
      body: Container(
        color: Colors.black87,
        child: TabBarView(
          controller: _tabController,
          children: createTabConList(),
        ),
      ),
    );
  }

  // 剧集 tabCon
  List<Widget> createTabConList() {
    List<Widget> list = [];
    _videoSourceTabs!.video!.asMap().keys.forEach((int tabIdx) {
      List<Widget> playListBtns = _videoSourceTabs!.video![tabIdx]!.list!
          .asMap()
          .keys
          .map((int activeIdx) {
        return Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(
                  tabIdx == _curTabIdx && activeIdx == _curActiveIdx
                      ? Colors.red
                      : Colors.blue),
            ),
            onPressed: () async {
              setState(() {
                _curTabIdx = tabIdx;
                _curActiveIdx = activeIdx;
              });
              String nextVideoUrl =
                  _videoSourceTabs!.video![tabIdx]!.list![activeIdx]!.url!;
              // 切换播放源
              // 如果不是自动开始播放，那么先执行stop
              if (player.value.state == FijkState.completed) {
                await player.stop();
              }
              await player.reset().then((_) async {
                player.setDataSource(nextVideoUrl, autoPlay: true);
              });
            },
            child: Text(
              _videoSourceTabs!.video![tabIdx]!.list![activeIdx]!.name!,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      }).toList();
      //
      list.add(
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Wrap(
              direction: Axis.horizontal,
              children: playListBtns,
            ),
          ),
        ),
      );
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FijkView(
          height: 260,
          color: Colors.black,
          fit: FijkFit.cover,
          player: player,
          panelBuilder: (
            FijkPlayer player,
            FijkData data,
            BuildContext context,
            Size viewSize,
            Rect texturePos,
          ) {
            /// 使用自定义的布局
            return CustomFijkPanel(
              player: player,
              viewSize: viewSize,
              texturePos: texturePos,
              pageContent: context,
              // 标题 当前页面顶部的标题部分
              playerTitle: "标题",
              // 当前视频改变钩子
              onChangeVideo: onChangeVideo,
              // 当前视频源tabIndex
              curTabIdx: _curTabIdx,
              // 当前视频源activeIndex
              curActiveIdx: _curActiveIdx,
              // 显示的配置
              showConfig: vCfg,
              // json格式化后的视频数据
              videoFormat: _videoSourceTabs,
            );
          },
        ),
        Container(
          height: 300,
          child: buildPlayDrawer(),
        ),
        Container(
          child: Text(
              '当前tabIdx : ${_curTabIdx.toString()} 当前activeIdx : ${_curActiveIdx.toString()}'),
        )
      ],
    );
  }
}

```

## 精简模式

```dart

import 'package:flutter/material.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:fijkplayer_skin/fijkplayer_skin.dart';
import 'package:fijkplayer_skin/schema.dart' show VideoSourceFormat;

class Demo2 extends StatefulWidget {
  @override
  Demo2State createState() => Demo2State();
}

class Demo2State extends State<Demo2> {
  @override
  Widget build(BuildContext context) {
    // return VideoDetailPage();
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            VideoDetailPage(),
          ],
        ),
      ),
    );
  }
}

// 定制UI配置项
class PlayerShowConfig implements ShowConfigAbs {
  @override
  bool drawerBtn = false;
  @override
  bool nextBtn = false;
  @override
  bool speedBtn = true;
  @override
  bool topBar = true;
  @override
  bool lockBtn = true;
  @override
  bool autoNext = false;
  @override
  bool bottomPro = true;
  @override
  bool stateAuto = true;
  @override
  bool isAutoPlay = true;
}

class VideoDetailPage extends StatefulWidget {
  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  final FijkPlayer player = FijkPlayer();
  Map<String, List<Map<String, dynamic>>> videoList = {
    "video": [
      {
        "name": "天空资源",
        "list": [
          {
            "url": "https://n1.szjal.cn/20210428/lsNZ6QAL/index.m3u8",
            "name": "综艺"
          },
        ]
      },
    ]
  };

  VideoSourceFormat? _videoSourceTabs;

  int _curTabIdx = 0;
  int _curActiveIdx = 0;

  ShowConfigAbs vCfg = PlayerShowConfig();

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // 格式化json转对象
    _videoSourceTabs = VideoSourceFormat.fromJson(videoList);
    // 这句不能省，必须有
    speed = 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FijkView(
          height: 260,
          color: Colors.black,
          fit: FijkFit.cover,
          player: player,
          panelBuilder: (
            FijkPlayer player,
            FijkData data,
            BuildContext context,
            Size viewSize,
            Rect texturePos,
          ) {
            /// 使用自定义的布局
            /// 精简模式，可不传递onChangeVideo
            return CustomFijkPanel(
              player: player,
              viewSize: viewSize,
              texturePos: texturePos,
              pageContent: context,
              // 标题 当前页面顶部的标题部分
              playerTitle: "标题",
              // 当前视频源tabIndex
              curTabIdx: _curTabIdx,
              // 当前视频源activeIndex
              curActiveIdx: _curActiveIdx,
              // 显示的配置
              showConfig: vCfg,
              // json格式化后的视频数据
              videoFormat: _videoSourceTabs,
            );
          },
        ),
      ],
    );
  }
}

```