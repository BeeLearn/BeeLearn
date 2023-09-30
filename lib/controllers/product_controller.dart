import '../mixins/api_model_mixin.dart';
import '../serializers/serializers.dart';

class _ProductController with ApiModelMixin {
  @override
  String? get basePath => "api/payment/products";

  Future<Paginate<Product>> listProducts({
    String? url,
    Map<String, dynamic>? query,
  }) {
    return super.list(
      url: url,
      query: query,
      fromJson: (Map<String, dynamic> json) => Paginate.fromJson(json, Product.fromJson),
    );
  }

}

final productController = _ProductController();
