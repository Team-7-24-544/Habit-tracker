import 'package:website/pages/template_page.dart';
import '../widgets/nav_button.dart';

class HabitsPage extends TemplatePage {
  @override
  String get title => 'Habits Page';

  @override
  NavigationOptions get page => NavigationOptions.habits;

  const HabitsPage({super.key});
}
