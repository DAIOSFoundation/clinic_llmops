import 'package:banya_llmops/app/app_env.dart';
import 'package:banya_llmops/features/home/presentation/screens/contents_layout.dart';
import 'package:banya_llmops/features/home/rag/presentation/blocs/rag_bloc.dart';
import 'package:banya_llmops/features/home/rag/presentation/blocs/rag_event.dart';
import 'package:banya_llmops/features/home/rag/presentation/blocs/rag_state.dart';
import 'package:banya_llmops/features/home/rag/presentation/screens/rag_create_screen.dart';
import 'package:banya_llmops/features/home/rag/presentation/screens/rag_detail_screen.dart';
import 'package:banya_llmops/shared/presentation/widget/app_loading_indicator.dart';
import 'package:banya_llmops/shared/presentation/widget/app_responsive_widget.dart';
import 'package:banya_llmops/shared/presentation/widget/app_status_card_widget.dart';
import 'package:banya_llmops/shared/theme/app_ui_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final String kScreenName = 'RAG-Tuning';

class RagScreen extends StatefulWidget {
  static const routeName = 'RagScreen';
  static const routePath = '/';

  const RagScreen({super.key});

  @override
  State<RagScreen> createState() => _RagState();
}

class _RagState extends State<RagScreen> with RouteAware {
  @override
  void didPopNext() {
    // 화면으로 돌아올 때마다 목록 새로고침
    context.read<RagBloc>().add(FetchRags());
  }

  @override
  void initState() {
    super.initState();
    context.read<RagBloc>().add(FetchRags());
  }

  @override
  Widget build(BuildContext context) {
    return ContentsLayout(
      title: kScreenName,
      buttonText: 'Create',

      onPressed: () async {
        final result = await context.pushNamed(RagCreateScreen.routeName);

        if (result == true) {
          if (context.mounted) {
            context.read<RagBloc>().add(FetchRags());
          }
        }
      },
      child: BlocBuilder<RagBloc, RagState>(
        builder: (context, state) {
          if (state is RagLoading) {
            return AppLoadingIndicator();
          } else if (state is RagsLoaded) {
            final rags = state.rags;

            return SizedBox(
              width: double.infinity,
              child: AppResponsiveWidget(
                mobile: ListView.builder(
                  itemCount: rags?.length ?? 0,
                  itemBuilder: (context, index) {
                    final rag = rags![index];
                    return AppStatusCardWidget(
                      status: rag.status,
                      title: rag.name,
                      description: rag.description,
                      date: rag.createdAt,
                      apiUrl: '${AppEnv.baseURL}/api/v1/rags/retriever/${rag.id}',
                      onPressed:
                          () => context.pushNamed(
                            RAGDetailScreen.routeName,
                            pathParameters: {'id': rag.id.toString()},
                          ),
                    );
                  },
                ),
                tablet: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 430,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: AppUIStyles.getAspectRatio(context),
                  ),
                  itemCount: rags?.length ?? 0,
                  itemBuilder: (context, index) {
                    final rag = rags![index];
                    return AppStatusCardWidget(
                      status: rag.status,
                      title: rag.name,
                      description: rag.description,
                      date: rag.createdAt,
                      apiUrl: '${AppEnv.baseURL}/api/v1/rags/retriever/${rag.id}',
                      onPressed:
                          () => context.pushNamed(
                            RAGDetailScreen.routeName,
                            pathParameters: {'id': rag.id.toString()},
                          ),
                    );
                  },
                ),
                desktop: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 430,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: AppUIStyles.getAspectRatio(context),
                  ),
                  itemCount: rags?.length ?? 0,
                  itemBuilder: (context, index) {
                    final rag = rags![index];
                    return AppStatusCardWidget(
                      status: rag.status,
                      title: rag.name,
                      description: rag.description,
                      date: rag.createdAt,
                      apiUrl: '${AppEnv.baseURL}/api/v1/rags/retriever/${rag.id}',
                      onPressed:
                          () => context.pushNamed(
                            RAGDetailScreen.routeName,
                            pathParameters: {'id': rag.id.toString()},
                          ),
                    );
                  },
                ),
              ),
            );
          } else if (state is RagError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
