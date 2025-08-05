import 'package:banya_llmops/shared/constants/app_assets.dart';
import 'package:banya_llmops/shared/theme/app_sizes.dart';
import 'package:banya_llmops/shared/theme/app_text_styles.dart';
import 'package:banya_llmops/shared/theme/app_ui_styles.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';

class AppFileDropTarget extends StatefulWidget {
  final ValueChanged<List<XFile>> onFilesDropped; // DropItem 대신 XFile 사용
  final String label;
  final double? width;
  final double? height;
  final String? text;

  const AppFileDropTarget({
    super.key,
    required this.label,
    required this.onFilesDropped,
    this.width,
    this.height,
    this.text,
  });

  @override
  State<AppFileDropTarget> createState() => _AppFileDropTargetState();
}

class _AppFileDropTargetState extends State<AppFileDropTarget> {
  bool _isDragging = false;

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any, // 모든 파일 타입 허용, 필요에 따라 image, video 등으로 제한 가능
      withData: true, // 웹에서는 필수: 파일의 바이트 데이터를 얻기 위해 true로 설정
    );

    if (result != null) {
      // 선택된 PlatformFile 객체들을 XFile 객체 리스트로 변환합니다.
      final files =
          result.files.map((platformFile) {
            // 웹 환경에서는 platformFile.bytes가 null이 아님을 보장합니다.
            // 데스크탑/모바일에서는 platformFile.path가 null이 아닐 수 있습니다.
            // XFile은 bytes 또는 path 중 하나를 가질 수 있습니다.
            if (platformFile.bytes != null) {
              return XFile.fromData(
                platformFile.bytes!,
                name: platformFile.name,
                mimeType:
                    platformFile.extension != null
                        ? 'application/${platformFile.extension}'
                        : null, // 적절한 MIME 타입 설정
                // size: platformFile.size, // XFile.fromData는 size를 직접 받지 않음
              );
            } else if (platformFile.path != null) {
              // 데스크탑/모바일 환경을 위한 폴백 (웹에서는 이 경로로 오지 않음)
              return XFile(platformFile.path!);
            } else {
              throw Exception(
                'File data or path is null for ${platformFile.name}',
              );
            }
          }).toList();

      widget.onFilesDropped(files);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(AppAssets.ICON_UPLOAD, width: 24, height: 24),
        const SizedBox(height: 8.0),
        Text(
          widget.text ??
              'Drag and drop file here or click to browse from your computer.\nMaximum file size : 1 GB',
          style: AppTextStyles.label(context),
          textAlign: TextAlign.center,
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.title(context),
        ), // AppTextStyles 정의 필요
        const SizedBox(height: 8.0),
        DropTarget(
          onDragDone: (details) {
            // desktop_drop의 details.files는 이미 XFile 리스트입니다.
            widget.onFilesDropped(details.files);
            setState(() {
              _isDragging = false;
            });
          },
          onDragEntered: (details) {
            setState(() {
              _isDragging = true;
            });
          },
          onDragExited: (details) {
            setState(() {
              _isDragging = false;
            });
          },
          child: GestureDetector(
            onTap: _pickFiles,
            child: Container(
              width: widget.width ?? double.infinity,
              height: widget.height ?? 200,
              decoration:
                  _isDragging
                      ? AppUIStyles.shadowBoxDecoration.copyWith(
                        // AppUIStyles 정의 필요
                        color: Colors.blue.withValues(alpha: 0.1),
                        border: Border.all(color: Colors.blueAccent, width: 2),
                      )
                      : AppUIStyles.shadowBoxDecoration,
              child: Center(child: defaultContent),
            ),
          ),
        ),
      ],
    );
  }
}
