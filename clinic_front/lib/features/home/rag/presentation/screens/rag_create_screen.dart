import 'package:banya_llmops/features/home/presentation/screens/contents_layout.dart';
import 'package:banya_llmops/features/home/rag/presentation/blocs/rag_bloc.dart';
import 'package:banya_llmops/features/home/rag/presentation/blocs/rag_event.dart';
import 'package:banya_llmops/features/home/rag/presentation/blocs/rag_state.dart';
import 'package:banya_llmops/features/home/rag/presentation/widgets/file_upload_widget.dart';
import 'package:banya_llmops/shared/presentation/widget/app_default_button.dart';
import 'package:banya_llmops/shared/presentation/widget/app_default_inputfield.dart';
import 'package:banya_llmops/shared/presentation/widget/app_dialog.dart';
import 'package:banya_llmops/shared/presentation/widget/app_file_drop.dart';
import 'package:banya_llmops/shared/theme/app_sizes.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

const String kScreenName = 'Create a RAG';

class RagCreateScreen extends StatefulWidget {
  static const routeName = 'RagCreateScreen';
  static const routePath = 'create';

  const RagCreateScreen({super.key});

  @override
  State<RagCreateScreen> createState() => _RagCreateScreenState();
}

class _RagCreateScreenState extends State<RagCreateScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isCreateButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    context.read<RagBloc>().add(ResetRagState());
    _nameController.addListener(_updateCreateButtonState);
    _descriptionController.addListener(_updateCreateButtonState);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateCreateButtonState);
    _descriptionController.removeListener(_updateCreateButtonState);
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateCreateButtonState() {
    final blocState = context.read<RagBloc>().state;
    final filesUploaded = blocState.uploadedFiles.isNotEmpty;

    setState(() {
      _isCreateButtonEnabled =
          _nameController.text.isNotEmpty &&
          _descriptionController.text.isNotEmpty &&
          filesUploaded;
    });
  }

  void _handleFilesDropped(List<XFile> files) async {
    if (files.isEmpty) return;

    for (final xFile in files) {
      try {
        final bytes = await xFile.readAsBytes();
        final fileName = xFile.name;
        final fileExtension = fileName.split('.').last.toLowerCase();

        if (mounted) {
          context.read<RagBloc>().add(
            UploadRagFile(
              fileName: fileName,
              fileBytes: bytes,
              fileType: fileExtension,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('파일 ${xFile.name} 처리 중 오류: $e')),
          );
        }
      }
    }
  }

  void _removeFile(String fileId) {
    context.read<RagBloc>().add(RemoveUploadedFile(fileId));
  }

  void _handleCreateButtonPressed() {
    final blocState = context.read<RagBloc>().state;
    final fileIds = blocState.uploadedFiles.map((file) => file.id).toList();

    context.read<RagBloc>().add(
      CreateRag(
        name: _nameController.text,
        description: _descriptionController.text,
        ragFileIds: fileIds,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RagBloc, RagState>(
      listener: (context, state) {
        _updateCreateButtonState();

        if (state is RagCreated) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('RAG 생성이 완료되었습니다.')));
          _nameController.clear();
          _descriptionController.clear();
          context.pop(true);
          context.read<RagBloc>().add(ResetRagState());
        } else if (state is RagError) {
          AppDialog.show(context: context, title: '에러', content: state.message);
        }
      },
      builder: (context, state) {
        List<Map<String, dynamic>> filesToDisplay = [];

        filesToDisplay.addAll(
          state.uploadedFiles.map(
            (file) => {
              'id': file.id,
              'name': file.name,
              'progress': 1.0,
              'isUploaded': true,
            },
          ),
        );

        if (state is RagUploadedFiles &&
            state.uploadStatus == RagUploadStatus.uploading &&
            state.uploadingFileName != null) {
          filesToDisplay.add({
            'name': state.uploadingFileName!,
            'progress': state.uploadProgress,
            'isUploaded': false,
          });
        }

        return Stack(
          children: [
            ContentsLayout(
              title: kScreenName,
              isBack: true,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(3.0),
                  child: Column(
                    children: [
                      AppDefaultInputField(
                        labelText: 'RAG name',
                        hintText: 'RAG name',
                        controller: _nameController,
                      ),
                      AppDefaultInputField(
                        labelText: 'Description',
                        hintText: 'Description',
                        maxLines: 3,
                        controller: _descriptionController,
                      ),
                      AppFileDropTarget(
                        label: 'Upload Documents',
                        onFilesDropped: _handleFilesDropped,
                        height: 110,
                      ),
                      SizedBox(height: AppSizes.appPadding),
                      FileUploadWidget(
                        title: 'Uploaded',
                        uploadedFiles: filesToDisplay,
                        onRemoveFile: (fileData) {
                          final fileId = fileData['id'];
                          if (fileId != null) {
                            _removeFile(fileId);
                          }
                        },
                      ),
                      SizedBox(height: AppSizes.appPadding),
                      Align(
                        alignment: Alignment.centerRight,
                        child: AppDefaultButton(
                          isDisable: !_isCreateButtonEnabled,
                          onPressed: _handleCreateButtonPressed,
                          title: 'Create',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (state is RagLoading)
              Positioned.fill(
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
