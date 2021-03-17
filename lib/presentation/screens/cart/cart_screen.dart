import 'package:e_commerce_app/business_logic/blocs/app_bloc.dart';
import 'package:e_commerce_app/presentation/screens/cart/widgets/cart_body.dart';
import 'package:e_commerce_app/presentation/screens/cart/widgets/checkout_bottom.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/business_logic/blocs/cart/bloc.dart';
import 'package:e_commerce_app/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: CartBody(),
      bottomNavigationBar: CheckoutBottom(),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(Translate.of(context).translate("cart")),
      actions: [
        IconButton(
            icon: Icon(Icons.clear_all_rounded),
            onPressed: () => _onClearCart(context))
      ],
    );
  }

  _onClearCart(BuildContext context) async {
    final response = await MyDialog.showConfirmation(
      context,
      title: Translate.of(context).translate("clear_cart"),
      content: Text(
        Translate.of(context)
            .translate("all_cart_items_will_be_deleted_from_your_cart"),
      ),
      confirmButtonText: Translate.of(context).translate("delete"),
    ) as bool;

    if (response) {
      BlocProvider.of<CartBloc>(context).add(ClearCart());
    }
  }
}
