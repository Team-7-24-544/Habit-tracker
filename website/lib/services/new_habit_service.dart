import 'package:website/models/MetaInfo.dart';
import '../models/habit_settings.dart';
import 'api_manager.dart';
import 'api_query.dart';

class HabitService {
  static Future<bool> saveNewHabit(HabitSettings settings) async {
    final timeString = '${settings.timeOfDay.hour}:${settings.timeOfDay.minute}';
    final weekDaysString = settings.weekDays.map((day) => day ? '1' : '0').join(',');

    ApiQuery query = ApiQueryBuilder()
        .path('/habits/create')
        .addParameter('name', settings.name)
        .addParameter('description', settings.description)
        .addParameter('time', timeString)
        .addParameter('week_days', weekDaysString.toString())
        .addParameter('duration', settings.durationInDays.toString())
        // .addParameter('notifications', settings.repetitionsPerDay.toString())
        .build();

    final apiManager = MetaInfo.getApiManager();
    ApiResponse response = await apiManager.post(query);
    return response.success;
  }
}
