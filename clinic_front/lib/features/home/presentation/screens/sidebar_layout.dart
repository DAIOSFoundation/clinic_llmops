import 'package:banya_llmops/shared/presentation/widget/app_default_layout.dart';
import 'package:flutter/material.dart';

class SideBarLayout
    extends
        StatefulWidget {
  final Widget child;

  const SideBarLayout({
    required this.child,
    super.key,
  });

  @override
  State<
    SideBarLayout
  >
  createState() =>
      _SideBarLayoutState();
}

class _SideBarLayoutState
    extends
        State<
          SideBarLayout
        > {
  @override
  Widget build(
    BuildContext context,
  ) {
    return AppDefaultLayout(
      child:
          widget.child,
    );
  }
}
