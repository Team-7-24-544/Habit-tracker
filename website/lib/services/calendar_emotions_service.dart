import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:website/models/MetaInfo.dart';
import 'package:website/services/api_manager.dart';
import 'package:website/services/api_query.dart';

import '../models/emotions.dart';
import 'logger.dart';

class CalendarEmotionsService {
  static Future<Map<DateTime, String>> loadEmotions(
      int userId, BuildContext context) async {
    final apiManager = MetaInfo.getApiManager();
    ApiQuery query = ApiQueryBuilder().path(QueryPaths.getEmotions).build();
    ApiResponse response = await apiManager.get(query);
    handleApiError(response: response, context: context);
    if (response.success && response.body.keys.contains('days')) {
      Map<DateTime, String> result = {};
      DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      response.body["days"].forEach((dateString, emojiNumber) {
        DateTime date = dateFormat.parse(dateString);
        date = DateTime(date.year, date.month, date.day);
        result[date] = EmotionData.emotions[emojiNumber].emoji;
      });
      return result;
    } else if (!response.body.keys.contains('days')) {
      showErrorToUser(context, 500, "Некорректный ответ сервера");
      logError(500, "Некорректный ответ сервера", response.body);
    }
    return {};
  }

  static Future<void> setEmoji(
      int userId, int emoji, BuildContext context) async {
    ApiQuery query = ApiQueryBuilder()
        .path(QueryPaths.setEmotion)
        .addParameter('emoji', emoji.toString())
        .build();
    final apiManager = MetaInfo.getApiManager();
    ApiResponse response = await apiManager.post(query);
    handleApiError(response: response, context: context);
  }
}
