import 'package:banya_llmops/data/models/file_model.dart';
import 'package:banya_llmops/data/models/upload_model.dart';
import 'package:banya_llmops/features/home/rag/data/models/rag_create_model.dart';
import 'package:banya_llmops/features/home/rag/data/models/rag_detail_model.dart';
import 'package:banya_llmops/features/home/rag/data/models/rag_edit_model.dart';
import 'package:banya_llmops/features/home/rag/data/models/rag_summary_model.dart';

abstract class RagDataSource {
  Future<List<RagSummaryModel>> fetchRags();
  Future<RagDetailModel> fetchRagDetail(String id);
  Future<RagSummaryModel> createRag(RagCreateModel ragModel);
  Future<FileModel> uploadRagFile(
    UploadModel uploadModel,
    Function(double progress) onProgressUpdate,
  );
  Future<RagSummaryModel> editRag(RagEditModel ragModel);
  Future<void> deleteRag(String id);
}
