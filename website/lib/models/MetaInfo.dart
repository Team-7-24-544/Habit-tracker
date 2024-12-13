import 'package:website/models/MetaKeys.dart';

class MetaInfo {
  static final MetaInfo _instance = MetaInfo._internal();

  final Map<MetaKeys, dynamic> _store = {};

  MetaInfo._internal();

  static MetaInfo get instance => _instance;

  void set(MetaKeys key, dynamic value) => _store[key] = value;

  dynamic get(MetaKeys key) => _store[key];

  void delete(MetaKeys key) => _store.remove(key);

  void clear() => _store.clear();
}
