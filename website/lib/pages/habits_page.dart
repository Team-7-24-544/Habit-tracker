import 'package:website/pages/template_page.dart';
import 'package:website/services/api_manager.dart';
import '../widgets/nav_button.dart';

class HabitsPage extends TemplatePage {
  final String title = 'Habits Page';
  final NavigationOptions page = NavigationOptions.habits;

  const HabitsPage(ApiManager apiManager, {super.key})
      : super(apiManager: apiManager);
}
