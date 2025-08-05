import 'package:banya_llmops/shared/presentation/widget/app_status_tag_widget.dart';
import 'package:banya_llmops/shared/presentation/widget/app_responsive_widget.dart';
import 'package:banya_llmops/shared/theme/app_sizes.dart';
import 'package:banya_llmops/shared/theme/app_text_styles.dart';
import 'package:banya_llmops/shared/theme/app_ui_styles.dart';
import 'package:flutter/material.dart';

class AppStatusCardWidget
    extends
        StatelessWidget {
  final String? status;
  final String title;
  final String description;
  final DateTime date;

  final VoidCallback onPressed;
  // final Color? statusColor;
  // final Color? fontColor;

  const AppStatusCardWidget({
    super.key,
    // this.statusColor,
    // this.fontColor,
    this.status,
    required this.title,
    required this.description,
    required this.date,
    required this.onPressed,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final bool isTablet = AppResponsiveWidget.isTablet(
      context,
    );
    final bool isMobile = AppResponsiveWidget.isMobile(
      context,
    );

    // 반응형 높이 설정
    double cardHeight =
        200.0;
    if (isTablet) {
      cardHeight =
          250.0;
    } else if (isMobile) {
      cardHeight =
          300.0;
    }

    return Container(
      margin: EdgeInsets.all(
        AppSizes.shadowMargin,
      ),
      height:
          cardHeight,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          8.0,
          0.0,
          8.0,
          AppSizes.appPadding,
        ),
        child: MouseRegion(
          cursor:
              SystemMouseCursors.click,
          child: GestureDetector(
            onTap:
                onPressed,
            behavior:
                HitTestBehavior.translucent,
            child: Container(
              decoration:
                  AppUIStyles.shadowBoxDecoration,
              padding: const EdgeInsets.all(
                16.0,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  if (status !=
                      null)
                    AppStatusTagWidget(
                      status:
                          status!,
                    ),
                  SizedBox(
                    height:
                        5.0,
                  ),
                  Text(
                    title,
                    style: AppTextStyles.title(
                      context,
                    ),
                    softWrap:
                        true,
                    maxLines:
                        isTablet
                            ? 4
                            : 3, // 태블릿과 모바일에서 더 많은 줄
                    overflow:
                        TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height:
                        3.0,
                  ),

                  Expanded(
                    child: LayoutBuilder(
                      builder: (
                        context,
                        constraints,
                      ) {
                        final double availableHeight =
                            constraints.maxHeight;
                        final double fontSize =
                            AppTextStyles.label(
                              context,
                            ).fontSize ??
                            13.0;
                        final double lineHeight =
                            fontSize *
                            1.5;

                        // 반응형 최대 줄 수 설정
                        int maxLines = (availableHeight /
                                lineHeight)
                            .floor()
                            .clamp(
                              1,
                              100,
                            );
                        maxLines = maxLines.clamp(
                          1,
                          10,
                        );

                        return Text(
                          description,
                          style: AppTextStyles.label(
                            context,
                          ),
                          maxLines:
                              maxLines,
                          overflow:
                              TextOverflow.ellipsis,
                          softWrap:
                              true,
                        );
                      },
                    ),
                  ),

                  SizedBox(
                    height:
                        8.0,
                  ),
                  Text(
                    "${date.toString().split(' ')[0]} Updated",
                    style: AppTextStyles.labelSm(
                      context,
                    ).copyWith(
                      color:
                          Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
