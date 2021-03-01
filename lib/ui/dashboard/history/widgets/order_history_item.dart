import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';
import 'package:letsbeenextgenrider/data/models/additional.dart';
import 'package:letsbeenextgenrider/data/models/choice.dart';
import 'package:letsbeenextgenrider/data/models/product.dart';
import 'package:letsbeenextgenrider/data/models/response/get_status_by_date_and_status_response.dart';
import 'package:letsbeenextgenrider/ui/widget/animated_expandable_container.dart';

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
                  Text('delivered chuchu'),
                  Text(
                    'PHP ${order.fee.total}',
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
    return Center(
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
                        child: Wrap(
                          children: [
                            Text(
                              '${product.name}',
                              style: TextStyle(color: Colors.black),
                            ),
                            product.additionals.isEmpty
                                ? const SizedBox.shrink()
                                : _buildAdditionalColumn(product.additionals),
                            product.choices.isEmpty
                                ? const SizedBox.shrink()
                                : _buildChoiceColumn(product.choices),
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
            product.note == null
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
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ),
        ),
        Text('+₱ ${additional.price}',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14))
      ],
    );
  }

  Widget _buildChoiceColumn(List<Choice> choices) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Column(
          children: choices.map((e) => _buildChoice(e)).toList(),
        )),
      ],
    );
  }

  Widget _buildChoice(Choice choice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            child: Text('${choice.name}: ${choice.pick}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ),
        ),
        Text(
          '+₱ ${choice.price}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
