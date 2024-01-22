import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:pos_app/core/constants/variables.dart';
import 'package:pos_app/data/models/response/auth_response_model.dart';

class AuthRemoteDatasource {
  Future<Either<String, AuthResponseModel>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse(
        '${Variable.baseUrl}/api/login',
      ),
      body: {
        "email": email,
        "password": password,
      },
    );
    if (response.statusCode == 200) {
      return Right(AuthResponseModel.fromJson(response.body));
    } else {
      return left(response.body);
    }
  }
}
