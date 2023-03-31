import 'package:flutter/material.dart';
import 'package:number_paginator/src/model/config.dart';
import 'package:number_paginator/src/model/display_mode.dart';
import 'package:number_paginator/src/ui/number_paginator_controller.dart';
import 'package:number_paginator/src/ui/widgets/buttons/paginator_icon_button.dart';
import 'package:number_paginator/src/ui/widgets/inherited_number_paginator.dart';
import 'package:number_paginator/src/ui/widgets/paginator_content.dart';

typedef NumberPaginatorContentBuilder = Widget Function(int index);

/// The main widget used for creating a [NumberPaginator].
class NumberPaginator extends StatefulWidget {
  /// Total number of pages that should be shown.
  final int numberPages;

  /// Index of initially selected page.
  final int initialPage;

  /// This function is called when the user switches between pages. The received
  /// parameter indicates the selected index, starting from 0.
  final Function(int)? onPageChange;

  /// The UI config for the [NumberPaginator].
  final NumberPaginatorUIConfig config;

  /// A builder for the central content of the paginator. If provided, the
  /// [config] is ignored.
  final NumberPaginatorContentBuilder? contentBuilder;

  final NumberPaginatorController? controller;

  final Widget? customLeftButton;
  final Widget? customRightButton;

  /// Creates an instance of [NumberPaginator].
  const NumberPaginator({
    Key? key,
    required this.numberPages,
    this.initialPage = 0,
    this.onPageChange,
    this.config = const NumberPaginatorUIConfig(),
    this.contentBuilder,
    this.controller,
    this.customLeftButton,
    this.customRightButton,
  })  : assert(initialPage >= 0),
        assert(initialPage <= numberPages - 1),
        super(key: key);

  @override
  NumberPaginatorState createState() => NumberPaginatorState();
}

class NumberPaginatorState extends State<NumberPaginator> {
  late NumberPaginatorController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? NumberPaginatorController();
    _controller.currentPage = widget.initialPage;
    _controller.addListener(() {
      widget.onPageChange?.call(_controller.currentPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InheritedNumberPaginator(
      numberPages: widget.numberPages,
      initialPage: widget.initialPage,
      onPageChange: _controller.navigateToPage,
      config: widget.config,
      child: SizedBox(
        height: widget.config.height,
        child: Row(
          mainAxisAlignment: widget.config.mainAxisAlignment,
          children: [
            widget.customLeftButton ?? Container(
              margin: const EdgeInsets.only(
                right: 5
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.config.buttonSelectedBackgroundColor ?? Colors.red,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 3.0,
                  vertical: 2.0,
                ),
                child: Icon(
                  Icons.chevron_left,
                  color: widget.config.buttonSelectedBackgroundColor ?? Colors.red,
                  size: 35,
                ),
              ),
            ),
            ..._buildCenterContent(),
            widget.customRightButton ?? Container(
              margin: const EdgeInsets.only(
                left: 5
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.config.buttonSelectedBackgroundColor ?? Colors.red,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 3.0,
                  vertical: 2.0,
                ),
                child: Icon(
                  Icons.chevron_right,
                  color: widget.config.buttonSelectedBackgroundColor ?? Colors.red,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCenterContent() {
    return [
      if (widget.contentBuilder != null)
        Container(
          padding: widget.config.contentPadding,
          child: widget.contentBuilder!(_controller.currentPage),
        )
      else if (widget.config.mode != ContentDisplayMode.hidden)
        Expanded(
          child: Container(
            padding: widget.config.contentPadding,
            child: PaginatorContent(
              currentPage: _controller.currentPage,
            ),
          ),
        ),
    ];
  }
}
