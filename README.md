
# fijkplayer_skin
[![pub package](https://img.shields.io/pub/v/fijkplayer_skin.svg)](https://pub.dev/packages/fijkplayer_skin)

这是一款 fijkplayer 播放器的普通皮肤，主要解决 fijkplayer 自带的皮肤不好看，没有手势拖动快进，快退 
fijkplayer_skin只是一款皮肤，并不是播放器，所以 fijkplayer 存在的问题，这里 fijkplayer_skin 一样存在

## Flutter SDK要求
sdk >= 2.12.0 支持空安全

## 功能如下

* 手势滑动，快进快退
* 上下滑动（左：屏幕亮度 右：系统音量）
* 视频内剧集切换 （全屏模式下，视频内部切换播放剧集）
* 倍数切换，（全屏模式下，切换倍数）
* 锁定，（锁定UI，防误触）
* 设置视频顶部返回，标题
* 支持部分UI配置显示隐藏


## 使用说明

在使用皮肤之前，你需要查看 fijkplayer 的文档说明，了解如何 fijkplayer [自定义UI](https://fijkplayer.befovy.com/docs/zh/custom-ui.html#gsc.tab=0)

## 预览
<p align="center">
  <img style="max-width: 100%;" src="https://cdn.jsdelivr.net/gh/abcd498936590/pic@master/img/fijkplayer-skin-0.png" />
  <img width="350" style="max-width: 100%;" src="https://cdn.jsdelivr.net/gh/abcd498936590/pic@master/img/fijkplayer-skin-1.png" />
  <img width="350" style="max-width: 100%;" src="https://cdn.jsdelivr.net/gh/abcd498936590/pic@master/img/fijkplayer-skin-2.png" />
  <img width="350" style="max-width: 100%;" src="https://cdn.jsdelivr.net/gh/abcd498936590/pic@master/img/fijkplayer-skin-3.png" />
  <img width="350" style="max-width: 100%;" src="https://cdn.jsdelivr.net/gh/abcd498936590/pic@master/img/fijkplayer-skin-4.png" />
  <img width="350" style="max-width: 100%;" src="https://cdn.jsdelivr.net/gh/abcd498936590/pic@master/img/fijkplayer-skin-5.png" />
  <img width="350" style="max-width: 100%;" src="https://cdn.jsdelivr.net/gh/abcd498936590/pic@master/img/fijkplayer-skin-6.png" />
  <img width="350" style="max-width: 100%;" src="https://cdn.jsdelivr.net/gh/abcd498936590/pic@master/img/fijkplayer-skin-7.png" />
</p>


## 安装
> 如果 pub 安装失败或者不能使用，请更换git方式引入

pubspec.yaml
```yaml
dependencies:
  fijkplayer: ${lastes_version}
  fijkplayer_skin: ${lastes_version}
```
或者
```yaml
fijkplayer_skin:
  git:
    url: git@github.com:war1644/fijkplayer_skin.git
```

## 参数说明

_curTabIdx 当前选中的tab索引，_curActiveIdx 当前选中的剧集索引。如果你使用过 react 你一定知道状态提升，父组件托管数据，子组件只负责渲染，这里的 _curTabIdx 和 _curActiveIdx 也是同理，在父组件中可以给多个需要该数据的组件传递。（包括皮肤内部也使用该数据）

videoList 存放视频列表，请参考我的格式，使用 fijkplayer_skin/schema.dart 中的 VideoSourceFormat 格式化数据

onChangeVideo（int curTabIdx, int curActiveIdx） 钩子函数，在播放器内切换剧集会触发该函数，回调参数是最新的 TabIdx 和 ActiveIdx ，用于更新托管在父组件中的 _curTabIdx 和 _curActiveIdx

pageContent 传递的就是当前组件的 context，这里注意，你当前的根组件不要使用 MaterialApp 否则会报错，请使用 Scaffold

showConfig 传递一个接口实例，抽象类 ShowConfigAbs，实现之后传递给皮肤，定制你需要显示的按键（参数如下）

```code
  bool drawerBtn    // 是否显示剧集按钮
  bool nextBtn      // 是否显示下一集按钮
  bool speedBtn     // 是否显示速度按钮
  bool topBar       // 是否显示播放器状态栏（顶部），非系统
  bool lockBtn      // 是否显示锁按钮
  bool autoNext     // 播放完成后是否自动播放下一集，false 播放完成即暂停
  bool bottomPro    // 底部吸底进度条，贴底部，类似开眼视频
  bool stateAuto    // 是否自适应系统状态栏，true 会计算系统状态栏，从而加大 topBar 的高度，避免挡住播放器状态栏
  bool isAutoPlay   // 是否自动开始播放
```

videoFormat json 格式化后的视频数据，使用 VideoSourceFormat 格式化json数据

## 具体例子
完整例子查看example

## 基本示例

```dart

import 'package:flutter/material.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:fijkplayer_skin/fijkplayer_skin.dart';
import 'package:fijkplayer_skin/schema.dart' show VideoSourceFormat;

// 这里实现一个皮肤显示配置项
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
  bool isAutoPlay = true;
}

class VideoScreen extends StatefulWidget {
  VideoScreen();

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  // FijkPlayer实例
  final FijkPlayer player = FijkPlayer();
  // 当前tab的index，默认0
  int _curTabIdx = 0;
  // 当前选中的tablist index，默认0
  int _curActiveIdx = 0;
  ShowConfigAbs vCfg = PlayerShowConfig();
  // 视频源列表，请参考当前videoList完整例子
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

  @override
  void initState() {
    super.initState();
    // 格式化json转对象
    _videoSourceTabs = VideoSourceFormat.fromJson(videoList);
    // 这句不能省，必须有
    speed = 1.0;
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  // 播放器内部切换视频钩子，回调，tabIdx 和 activeIdx
  void onChangeVideo(int curTabIdx, int curActiveIdx) {
    this.setState(() {
      _curTabIdx = curTabIdx;
      _curActiveIdx = curActiveIdx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Fijkplayer Example")),
        body: Container(
          alignment: Alignment.center,
          // 这里 FijkView 开始为自定义 UI 部分
          child: FijkView(
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
                // 传递 context 用于左上角返回箭头关闭当前页面，不要传递错误 context，
                // 如果要点击箭头关闭当前的页面，那必须传递当前组件的根 context
                pageContent: context,
                viewSize: viewSize,
                texturePos: texturePos,
                // 标题 当前页面顶部的标题部分，可以不传，默认空字符串
                playerTitle: "标题",
                // 当前视频改变钩子，简单模式，单个视频播放，可以不传
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
          );
        ),
    );
  }

}

```

## LICENSE
MIT
