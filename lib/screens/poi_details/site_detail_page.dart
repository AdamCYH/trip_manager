import 'package:flutter/material.dart';
import 'package:mobile/constants/colors.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/utils/screen_utils.dart';
import 'package:mobile/widgets/icons.dart';

class SiteDetailPage extends StatelessWidget {
  SiteDetailPage(this.site, {Key key}) : super(key: key);

  final Site site;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          '${site.getCategory()}详情',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ScreenUtils.isMobilePlatform()
            ? Colors.transparent
            : ColorConstants.APP_BAR_DARK_TRANSPARENT,
        elevation: 4,
        centerTitle: true,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: site == null
          ? Container()
          : Stack(
              children: [
                ListView(
                  children: [
                    SiteSummaryWidget(
                      site: site,
                    ),
                    Divider(
                      thickness: 5,
                      color: ColorConstants.BACKGROUND_PRIMARY,
                    ),
                    SiteHighlightWidget(
                      site: site,
                    ),
                  ],
                  padding: EdgeInsets.only(bottom: 100),
                ),
              ],
            ),
    );
  }
}

class SiteSummaryWidget extends StatelessWidget {
  final Site site;

  const SiteSummaryWidget({Key key, this.site})
      : assert(site != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(children: [
        AspectRatio(
          aspectRatio: 6 / 4,
          child: ClipRRect(
            child: FittedBox(
              child: Image.network(
                site.photo,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(children: [
            Text(
              site.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              child: Text(
                site.description,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(color: ColorConstants.TEXT_SECONDARY),
              ),
              width: ScreenUtils.screenWidth(context) * (2 / 3),
            ),
            Container(
              child: Row(
                children: [
                  SquareIcon(
                    color: ColorConstants.TEXT_PRIMARY,
                    width: 10,
                    margin: EdgeInsets.only(right: 10, top: 5),
                  ),
                  Expanded(
                    child: Text(
                      site.city.name,
                      style: TextStyle(color: ColorConstants.TEXT_PRIMARY),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              margin: EdgeInsets.symmetric(vertical: 10),
            ),
            Row(
              children: [],
            )
          ], crossAxisAlignment: CrossAxisAlignment.start),
        )
      ], crossAxisAlignment: CrossAxisAlignment.start),
      width: ScreenUtils.screenWidth(context),
    );
  }
}

class SiteHighlightWidget extends StatelessWidget {
  final Site site;

  const SiteHighlightWidget({Key key, this.site})
      : assert(site != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            '行程亮点',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '世界那么大，我想去看看',
            style: TextStyle(color: ColorConstants.TEXT_SECONDARY),
          ),
          Container(
            child: Text(
              site.description,
              textAlign: TextAlign.justify,
            ),
            margin: EdgeInsets.all(10),
          )
        ],
      ),
      width: ScreenUtils.screenWidth(context),
      margin: EdgeInsets.symmetric(vertical: 30),
    );
  }
}
