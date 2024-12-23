import 'package:website/models/MetaKeys.dart';
import 'package:website/services/api_manager.dart';

class MetaInfo {
  static final MetaInfo _instance = MetaInfo._internal();
  static final ApiManager _apiManager = ApiManager();

  final Map<MetaKeys, dynamic> _store = {};

  MetaInfo._internal();

  static MetaInfo get instance => _instance;

  void set(MetaKeys key, dynamic value) => _store[key] = value;

  static ApiManager getApiManager() {
    return _apiManager;
  }

  dynamic get(MetaKeys key) => _store[key];

  void delete(MetaKeys key) => _store.remove(key);

  void clear() => _store.clear();
}
