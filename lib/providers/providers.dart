import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmallow/models/user_model.dart';

final loggedUserProvider = StateProvider<UserModel?>((ref) => null);
final verificationCodeProvider = StateProvider<int?>((ref) => null);
final verificationUserProvider = StateProvider<UserModel?>((ref) => null);
