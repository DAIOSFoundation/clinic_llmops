import 'package:banya_llmops/shared/theme/app_colors.dart';
import 'package:banya_llmops/shared/theme/app_sizes.dart';
import 'package:banya_llmops/shared/theme/app_text_styles.dart';
import 'package:banya_llmops/shared/theme/app_ui_styles.dart';
import 'package:flutter/material.dart';

class FileUploadWidget extends StatelessWidget {
  final String? title;
  final List<Map<String, dynamic>> uploadedFiles;
  final Function(Map<String, dynamic>)? onRemoveFile;

  const FileUploadWidget({
    super.key,
    this.title,
    required this.uploadedFiles,
    this.onRemoveFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) Text(title!, style: AppTextStyles.title(context)),
        const SizedBox(height: 8.0),
        Container(
          decoration: AppUIStyles.shadowBoxDecoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (uploadedFiles.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'No files uploaded yet.',
                      style: AppTextStyles.label(context),
                    ),
                  ),
                ),
              if (uploadedFiles.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: uploadedFiles.length,
                  itemBuilder: (context, index) {
                    final file = uploadedFiles[index];
                    final String fileName = file['name'] ?? "Unknown";

                    final double progress = file['progress'] ?? 0.0;
                    final bool isUploaded = file['isUploaded'] ?? false;
                    final bool showProgressBar = file['isUploaded'];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    AppUIStyles.getFileIcon(fileName),
                                    width: AppSizes.sidebarIconSize,
                                    height: AppSizes.sidebarIconSize,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          fileName,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: AppColors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (showProgressBar) ...[
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: LinearProgressIndicator(
                                                  value: progress,
                                                  backgroundColor: AppColors
                                                      .grey
                                                      .withValues(alpha: 0.3),
                                                  valueColor:
                                                      const AlwaysStoppedAnimation<
                                                        Color
                                                      >(AppColors.accentBlue),
                                                  minHeight: 6,
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${(progress * 100).toInt()}%',
                                                style: AppTextStyles.label(
                                                  context,
                                                ).copyWith(
                                                  color: AppColors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.grey[600],
                                      size: 20,
                                    ),
                                    onPressed:
                                        isUploaded
                                            ? () {
                                              onRemoveFile?.call(file);
                                            }
                                            : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}
