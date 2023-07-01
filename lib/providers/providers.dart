import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmallow/models/user_model.dart';
import 'package:taskmallow/repositories/project_repository.dart';
import 'package:taskmallow/repositories/user_repository.dart';

final verificationCodeProvider = StateProvider<int?>((ref) => null);
final verificationUserProvider = StateProvider<UserModel?>((ref) => null);

final userProvider = ChangeNotifierProvider((ref) {
  return UserRepository();
});
final projectProvider = ChangeNotifierProvider((ref) {
  return ProjectRepository();
});

final selectedPageIndexProvider = StateProvider<int>((ref) => 0);
final appVersionProvider = StateProvider<String>((ref) => "");
