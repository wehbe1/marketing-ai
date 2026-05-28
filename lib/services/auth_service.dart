import '../core/constants.dart';
import '../models/user_model.dart';
import 'api_client.dart';

abstract final class AuthService {
  /// Upsert the backend user profile after Firebase authentication.
  static Future<UserModel> syncUser({String? fullName}) async {
    final json = await ApiClient.post(
      ApiConstants.sync,
      {if (fullName != null && fullName.isNotEmpty) 'full_name': fullName},
      auth: true,
    ) as Map<String, dynamic>;
    return UserModel.fromJson(json['user'] as Map<String, dynamic>);
  }

  static Future<UserModel> getMe() async {
    final json = await ApiClient.get(ApiConstants.me) as Map<String, dynamic>;
    return UserModel.fromJson(json);
  }
}
