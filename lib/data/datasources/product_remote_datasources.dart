import 'package:dartz/dartz.dart';
import 'package:pos_app/data/datasources/auth_local_datasources.dart';
import 'package:pos_app/data/models/response/product_response_model.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/variables.dart';

class ProductRemoteDatasource {
  Future<Either<String, ProductResponseModel>> getProducts() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(
        Uri.parse(
          '${Variable.baseUrl}/api/products',
        ),
        headers: {
          'Authorization': 'Bearer ${authData.token}',
        });
    if (response.statusCode == 200) {
      return Right(ProductResponseModel.fromJson(response.body));
    } else {
      return Left(response.body);
    }
  }
}
