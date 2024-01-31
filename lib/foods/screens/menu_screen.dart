import 'package:flutter/material.dart';
import 'package:foodpanda_seller/constants/colors.dart';
import 'package:foodpanda_seller/foods/controllers/food_controller.dart';
import 'package:foodpanda_seller/foods/screens/add_category_screen.dart';
import 'package:foodpanda_seller/foods/screens/food_screen.dart';
import 'package:foodpanda_seller/foods/widgets/category_card.dart';
import 'package:foodpanda_seller/models/category.dart';

class MenuScreen extends StatefulWidget {
  static const String routeName = '/menu-screen';
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  FoodController foodController = FoodController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xffF3D7CA),
      appBar: AppBar(
        backgroundColor: Color(0xffF3D7CA),
        title: const Text(
          'DS Finance',
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 16,
            color: Colors.black
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AddCategoryScreen.routeName,
                arguments:
                    const AddCategoryScreen(title: '', subtitle: '', id: ''),
              );
            },
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'كل الطلبات المتاحه',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              StreamBuilder<List<Category>>(
                stream: foodController.fetchCategory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('loading');
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final category = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: CategoryCard(
                              title: category.title,
                              subtitle: category.subtitle,
                              id: category.id,
                              isPublished: category.isPublished,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  FoodScreen.routeName,
                                  arguments: category.id,
                                );
                              },
                              onEditTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AddCategoryScreen.routeName,
                                  arguments: AddCategoryScreen(
                                    title: category.title,
                                    subtitle: category.subtitle,
                                    id: category.id,
                                  ),
                                );
                              },
                              onDeleteTap: () async {
                                await foodController.deleteCategory(
                                  id: category.id,
                                );
                              }),
                        );
                      });
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
