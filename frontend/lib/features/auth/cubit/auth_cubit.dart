import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/services/sp_service.dart';
import 'package:frontend/features/auth/repository/auth_local_repository.dart';
import 'package:frontend/features/auth/repository/auth_remote_repository.dart';
import 'package:frontend/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final authRemoteRepository = AuthRepository();
  final authLocalRepository = AuthLocalRepository();
  final spService = SpService();

  void getUserData() async {
    try {
      emit(AuthLoading());

      final userModel = await authRemoteRepository.getUserData();

      if (userModel != null) {
        await authLocalRepository.insertUser(userModel);
        emit(AuthLoggedIn(userModel));
      } else {
        //This is necessary because if it is not we will show loading only in the screen
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }

  void signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());

      await authRemoteRepository.signup(
        name: name,
        email: email,
        password: password,
      );

      emit(AuthSignup());
      return;
    } catch (e) {
      emit(AuthError(e.toString()));
      return;
    }
  }

  void login({required String email, required String password}) async {
    try {
      emit(AuthLoading());

      final userModel = await authRemoteRepository.login(
        email: email,
        password: password,
      );

      if (userModel.token.isNotEmpty) {
        await spService.setToken(userModel.token);
      }

      //Store in local Database Sql so that wen offline things will work
      await authLocalRepository.insertUser(userModel);

      emit(AuthLoggedIn(userModel));
      return;
    } catch (e) {
      emit(AuthError(e.toString()));
      return;
    }
  }
}
