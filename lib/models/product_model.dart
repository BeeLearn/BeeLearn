import '../serializers/product.dart';
import 'base_model.dart';

class ProductModel extends BaseModel<Product> {
  @override
  int getEntityId(item) => item.id;

  @override
  int orderBy(first, second) => first.createdAt.compareTo(second.createdAt);
}
