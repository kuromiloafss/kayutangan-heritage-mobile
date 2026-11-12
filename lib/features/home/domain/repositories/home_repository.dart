import '../../../category/domain/entities/kategori.dart';

abstract class HomeRepository {
  List<Kategori> getHomeCategories();
}
