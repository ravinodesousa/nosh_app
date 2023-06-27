import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nosh_app/components/bottomsheet/add_category.dart';
import 'package:nosh_app/data/category_item.dart';
import 'package:nosh_app/data/product.dart';
import 'package:nosh_app/helpers/http.dart';
import 'package:nosh_app/helpers/widgets.dart';
import 'package:nosh_app/screens/add_menu_item.dart';
import 'package:nosh_app/screens/edit_menu_item.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _loading = true;
  List<CategoryItem> _categoryList = [];

  @override
  void initState() {
    super.initState();
    initCategory();
  }

  void initCategory() async {
    setState(() {
      _loading = true;
    });
    final SharedPreferences prefs = await _prefs;

    List<CategoryItem> temp = await getCategories(true);
    setState(() {
      _categoryList = temp;
      _loading = false;
    });
  }

  void updateCategoryStatusHandler(String id) async {
    setState(() {
      _loading = true;
      _categoryList = [];
    });
    Map<String, dynamic> result = await updateCategoryStatus(id);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result["status"] == 200
          ? "Product Status Updated successfully"
          : "Failed to Update Product Status. Please try again."),
    ));

    initCategory();
  }

  bottomsheetaddcategory(
      BuildContext context, String opType, CategoryItem? selectedCategory) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (ctx) {
          return Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: AddCategoryBottomSheet(
              category: selectedCategory,
              initCallback: () => {initCategory()},
              operation: opType,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    /* ModalProgressHUD - creates an overlay to display loader */

    return Scaffold(
      appBar: AppBar(title: Text("Categories"), actions: [
        TextButton.icon(
          onPressed: () {
            bottomsheetaddcategory(context, "ADD", null);
          },
          icon: Icon(Icons.add, color: Colors.white),
          label: Text(
            "Add Category",
            style: TextStyle(color: Colors.white),
          ),
        )
      ]),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        color: Colors.black54,
        opacity: 0.7,
        progressIndicator: Theme(
          data: ThemeData.dark(),
          child: CupertinoActivityIndicator(
            animating: true,
            radius: 30,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () {
            initCategory();
            return Future(() => null);
          },
          child: Column(
            children: [
              !_loading && _categoryList.length > 0
                  ? Expanded(
                      flex: 1,
                      child: ListView.custom(
                          childrenDelegate: SliverChildBuilderDelegate(
                        childCount: _categoryList.length,
                        (context, index) {
                          CategoryItem item = _categoryList.elementAt(index);

                          return Card(
                            color: Colors.grey.shade300,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 8, right: 8, top: 15, bottom: 15),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 30),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.network(
                                              item.image ??
                                                  'http://via.placeholder.com/640x360',
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          item.name ?? '',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              bottomsheetaddcategory(
                                                  context, "UPDATE", item);
                                            },
                                            child: Icon(Icons.edit, size: 18),
                                            style: ElevatedButton.styleFrom(
                                              textStyle: TextStyle(fontSize: 5),
                                              padding: EdgeInsets.all(5),
                                              backgroundColor: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        (item.is_active ?? false)
                                            ? SizedBox(
                                                width: 30,
                                                height: 30,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    updateCategoryStatusHandler(
                                                        item.id as String);
                                                  },
                                                  child: Icon(Icons.close,
                                                      size: 18),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    textStyle:
                                                        TextStyle(fontSize: 5),
                                                    padding: EdgeInsets.all(5),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                ),
                                              )
                                            : SizedBox(
                                                width: 30,
                                                height: 30,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    updateCategoryStatusHandler(
                                                        item.id as String);
                                                  },
                                                  child: Icon(Icons.check,
                                                      size: 18),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    textStyle:
                                                        TextStyle(fontSize: 5),
                                                    padding: EdgeInsets.all(5),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ]),
                            ),
                          );
                        },
                      )),
                    )
                  : !_loading && _categoryList.length == 0
                      ? Expanded(
                          flex: 1,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "No Categories Found",
                                style: TextStyle(
                                    fontSize: 23, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 120,
                                child: ElevatedButton(
                                  onPressed: () {
                                    initCategory();
                                  },
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("Refresh"),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(Icons.refresh)
                                      ]),
                                ),
                              )
                            ],
                          )),
                        )
                      : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
