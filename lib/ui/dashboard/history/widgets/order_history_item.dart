import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';
import 'package:letsbeenextgenrider/data/models/additional.dart';
import 'package:letsbeenextgenrider/data/models/variant.dart';
import 'package:letsbeenextgenrider/data/models/product.dart';
import 'package:letsbeenextgenrider/data/models/response/get_history_by_date_and_status_response.dart';
import 'package:letsbeenextgenrider/ui/widget/animated_expandable_container.dart';
import 'package:intl/intl.dart';

class OrderHistoryItem extends StatelessWidget {
  final TickerProvider vsync;
  final GetHistoryData order;

  OrderHistoryItem({@required this.vsync, @required this.order});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: AnimatedExpandableContainer(
        vsync: vsync,
        expandedIconPath: 'arrow_down_black.svg',
        unexpandedIconPath: 'arrow_up_black.svg',
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Order No. ${order.orderId}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SvgPicture.asset(
                    Config.SVG_PATH + 'store_icon.svg',
                    height: 23,
                    width: 23,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            order.storeName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        content: Column(
          children: [
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SvgPicture.asset(
                    Config.SVG_PATH + 'customer_icon.svg',
                    height: 23,
                    width: 23,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            order.customerName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivered ' +
                        DateFormat('M/dd/yyyy h:mm a').format(
                          order.updatedAt.toUtc().toLocal(),
                        ),
                  ),
                  Text(
                    'PHP ${order.fee.totalPrice}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            const Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
            ),
            Column(
              children: order.products
                  .map((product) => _buildMenuItem(product))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(Product product) {
    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${product.quantity}x',
                        style: TextStyle(color: Colors.black),
                      ),
                      const Padding(
                        padding: const EdgeInsets.only(right: 16),
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${product.name}',
                              style: TextStyle(color: Colors.black),
                            ),
                            product.additionals.isEmpty
                                ? const SizedBox.shrink()
                                : _buildAdditionalColumn(product.additionals),
                            product.variants.isEmpty
                                ? const SizedBox.shrink()
                                : _buildChoiceColumn(product.variants),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  product.price,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
            product.note.isEmpty || product.note == null
                ? const SizedBox.shrink()
                : Text(
                    'Note: ${product.note}',
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalColumn(List<Additional> additional) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
              children: additional.map((e) => _buildAdditional(e)).toList()),
        ),
      ],
    );
  }

  Widget _buildAdditional(Additional additional) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            child: Text(additional.name,
                style: TextStyle(
                  color: Colors.black,
                )),
          ),
        ),
        Text('+₱ ${additional.price}',
            style: TextStyle(
              color: Colors.black,
            ))
      ],
    );
  }

  Widget _buildChoiceColumn(List<Variant> variant) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Column(
          children: variant.map((e) => _buildChoice(e)).toList(),
        )),
      ],
    );
  }

  Widget _buildChoice(Variant variant) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            child: Text('${variant.type}: ${variant.pick}',
                style: TextStyle(
                  color: Colors.black,
                )),
          ),
        ),
        Text(
          '+₱ ${variant.price}',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
