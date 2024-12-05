import 'package:website/pages/template_page.dart';
import '../services/api_manager.dart';
import '../widgets/nav_button.dart';

class ProfilePage extends TemplatePage {
  final String title = 'Profile Page';
  final NavigationOptions page = NavigationOptions.profile;

  const ProfilePage(ApiManager apiManager, {super.key})
      : super(apiManager: apiManager);
}
