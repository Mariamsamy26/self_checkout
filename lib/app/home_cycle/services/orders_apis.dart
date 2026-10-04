import 'package:gosmart_self_checkout/app/home_cycle/models/cart_line.dart';
import 'package:gosmart_self_checkout/app/home_cycle/models/product_by_barcode.dart';
import 'package:gosmart_self_checkout/services/dio_client.dart';

class OrdersApis {
  Future<ProductByBarcode?> getProductDetailsByBarcode(
    String barcode,
    String branchId,
  ) async {
    String url =
        'http://46.62.153.179:12000/get_product_details_by_barcode/$barcode/$branchId';

    print('url: $url');

    try {
      // final response = await Client.client.get('http://157.180.26.238:10000${uri.path}');
      print('url: $url');
      String trimmedUrl = url.trim();
      final response = await Client.client.get(trimmedUrl);

      if (response.statusCode == 200) {
        ProductByBarcode productByBarcode = ProductByBarcode.fromJson(
          response.data,
        );

        print(response.data);

        return productByBarcode;
      } else {
        return null;
      }
    } catch (e) {
      throw ('Error fetching product details: $e');
    }
  }

  Future<void> placeOrder(List<CartLine> cartItemsList, String branchId) async {
    String url = 'http://46.62.153.179:12000/place_order';

    try {
      final response = await Client.client.post(
        url,
        data: {
          "dummy": '',
          "branch_id": branchId,
          "lines": [
            for (var item in cartItemsList)
              {"product_id": item.productId, "qty": item.selectedQty},
          ],
        },
      );

      if (response.statusCode == 200) {
        print('Order placed successfully');
      } else {
        print('Failed to place order: ${response.statusCode}');
      }
    } catch (e) {
      throw ('Error placing order: $e');
    }
  }
}
