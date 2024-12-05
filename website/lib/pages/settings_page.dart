import 'package:website/pages/template_page.dart';
import '../services/api_manager.dart';
import '../widgets/nav_button.dart';

class SettingsPage extends TemplatePage {
  final String title = 'Settings Page';
  final NavigationOptions page = NavigationOptions.settings;

  const SettingsPage(ApiManager apiManager, {super.key})
      : super(apiManager: apiManager);
}
