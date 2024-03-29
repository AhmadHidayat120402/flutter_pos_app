// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pos_app/data/datasources/product_local_datasource.dart';

import 'package:pos_app/data/datasources/product_remote_datasources.dart';

import '../../../../data/models/response/product_response_model.dart';

part 'product_bloc.freezed.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRemoteDatasource productRemoteDatasource;
  List<Product> products = [];
  ProductBloc(
    this.productRemoteDatasource,
  ) : super(const _Initial()) {
    on<_Fetch>((event, emit) async {
      emit(const _Loading());
      final response = await productRemoteDatasource.getProducts();
      response.fold(
        (l) => emit(_Error(l)),
        (r) {
          products = r.data;
          emit(_Success(r.data));
        },
      );
    });

    on<_FetchLokal>((event, emit) async {
      emit(const _Loading());
      final localProducts =
          await ProductLocalDatasource.instance.getAllProduct();
      products = localProducts;
      emit(_Success(products));
    });

    on<_FetchByCategory>((event, emit) {
      emit(const _Loading());
      final newProducts = event.category == 'all'
          ? products
          : products
              .where((element) => element.category == event.category)
              .toList();
      emit(_Success(newProducts));
    });
  }
}
