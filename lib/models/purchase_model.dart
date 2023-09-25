import '../serializers/serializers.dart';
import 'base_model.dart';

class PurchaseModel extends BaseModel<Product> {
  @override
  int getEntityId(item) => item.id;

  @override
  int orderBy(first, second) => first.createdAt.compareTo(second.createdAt);
}
