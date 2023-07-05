import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';

class FakeProductsRepository {
  // Private constructor to prevent multiple instance
  FakeProductsRepository._();

  // This is a brutal singleton
  // TODO: use dependency
  static FakeProductsRepository instance = FakeProductsRepository._();

  final List<Product> _product = kTestProducts;

  List<Product> getProductsList() {
    return _product;
  }

  Product? getProduct(String id) {
    return _product.firstWhere((product) => product.id == id);
  }

  Future<List<Product>> fetchProductsList() {
    return Future.value(_product);
  }

  Stream<List<Product>> streamProductsList() {
    return Stream.value(_product);
  }

  // Future<Product?> fetchProduct(String id) {
  //   return fetchProductsList();
  // }

  Stream<Product?> watchProduct(String id) {
    return streamProductsList().map(
      (products) => products.firstWhere((product) => product.id == id),
    );
  }
}
