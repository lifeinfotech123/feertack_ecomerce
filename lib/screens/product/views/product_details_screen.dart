import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/components/cart_button.dart';
import 'package:shop/components/custom_modal_bottom_sheet.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/constants.dart';
import 'package:shop/controllers/cart_controller.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/screens/product/views/product_returns_screen.dart';

import 'package:shop/route/screen_export.dart';

import 'components/notify_me_card.dart';
import 'components/product_images.dart';
import 'components/product_info.dart';
import 'components/product_list_tile.dart';
import '../../../components/review_card.dart';
import 'product_buy_now_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel? product;
  final bool isProductAvailable;

  const ProductDetailsScreen({
    super.key,
    this.product,
    this.isProductAvailable = true,
  });

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    ProductModel currentProduct;

    if (product != null) {
      currentProduct = product!;
    } else if (routeArgs is ProductModel) {
      currentProduct = routeArgs;
    } else {
      currentProduct = demoPopularProducts.first;
    }

    final CartController cart = CartController.instance;
    final finalPrice =
        currentProduct.priceAfetDiscount ?? currentProduct.price;

    return Scaffold(
      bottomNavigationBar: isProductAvailable
          ? CartButton(
              price: finalPrice,
              title: "Add to cart",
              subTitle: "Total Price",
              press: () {
                cart.addToCart(currentProduct);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: successColor,
                    behavior: SnackBarBehavior.floating,
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "${currentProduct.title} added to cart!",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    action: SnackBarAction(
                      label: "VIEW CART",
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.pushNamed(context, cartScreenRoute);
                      },
                    ),
                  ),
                );
              },
            )
          : NotifyMeCard(
              isNotify: false,
              onChanged: (value) {},
            ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Saved to Wishlist!"),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/Bookmark.svg",
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, cartScreenRoute);
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/Bag.svg",
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
              ],
            ),

            // Product Images Slider
            ProductImages(
              images: [
                currentProduct.image,
                productDemoImg2,
                productDemoImg3,
              ],
            ),

            // Product Information Header
            ProductInfo(
              brand: currentProduct.brandName.toUpperCase(),
              title: currentProduct.title,
              isAvailable: isProductAvailable,
              description:
                  "Premium curated design with exceptional durability and high comfort. Handcrafted with authentic materials, designed for your everyday lifestyle.",
              rating: 4.8,
              numOfReviews: 128,
            ),

            // Product Details tile
            ProductListTile(
              svgSrc: "assets/icons/Product.svg",
              title: "Product Specifications & Details",
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: const ProductBuyNowScreen(),
                );
              },
            ),

            // Shipping Information
            ProductListTile(
              svgSrc: "assets/icons/Delivery.svg",
              title: "⚡ Express 10-15 Mins Delivery Info",
              press: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Free delivery on orders above \$25. Express 10-15 mins delivery."),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),

            // Returns Info
            ProductListTile(
              svgSrc: "assets/icons/Return.svg",
              title: "Easy 7-Day Free Returns",
              isShowBottomBorder: true,
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: const ProductReturnsScreen(),
                );
              },
            ),

            // Reviews Summary Rating Card
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: ReviewCard(
                  rating: 4.8,
                  numOfReviews: 128,
                  numOfFiveStar: 82,
                  numOfFourStar: 32,
                  numOfThreeStar: 10,
                  numOfTwoStar: 3,
                  numOfOneStar: 1,
                ),
              ),
            ),

            // Reviews List Tile
            ProductListTile(
              svgSrc: "assets/icons/Chat.svg",
              title: "Customer Reviews & Ratings (128)",
              isShowBottomBorder: true,
              press: () {
                Navigator.pushNamed(
                  context,
                  productReviewsScreenRoute,
                  arguments: {
                    "title": currentProduct.title,
                    "brand": currentProduct.brandName,
                    "image": currentProduct.image,
                    "rating": 4.8,
                  },
                );
              },
            ),

            // Recommendations Header
            SliverPadding(
              padding: const EdgeInsets.all(defaultPadding),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "You May Also Like",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),

            // Horizontal Recommended Products
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: demoPopularProducts.length,
                  itemBuilder: (context, index) {
                    final item = demoPopularProducts[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        left: defaultPadding,
                        right: index == demoPopularProducts.length - 1
                            ? defaultPadding
                            : 0,
                      ),
                      child: ProductCard(
                        image: item.image,
                        title: item.title,
                        brandName: item.brandName,
                        price: item.price,
                        priceAfetDiscount: item.priceAfetDiscount,
                        dicountpercent: item.dicountpercent,
                        press: () {
                          Navigator.pushNamed(
                            context,
                            productDetailsScreenRoute,
                            arguments: item,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: defaultPadding * 2),
            ),
          ],
        ),
      ),
    );
  }
}
