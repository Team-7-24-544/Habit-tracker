import 'package:website/pages/template_page.dart';
import '../services/api_manager.dart';
import '../widgets/nav_button.dart';

class GroupsPage extends TemplatePage {
  @override
  final String title = 'Groups Page';
  @override
  final NavigationOptions page = NavigationOptions.groups;

  const GroupsPage(ApiManager apiManager, {super.key})
      : super(apiManager: apiManager);
}
