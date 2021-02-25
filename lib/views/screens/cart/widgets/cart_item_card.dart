import 'package:e_commerce_app/business_logic/services/product_service.dart';
import 'package:e_commerce_app/configs/router.dart';
import 'package:e_commerce_app/utils/common_func.dart';
import 'package:e_commerce_app/configs/size_config.dart';
import 'package:e_commerce_app/constants/color_constant.dart';

import 'package:e_commerce_app/views/widgets/buttons/circle_icon_button.dart';
import 'package:e_commerce_app/business_logic/entities/cart_item.dart';
import 'package:e_commerce_app/business_logic/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    Key key,
    this.cartItem,
  }) : super(key: key);

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ProductService().getProductById(cartItem.pid),
      builder: (context, snapshot) {
        Product product = snapshot.data;
        return snapshot.hasData
            ? GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.show_details,
                    arguments: product,
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: getProportionateScreenHeight(130),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(3, 4),
                        blurRadius: 10,
                        color: Color(0XFFB0CCE1).withOpacity(0.4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _buildCartItemImage(product),
                      SizedBox(width: getProportionateScreenWidth(10)),
                      Expanded(
                        child: buildCartItemInfo(product, context),
                      ),
                    ],
                  ),
                ),
              )
            // Loading
            : Container(
                alignment: Alignment.center,
                height: getProportionateScreenHeight(130),
                child: SpinKitCircle(color: mPrimaryColor),
              );
      },
    );
  }

  // CartItem image
  AspectRatio _buildCartItemImage(Product product) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: loadImage(product.images[0]),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Image.network(snapshot.data)
                : SpinKitCircle(color: mPrimaryColor);
          },
        ),
      ),
    );
  }

  // CartItem Info
  Column buildCartItemInfo(Product product, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        Text(
          "${product.name}",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        // Cart item price
        Text(
          "${formatNumber(product.originalPrice)} VNĐ",
          style: TextStyle(color: mPrimaryColor, fontSize: 17),
        ),
        SizedBox(height: 5),

        _buildCartItemQuantity(product, context)
      ],
    );
  }

  // Cart item quantity
  Row _buildCartItemQuantity(Product product, BuildContext context) {
    return Row(
      children: [
        // decrease button
        CircleIconButton(
          icon: Icon(Icons.remove),
          color: Color(0xFFF5F6F9).withOpacity(0.7),
          size: getProportionateScreenWidth(30),
          handleOnPress: cartItem.quantity > 1 ? () {} : () {},
        ),
        const SizedBox(width: 10),
        // quantity
        Text(
          "${cartItem.quantity}",
          style: TextStyle(
            color: mPrimaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        // increase button
        CircleIconButton(
          icon: Icon(Icons.add),
          color: Color(0xFFF5F6F9).withOpacity(0.7),
          size: getProportionateScreenWidth(30),
          handleOnPress: cartItem.quantity < product.quantity ? () {} : () {},
        )
      ],
    );
  }
}
