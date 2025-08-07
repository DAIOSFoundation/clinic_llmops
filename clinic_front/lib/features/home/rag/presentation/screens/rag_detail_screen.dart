import 'package:banya_llmops/app/app_router.dart';
import 'package:banya_llmops/features/home/presentation/screens/contents_layout.dart';
import 'package:banya_llmops/features/home/rag/presentation/blocs/rag_bloc.dart';
import 'package:banya_llmops/features/home/rag/presentation/blocs/rag_event.dart';
import 'package:banya_llmops/features/home/rag/presentation/blocs/rag_state.dart';
import 'package:banya_llmops/features/home/rag/presentation/screens/rag_edit_screen.dart';
import 'package:banya_llmops/features/home/rag/presentation/widgets/info_tab_widget.dart';
import 'package:banya_llmops/shared/presentation/widget/app_dialog.dart';
import 'package:banya_llmops/shared/presentation/widget/app_loading_indicator.dart';
import 'package:banya_llmops/shared/presentation/widget/app_status_tag_widget.dart';
import 'package:banya_llmops/shared/presentation/widget/app_text_with_button_widget.dart';
import 'package:banya_llmops/shared/theme/app_colors.dart';
import 'package:banya_llmops/shared/theme/app_sizes.dart';
import 'package:banya_llmops/shared/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

const String kScreenName = 'RAG detail';

class RAGDetailScreen extends StatefulWidget {
  static const routeName = 'RAGDetailScreen';
  static const routePath = 'detail/:id';
  const RAGDetailScreen({super.key});

  @override
  State<RAGDetailScreen> createState() => _RAGDetailScreenState();
}

class _RAGDetailScreenState extends State<RAGDetailScreen>
    with RouteAware, SingleTickerProviderStateMixin {
  late String? id;
  late TabController _tabController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final GoRouterState goRouterState = GoRouterState.of(context);
      id = goRouterState.pathParameters['id'];

      if (id != null && id != '') {
        context.read<RagBloc>().add(FetchRagDetail(id!));
      } else {
        context.read<RagBloc>().add(
          const InvalidRagIdEvent('Invalid RAG ID provided.'),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContentsLayout(
      title: kScreenName,
      isBack: true,
      child: BlocConsumer<RagBloc, RagState>(
        listener: (context, state) {
          if (state is RagsLoaded) {
            // 삭제된 RAG ID를 목록 화면으로 전달
            context.pop({'deletedRagId': id});
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('RAG가 삭제되었습니다.')));
          } else if (state is RagDeleted) {
            // 삭제 완료 후 화면 닫기
            context.pop({'deletedRagId': state.deletedId});
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('RAG가 삭제되었습니다.')));
          } else if (state is RagError) {
            AppDialog.show(
              context: context,
              title: '에러',
              content: state.message,
            );
          }
        },
        builder: (context, state) {
          if (state is RagLoading) {
            return const AppLoadingIndicator();
          } else if (state is RagDetailLoaded) {
            final rag = state.rag;

            return Container(
              margin: EdgeInsets.all(3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextWithButtonWidget(
                    text: rag.name,
                    onPressedLeft:
                        () => context.pushNamed(
                          RagEditScreen.routeName,
                          pathParameters: {'id': rag.id.toString()},
                        ),
                    onPressedRight: () {
                      context.read<RagBloc>().add(DeleteRag(rag.id));
                    },
                  ),
                  AppStatusTagWidget(status: rag.status),
                  const SizedBox(height: AppSizes.appPadding),
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.blue,
                    unselectedLabelColor: AppColors.grey,
                    indicatorColor: AppColors.blue,
                    labelStyle: AppTextStyles.title(context),
                    tabAlignment: TabAlignment.start,
                    labelPadding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.appPadding,
                    ),
                    unselectedLabelStyle: AppTextStyles.label(context),
                    isScrollable: true,
                    tabs: const [
                      Tab(text: 'Information'),
                      Tab(text: 'History'),
                    ],
                  ),
                  const SizedBox(height: AppSizes.appPadding),

                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        SingleChildScrollView(child: InfoTabWidget(rag: rag)),
                        SingleChildScrollView(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
          //else if (state is RagError) {
          //   return Center(child: Text('Error: ${state.message}'));
          // }
        },
      ),
    );
  }
}
