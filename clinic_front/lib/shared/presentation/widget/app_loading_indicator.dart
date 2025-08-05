import 'package:banya_llmops/shared/utils/extenstions/ui_extenstion.dart';
import 'package:flutter/material.dart';

class AppLoadingIndicator
    extends
        StatelessWidget {
  const AppLoadingIndicator({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      height:
          context.screenSize.height *
          0.7,
      alignment:
          Alignment.center,
      child: const Center(
        child:
            CircularProgressIndicator(),
      ),
    );
  }
}
