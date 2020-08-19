import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/constants/constants.dart';
import 'package:mobile/models/app_state.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/widgets/cards.dart';
import 'package:mobile/widgets/title.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<AppState>(context, listen: false)
            .getFeaturedList(forceGet: true);
      },
      child: ListView(
        children: <Widget>[
          AdsSliderWidget(),
          FeaturedWidget(),
          HomePageIntroWidget(),
        ],
      ),
    );
  }
}

class AdsSliderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          viewportFraction: 1, enableInfiniteScroll: false, height: 240),
      items: [1, 2, 3, 4].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(5),
              child: FittedBox(
                child: Image(
                    image: AssetImage(
                        Constants.STATIC_IMG + i.toString() + '.jpg')),
                fit: BoxFit.cover,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class FeaturedWidget extends StatefulWidget {
  @override
  _FeaturedWidgetState createState() => _FeaturedWidgetState();
}

class _FeaturedWidgetState extends State<FeaturedWidget> {
  final double cardWidth = 160;

  @override
  void initState() {
    Provider.of<AppState>(context, listen: false).getFeaturedList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return Container(
        child: Column(
          children: <Widget>[
            TitleWidget(
              title: '热门行程',
              size: Constants.TITLE_FONT_SIZE,
            ),
            Container(
              child: ListView(
                children: appState.featuredItinerariesMap.entries
                    .map((entry) => SquareCardWidget(
                        width: cardWidth, itinerary: entry.value.itinerary))
                    .toList(),
                scrollDirection: Axis.horizontal,
              ),
              height: 280,
            )
          ],
        ),
        height: 350,
        color: ColorConstants.BACKGROUND_WHITE,
        margin: EdgeInsets.symmetric(vertical: 5),
      );
    });
  }
}

class HomePageIntroWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                Text(
                  '定 制 自 由  从 轻 出 发',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text('Pack Light And Travel Easy',
                    style: TextStyle(
                        fontWeight: FontWeight.w100, letterSpacing: 1.5))
              ],
            ),
            margin: EdgeInsets.all(25),
          ),
          Image(image: AssetImage(Constants.STATIC_IMG + 'home-intro-1.jpg')),
          Container(
            child: Text(
              '路由心造，从机酒签证到吃喝玩乐，从司机摄影到翻译向导，先鹿聆听每一个旅行需求，深入每一个行程节点，为您全套订制处境游礼宾服务',
              style: TextStyle(color: ColorConstants.TEXT_PRIMARY),
              textAlign: TextAlign.justify,
            ),
            padding: EdgeInsets.all(20),
          )
        ],
      ),
      color: ColorConstants.BACKGROUND_WHITE,
    );
  }
}
