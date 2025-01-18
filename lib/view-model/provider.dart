import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// ViewModel for managing the home screen's data and logic.
class HomeViewModel extends ChangeNotifier {
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  final String rootFolderId = dotenv.env['ROOT_FOLDER_ID'] ?? '';
  String currentFolderId = '';
  String currentFolderName = 'Root Folder';
  List<dynamic> folderContents = [];
  bool isLoading = false;
  String? errorMessage;

  HomeViewModel() {
    currentFolderId = rootFolderId;
    fetchFolderContents(currentFolderId);
  }

  /// Fetches the contents of a given folder from Google Drive.
  Future<void> fetchFolderContents(String folderId) async {
    _setLoadingState(true);

    final String url =
        "https://www.googleapis.com/drive/v3/files?q='$folderId'+in+parents+and+trashed=false&key=$apiKey&fields=files(id,name,mimeType)";

    try {
      final response = await _makeApiCall(url);
      if (response != null && response.statusCode == 200) {
        _processFolderData(response.body);
      } else {
        _handleError(
            'Something went wrong while fetching the data. Please try again later.');
      }
    } catch (e) {
      _handleError(
          'An error occurred. Please check your internet connection or try again later.');
    }
  }

  /// Refresh the data by calling the `fetchFolderContents` again.
  Future<void> refreshData() async {
    _setLoadingState(true);
    await fetchFolderContents(currentFolderId);
  }

  Future<http.Response?> _makeApiCall(String url) async {
    try {
      return await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 20));
    } on TimeoutException {
      _handleError('The request timed out. Please try again later.');
    } on SocketException {
      _handleError(
          'No internet connection. Please check your network settings.');
    } catch (_) {
      _handleError('An unexpected error occurred. Please try again later.');
    }
    return null;
  }

  void _processFolderData(String responseBody) {
    final Map<String, dynamic> data = json.decode(responseBody);
    folderContents = data['files'] ?? [];

    // Sort folder contents by name (case-insensitive)
    folderContents.sort((a, b) => (a['name']?.toLowerCase() ?? '')
        .compareTo(b['name']?.toLowerCase() ?? ''));
    _setLoadingState(false);
  }

  void _setLoadingState(bool state) {
    isLoading = state;
    notifyListeners();
  }

  void _handleError(String message) {
    errorMessage = message;
    _setLoadingState(false);
    notifyListeners();
  }
}

class ResultScreenProvider extends ChangeNotifier {
  String currentFolderId = dotenv.env['ROOT_FOLDER_ID'] ?? '';
  String currentFolderName = 'Root Folder';
  List<dynamic> folderContents = [];
  bool isLoading = false;
  String? errorMessage;
  final List<Map<String, String>> navigationStack = [];

  /// Initialize the provider with folder ID and name.
  void initialize(String folderId, String folderName) {
    currentFolderId = folderId;
    currentFolderName = folderName;
    fetchFolderContents(folderId);
  }

  /// Fetches folder contents from Google Drive API.
  Future<void> fetchFolderContents(String folderId) async {
    _setLoadingState(true);
    errorMessage = null;

    final String apiKey = dotenv.env['API_KEY'] ?? '';
    final String url =
        "https://www.googleapis.com/drive/v3/files?q='$folderId'+in+parents+and+trashed=false&key=$apiKey&fields=files(id,name,mimeType)";

    try {
      final response = await _makeApiCall(url);
      if (response != null && response.statusCode == 200) {
        _processFolderData(response.body);
      } else {
        _handleError(
            'Something went wrong while fetching the data. Please try again later.');
      }
    } catch (e) {
      _handleError(
          'An error occurred. Please check your internet connection or try again later.');
    }
  }

  Future<http.Response?> _makeApiCall(String url) async {
    try {
      return await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 20));
    } on TimeoutException {
      _handleError('The request timed out. Please try again later.');
    } on SocketException {
      _handleError(
          'No internet connection. Please check your network settings.');
    } catch (_) {
      _handleError('An unexpected error occurred. Please try again later.');
    }
    return null;
  }

  void _processFolderData(String responseBody) {
    final Map<String, dynamic> data = json.decode(responseBody);
    folderContents = data['files'] ?? [];

    // Sort folder contents by name (case-insensitive)
    folderContents.sort((a, b) => (a['name']?.toLowerCase() ?? '')
        .compareTo(b['name']?.toLowerCase() ?? ''));
    _setLoadingState(false);
  }

  void _setLoadingState(bool state) {
    isLoading = state;
    notifyListeners();
  }

  void _handleError(String message) {
    errorMessage = message;
    _setLoadingState(false);
    notifyListeners();
  }

  /// Navigate to a subfolder.
  void navigateToFolder(String folderId, String folderName) {
    navigationStack.add({'id': currentFolderId, 'name': currentFolderName});
    currentFolderId = folderId;
    currentFolderName = folderName;
    fetchFolderContents(folderId);
  }

  /// Navigate back to the previous folder.
  void navigateBack() {
    if (navigationStack.isNotEmpty) {
      final previousFolder = navigationStack.removeLast();
      currentFolderId = previousFolder['id']!;
      currentFolderName = previousFolder['name']!;
      fetchFolderContents(currentFolderId);
    }
  }

  int _activeDownloads = 0;
  bool isDownloading = true;
  int get activeDownloads => _activeDownloads;

  void incrementDownload() {
    _activeDownloads++;
    isDownloading = false;
    notifyListeners();
  }

  void decrementDownload() {
    if (_activeDownloads > 0) {
      _activeDownloads--;
      isDownloading = true;
      notifyListeners();
    }
  }
}
