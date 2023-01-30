import 'dart:developer';

import 'package:dw9_delivery_app/app/core/exceptions/repository_excepetion.dart';
import 'package:dw9_delivery_app/app/core/rest_client/custom_dio.dart';
import 'package:dw9_delivery_app/app/models/product_model.dart';

import './products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final CustomDio dio;

  ProductsRepositoryImpl({required this.dio});

  @override
  Future<List<ProductModel>> findAllProducts() async {
    try {
      final result = await dio.unAuth().get('/products');
      return result.data.map<ProductModel>((p) => ProductModel.fromMap(p)).tolist();
    } on Exception catch (e, s) {
      log('Erro ao buscar lista de produtos', error: e, stackTrace: s);
      throw RepositoryExcepetion(message: 'Erro ao buscar lista de produtos.');
    }
  }
}
