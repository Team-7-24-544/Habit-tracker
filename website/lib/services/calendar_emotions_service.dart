import 'package:intl/intl.dart';
import 'package:website/models/MetaInfo.dart';
import 'package:website/services/api_manager.dart';
import 'package:website/services/api_query.dart';

import '../models/emotions.dart';

class CalendarEmotionsService {
  static Future<Map<DateTime, String>> loadEmotions(int userId) async {
    final apiManager = MetaInfo.getApiManager();
    ApiQuery query = ApiQueryBuilder().path(QueryPaths.getEmotions).addParameter('user_id', userId.toString()).build();
    ApiResponse response = await apiManager.get(query);
    if (response.success && response.body.keys.contains('days')) {
      Map<DateTime, String> result = {};
      DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      response.body["days"].forEach((dateString, emojiNumber) {
        DateTime date = dateFormat.parse(dateString);
        date = DateTime(date.year, date.month, date.day);
        result[date] = EmotionData.emotions[emojiNumber].emoji;
      });

      return result;
    }
    return {};
  }

  static Future<void> setEmoji(int userId, int emoji) async {
    ApiQuery query = ApiQueryBuilder()
        .path(QueryPaths.setEmotion)
        .addParameter('user_id', userId.toString())
        .addParameter('emoji', emoji.toString())
        .build();
    final apiManager = MetaInfo.getApiManager();
    ApiResponse response = await apiManager.post(query);
    if (!response.success) print(response.error);
  }
}
