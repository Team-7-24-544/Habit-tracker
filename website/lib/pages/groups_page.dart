import 'package:website/pages/template_page.dart';
import '../widgets/navigation_widgets/nav_button.dart';

class GroupsPage extends TemplatePage {
  @override
  String get title => 'Groups Page';

  @override
  NavigationOptions get page => NavigationOptions.groups;

  const GroupsPage({super.key});
}
