import 'package:banya_llmops/app/app_env.dart';
import 'package:banya_llmops/features/home/rag/domain/entities/rag_detail_entity.dart';
import 'package:banya_llmops/features/home/rag/presentation/widgets/file_card_widget.dart';
import 'package:banya_llmops/shared/presentation/widget/app_box_container.dart';
import 'package:banya_llmops/shared/presentation/widget/app_title_contents_text.dart';
import 'package:banya_llmops/shared/theme/app_colors.dart';
import 'package:banya_llmops/shared/theme/app_sizes.dart';
import 'package:banya_llmops/shared/theme/app_text_styles.dart';
import 'package:banya_llmops/shared/theme/app_ui_styles.dart';
import 'package:flutter/material.dart';

class InfoTabWidget extends StatelessWidget {
  final RagDetailEntity rag;
  const InfoTabWidget({super.key, required this.rag});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBoxContainer(
          title: "RAG Information",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTitleContentsText(
                title: 'Description',
                contents: rag.description,
              ),
              SizedBox(height: AppSizes.appPadding / 2),
              AppTitleContentsText(
                title: 'API',
                contents: '${AppEnv.baseURL}/api/rags/retriever/${rag.id}',
              ),
              SizedBox(height: AppSizes.appPadding / 2),

              AppTitleContentsText(
                title: 'VectorStore',
                contents: rag.vectorStore,
              ),
              SizedBox(height: AppSizes.appPadding / 2),
              Text("Training Progress", style: AppTextStyles.title(context)),
              SizedBox(height: 4.0),
              Container(
                padding: EdgeInsets.all(AppSizes.spacing / 2),
                decoration: AppUIStyles.roundBoxDecoration,
                child: Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: 100,
                        backgroundColor: AppColors.grey,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.accentBlue,
                        ),
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('100%', style: AppTextStyles.label(context)),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "created : ${rag.createdAt}",
                style: AppTextStyles.label(context),
              ),
              Text(
                "updated : ${rag.updatedAt}",
                style: AppTextStyles.label(context),
              ),
              SizedBox(height: AppSizes.appPadding / 2),
            ],
          ),
        ),
        SizedBox(height: AppSizes.appPadding),
        AppBoxContainer(
          title: "Uploaded",
          child: ListView.builder(
            shrinkWrap: true,

            itemCount: rag.files?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: FileCardWidget(name: rag.files![index].name),
              );
            },
          ),
        ),
      ],
    );
  }
}
