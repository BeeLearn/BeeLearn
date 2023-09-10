import '../mixins/api_model_mixin.dart';
import '../serializers/paginate.dart';
import '../serializers/product.dart';
import 'base_model.dart';

class ProductModel extends BaseModel<Product> with ApiModelMixin {
  @override
  int getEntityId(item) => item.id;

  @override
  int orderBy(first, second) => first.createdAt.compareTo(second.createdAt);

  @override
  String? get basePath => "api/payment/products";

  Future<Paginate<Product>> listProducts({
    String? url,
    Map<String, dynamic>? query,
  }) {
    return super.list(
      url: url,
      query: query,
      fromJson: (json) => Paginate.fromJson(json, Product.fromJson),
    );
  }
}
