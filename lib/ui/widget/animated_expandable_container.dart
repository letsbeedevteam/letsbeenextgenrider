import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';

class AnimatedExpandableContainer extends StatelessWidget {
  AnimatedExpandableContainer(
      {Key key,
      @required this.vsync,
      @required this.expandedIconPath,
      @required this.inexpandedIconPath,
      this.isExpandedAtFirst,
      this.title,
      this.subTitle,
      this.content,
      this.isCircularBorder = true,
      this.arrowColor = Colors.black})
      : super(key: key);

  final RxBool isExpanded = false.obs;
  final bool isExpandedAtFirst;
  final TickerProvider vsync;
  final Widget title;

  ///Hidden when content is visible
  final Widget subTitle;
  final Widget content;
  final bool isCircularBorder;
  final Color arrowColor;

  ///Should be a path to an svg icon
  ///assets/svg/ should not be included
  final String expandedIconPath;

  ///Should be a path to an svg icon
  ///assets/svg/ should not be included
  final String inexpandedIconPath;

  @override
  Widget build(BuildContext context) {
    isExpanded.value = isExpandedAtFirst;
    return GestureDetector(
      onTap: () {
        isExpanded.value = !isExpanded.value;
      },
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: isCircularBorder ? BorderRadius.circular(10) : null,
              color: Colors.white,
            ),
            child: Obx(
              () => AnimatedSize(
                vsync: vsync,
                duration: Duration(milliseconds: 100),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    title ?? SizedBox.shrink(),
                                    !isExpanded.value
                                        ? subTitle ?? SizedBox.shrink()
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              )
                            ],
                          ),
                          !isExpanded.value
                              ? const SizedBox.shrink()
                              : Container(
                                  padding: const EdgeInsets.only(
                                      top: 16, left: 8, right: 8),
                                  child: content ?? const SizedBox.shrink(),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8),
              child: Obx(
                () => SvgPicture.asset(
                  isExpanded.value
                      ? Config.SVG_PATH + expandedIconPath
                      : Config.SVG_PATH + inexpandedIconPath,
                  color: arrowColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
