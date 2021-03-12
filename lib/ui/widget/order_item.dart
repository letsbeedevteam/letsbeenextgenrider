import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:intl/intl.dart';
import 'package:letsbeenextgenrider/ui/widget/accept_button.dart';

class OrderItem extends StatelessWidget {
  final OrderData order;
  const OrderItem({
    Key key,
    @required this.onTap,
    @required this.order,
  }) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Wrap(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 70,
                          child: Text(
                            DateFormat('h:mm a').format(
                              order.createdAt.toUtc().toLocal(),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        ),
                        Text(
                          '${order.status}',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    Text(
                      'PHP ${order.fee.totalPrice}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                const Padding(
                  padding: const EdgeInsets.only(top: 4),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 70,
                    alignment: Alignment.center,
                    child: Text('#${order.id}'),
                  ),
                ),
                const Padding(
                  padding: const EdgeInsets.only(top: 4),
                ),
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 70,
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          Config.SVG_PATH + 'store_icon.svg',
                          height: 23,
                          width: 23,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            order.store.locationName.isEmpty
                                ? Flexible(
                                    child: Text(
                                      '${order.store.name}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  )
                                : Flexible(
                                    child: Text(
                                      '${order.store.name} - ${order.store.locationName}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                ),
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 70,
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          Config.SVG_PATH + 'customer_icon.svg',
                          height: 23,
                          width: 23,
                        ),
                      ),
                      const Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                '${order.user.name}',
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
                const Padding(padding: const EdgeInsets.symmetric(vertical: 4)),
                AcceptButton(
                  onTap: onTap,
                  title: 'ACCEPT ORDER',
                  mainAxisSize: MainAxisSize.max,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
