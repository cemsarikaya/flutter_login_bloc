/*

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_login_bloc/login/model/login_model.dart';
import 'package:flutter_login_bloc/login/model/token_model.dart';

abstract class ILoginService {
  ILoginService(this.dio);
  final Dio dio;

  Future<TokenModel?> fetchResourceItem(LoginModel loginModel);
}

class LoginService extends ILoginService {
  LoginService(Dio dio) : super(dio);

  @override
  Future<TokenModel?> fetchResourceItem(LoginModel) async {
    final response = await dio.get('/api/login');

    if (response.statusCode == HttpStatus.ok) {
      final jsonBody = response.data;
      if (jsonBody is Map<String, dynamic>) {
        return TokenModel.fromJson(jsonBody);
      }
    }
    return null;
  }
}
*/
import 'package:flutter_login_bloc/login/model/token_model.dart';

import '../model/login_model.dart';

import 'package:vexana/vexana.dart';

abstract class ILoginService {
  final INetworkManager networkManager;

  ILoginService(this.networkManager);
  Future<IResponseModel<TokenModel?>?> login(LoginModel model);

  final String _loginPath = 'api/login';
}

class LoginService extends ILoginService {
  LoginService(INetworkManager networkManager) : super(networkManager);

  @override
  Future<IResponseModel<TokenModel?>?> login(LoginModel model) async {
    return await networkManager.send<TokenModel, TokenModel>(_loginPath,
        data: model, parseModel: TokenModel(), method: RequestType.POST);
  }
}
