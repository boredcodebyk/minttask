import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pref.dart';
import '../model/task.dart';

final filterProvider = StateProvider<Filter>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final filterSelected = Filter.values.firstWhere(
    (element) => element.toString() == prefs.getString("filter"),
    orElse: () => Filter.id,
  );
  ref.listenSelf(
    (previous, next) => prefs.setString("filter", next.name),
  );
  return filterSelected;
});

final sortProvider = StateProvider<Sort>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final sortSelected = Sort.values.firstWhere(
    (element) => element.toString() == prefs.getString("sort"),
    orElse: () => Sort.desc,
  );
  ref.listenSelf(
    (previous, next) => prefs.setString("sort", next.name),
  );
  return sortSelected;
});
