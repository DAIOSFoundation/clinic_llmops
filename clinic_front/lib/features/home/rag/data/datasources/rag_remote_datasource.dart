import 'package:banya_llmops/data/models/file_model.dart';
import 'package:banya_llmops/data/models/upload_model.dart';
import 'package:banya_llmops/data/network/network_service.dart';
import 'package:banya_llmops/features/home/rag/data/datasources/rag_datasource.dart';
import 'package:banya_llmops/features/home/rag/data/models/rag_create_model.dart';
import 'package:banya_llmops/features/home/rag/data/models/rag_detail_model.dart';
import 'package:banya_llmops/features/home/rag/data/models/rag_edit_model.dart';
import 'package:banya_llmops/features/home/rag/data/models/rag_summary_model.dart';
import 'package:banya_llmops/shared/exceptions/api_exception.dart';
import 'package:banya_llmops/shared/exceptions/exception_handler.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class RagRemoteDataSource implements RagDataSource {
  final NetworkService networkService;
  const RagRemoteDataSource({required this.networkService});

  final String endpoint = '/api/v1/rags';

  @override
  Future<List<RagSummaryModel>> fetchRags() async {
    try {
      final resp = await networkService.get(endpoint);

      if (resp.statusCode != 200) {
        throw ApiException(
          message: 'Error fetching rag data: ${resp.statusCode}',
          statusCode: resp.statusCode,
        );
      }

      if (resp.data == null || resp.data is! Map<String, dynamic>) {
        throw ApiException(message: 'rag data is null', statusCode: 999);
      }

      final List<dynamic> data = resp.data['data'];

      return data
          .map((item) => RagSummaryModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ExceptionHandler.handleException(e, endpoint: endpoint);
    }
  }

  @override
  Future<RagDetailModel> fetchRagDetail(String id) async {
    try {
      final resp = await networkService.get('$endpoint/$id');

      if (resp.statusCode != 200) {
        throw ApiException(
          message: 'Error fetching rag data: ${resp.statusCode}',
          statusCode: resp.statusCode,
        );
      }

      final data = resp.data;
      if (data == null ||
          data['data'] == null ||
          data['data'] is! Map<String, dynamic>) {
        throw ApiException(
          message: 'Invalid response structure',
          statusCode: 998,
        );
      }
      final Map<String, dynamic> respData = data['data'];
      return RagDetailModel.fromJson(respData);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ExceptionHandler.handleException(e, endpoint: endpoint);
    }
  }

  @override
  Future<FileModel> uploadRagFile(
    UploadModel uploadModel,
    Function(double progress) onProgressUpdate,
  ) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          uploadModel.fileBytes,
          filename: uploadModel.fileName,
          contentType: MediaType('application', uploadModel.fileType),
        ),
        'fileName': uploadModel.fileName,
        'fileType': uploadModel.fileType,
      });

      final resp = await networkService.post(
        '$endpoint/file/upload',
        data: formData,
        contentType: 'multipart/form-data',
        onSendProgress: (int count, int total) {
          final progress = total > 0 ? count / total : 0.0;
          onProgressUpdate.call(progress);
        },
      );

      if (resp.statusCode != 201) {
        throw ApiException(
          message: 'Rag File upload failed: ${resp.statusCode}',
          statusCode: resp.statusCode,
        );
      }

      final data = resp.data;
      if (data == null ||
          data['data'] == null ||
          data['data'] is! Map<String, dynamic>) {
        throw ApiException(
          message: 'Invalid response structure',
          statusCode: 998,
        );
      }

      final Map<String, dynamic> respData = data['data'];

      return FileModel.fromJson(respData);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ExceptionHandler.handleException(e, endpoint: endpoint);
    }
  }

  @override
  Future<RagSummaryModel> createRag(RagCreateModel ragModel) async {
    try {
      final resp = await networkService.post(endpoint, data: ragModel.toJson());
      if (resp.statusCode != 201) {
        throw ApiException(
          message: 'Error create rag ${resp.statusCode}',
          statusCode: resp.statusCode,
        );
      }

      if (resp.data == null || resp.data is! Map<String, dynamic>) {
        throw ApiException(message: 'rag is null', statusCode: resp.statusCode);
      }

      final Map<String, dynamic> rawResp = resp.data as Map<String, dynamic>;
      final Map<String, dynamic>? data = rawResp['data'];

      if (data == null) {
        throw ApiException(
          message: 'rag data data is null',
          statusCode: resp.statusCode,
        );
      }

      return RagSummaryModel.fromJson(data);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ExceptionHandler.handleException(e, endpoint: endpoint);
    }
  }

  @override
  Future<RagSummaryModel> editRag(RagEditModel ragModel) async {
    try {
      final resp = await networkService.patch(
        '$endpoint/${ragModel.id}',
        data: ragModel.toJson(),
      );
      if (resp.statusCode != 200) {
        throw ApiException(
          message: 'Error edit rag ${resp.statusCode}',
          statusCode: resp.statusCode,
        );
      }

      if (resp.data == null || resp.data is! Map<String, dynamic>) {
        throw ApiException(message: 'rag is null', statusCode: resp.statusCode);
      }

      final Map<String, dynamic> rawResp = resp.data as Map<String, dynamic>;
      final Map<String, dynamic>? data = rawResp['data'];

      if (data == null) {
        throw ApiException(
          message: 'rag data data is null',
          statusCode: resp.statusCode,
        );
      }

      return RagSummaryModel.fromJson(data);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ExceptionHandler.handleException(e, endpoint: endpoint);
    }
  }

  @override
  Future<void> deleteRag(String id) async {
    try {
      final resp = await networkService.delete('$endpoint/$id');

      if (resp.statusCode != 200) {
        throw ApiException(
          message: 'Error delete rag data: ${resp.statusCode}',
          statusCode: resp.statusCode,
        );
      }

      return;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ExceptionHandler.handleException(e, endpoint: endpoint);
    }
  }
}
