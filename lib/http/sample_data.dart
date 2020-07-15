import 'package:mobile/models/models.dart';

class SampleData {
  static const Map<String, Itinerary> itinerariesSet1 = <String, Itinerary>{
    '日本关西美术馆巡礼':
        Itinerary('日本关西美术馆巡礼', '日本', ['京都', '琵琶湖'], '有意思的美术馆', '5.jpg', 'Adam'),
    '日本关西访禅之旅': Itinerary(
        '日本关西访禅之旅',
        '日本',
        ['和歌山', '奈良', '京都', '东京', '大阪', '名古屋', '岚山'],
        '跟随我们去追寻禅的根源吧。',
        '6.jpg',
        'Mei'),
    '东京寻樱之旅': Itinerary(
        '东京寻樱之旅', '日本', ['东京', '台场', '目黑'], '那片我们不期而遇的樱树林。', '7.jpg', '山本耀司')
  };
}
