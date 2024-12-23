import 'package:website/pages/template_page.dart';
import '../widgets/navigation_widgets/nav_button.dart';

class SettingsPage extends TemplatePage {
  @override
  String get title => 'Settings Page';

  @override
  NavigationOptions get page => NavigationOptions.settings;

  const SettingsPage({super.key});
}
