import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/constants/constants.dart';
import 'package:mobile/http/sample_data.dart';
import 'package:mobile/widgets/cards.dart';
import 'package:mobile/widgets/title.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        AdsSliderWidget(),
        FeaturedWidget(),
        HomePageIntroWidget(),
      ],
    );
  }
}

class AdsSliderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          viewportFraction: 1, enableInfiniteScroll: false, height: 230),
      items: [1, 2, 3, 4].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(10),
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

class FeaturedWidget extends StatelessWidget {
  final double cardWidth = 160;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          TitleWidget(
            title: '热门行程',
            size: Constants.TITLE_FONT_SIZE,
          ),
          Container(
            child: ListView(
              children: SampleData.itinerariesSet1.values
                  .map(
                    (itinerary) => SquareCardWidget(
                        width: cardWidth, itinerary: itinerary),
                  )
                  .toList(),
              scrollDirection: Axis.horizontal,
            ),
            height: 280,
          )
        ],
      ),
      height: 350,
      decoration:
          BoxDecoration(color: Colors.white, boxShadow: kElevationToShadow[1]),
    );
  }
}

class HomePageIntroWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
            style: TextStyle(color: ColorConstants.PRIMARY),
            textAlign: TextAlign.justify,
          ),
          padding: EdgeInsets.all(20),
        )
      ],
    );
  }
}
