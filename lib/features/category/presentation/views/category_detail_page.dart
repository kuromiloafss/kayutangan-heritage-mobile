import 'package:flutter/material.dart';

import '../../domain/entities/place.dart';
import '../components/place_card.dart';
import '../viewmodels/category_view_model.dart';
import '../viewmodels/place_detail_view_model.dart';
import 'place_detail_page.dart';

class CategoryDetailPage extends StatefulWidget {
  final String categoryTitle;
  final CategoryViewModel vm;
  final PlaceDetailViewModel placeDetailViewModel;

  const CategoryDetailPage({
    super.key,
    required this.categoryTitle,
    required this.vm,
    required this.placeDetailViewModel,
  });

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  @override
  void initState() {
    super.initState();
    widget.vm.ambilPlaceByKategoriData(widget.categoryTitle);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.vm,
      builder: (context, _) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E1E)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.categoryTitle,
            style: const TextStyle(
              color: Color(0xFF1E1E1E),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
        ),
        body: widget.vm.pesanError != null
            ? Center(child: Text(widget.vm.pesanError!))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                itemCount: widget.vm.places.length,
                itemBuilder: (context, index) {
                  final Place item = widget.vm.places[index];
                  return PlaceCard(
                    item: item,
                    onDetailTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaceDetailPage(
                            vm: widget.placeDetailViewModel,
                            placeId: item.id,
                            categoryTitle: widget.categoryTitle,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
