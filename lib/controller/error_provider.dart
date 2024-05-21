import 'package:flutter_riverpod/flutter_riverpod.dart';

final errorProvider = StateProvider<String>((ref) {
  String error = "";
  return error;
});
