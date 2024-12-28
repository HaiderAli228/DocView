import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// ViewModel for managing the home screen's data and logic.
///
/// This class is responsible for fetching folder contents from Google Drive
/// and managing the loading state and error messages during the request process.
class HomeViewModel extends ChangeNotifier {
  final String apiKey =
      dotenv.env['API_KEY'] ?? ''; // The API key to authenticate requests
  final String rootFolderId = dotenv.env['ROOT_FOLDER_ID'] ??
      ''; // Root folder ID from environment variables
  String currentFolderId = ''; // Current folder ID being viewed
  String currentFolderName = 'Root Folder'; // Name of the current folder
  List<dynamic> folderContents =
      []; // List to store the contents of the current folder
  bool isLoading = false; // Flag to indicate whether data is being loaded
  String? errorMessage; // Error message in case of failure

  /// Constructor to initialize the ViewModel and start fetching the root folder contents.
  HomeViewModel() {
    currentFolderId = rootFolderId;
    fetchFolderContents(
        currentFolderId); // Fetch contents for the root folder initially
  }

  /// Fetches the contents of a given folder from Google Drive.
  ///
  /// This method sends a GET request to the Google Drive API, requesting the
  /// list of files/folders within the specified folder. It updates the state
  /// based on the response, including handling any errors that occur.
  ///
  /// [folderId] The ID of the folder whose contents are to be fetched.
  Future<void> fetchFolderContents(String folderId) async {
    _setLoadingState(true);

    final String url =
        "https://www.googleapis.com/drive/v3/files?q='$folderId'+in+parents+and+trashed=false&key=$apiKey&fields=files(id,name,mimeType)";

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 20)); // Timeout set for 20 seconds

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        folderContents = data['files'] ?? []; // Update the folder contents
      } else {
        _handleError('Error: ${response.statusCode} - ${response.body}');
      }
    } on TimeoutException catch (_) {
      _handleError('Request timed out. Please try again.');
    } on SocketException catch (_) {
      _handleError('No internet connection. Please check your network.');
    } on FormatException catch (_) {
      _handleError('Error parsing response. Please try again later.');
    } catch (e) {
      _handleError('An unexpected error occurred: $e');
    } finally {
      _setLoadingState(false);
    }
  }

  // Helper function to handle setting loading state
  void _setLoadingState(bool state) {
    isLoading = state;
    notifyListeners();
  }

  // Helper function to handle errors
  void _handleError(String message) {
    errorMessage = message;
    notifyListeners();
  }
}

class FolderProvider with ChangeNotifier {
  List<dynamic> _folderContents = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<dynamic> get folderContents => _folderContents;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Fetches the contents of a given folder from Google Drive.
  ///
  /// [folderId] The ID of the folder whose contents are to be fetched.
  Future<void> fetchFolderContents(String folderId) async {
    _setLoadingState(true);
    _errorMessage = null;

    final String apiKey = dotenv.env['API_KEY'] ?? '';
    final String url =
        "https://www.googleapis.com/drive/v3/files?q='$folderId'+in+parents+and+trashed=false&key=$apiKey&fields=files(id,name,mimeType,webContentLink)";

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10)); // Timeout after 10 seconds

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> files = data['files'] ?? [];

        files.sort((a, b) =>
            a['name']
                ?.toLowerCase()
                ?.compareTo(b['name']?.toLowerCase() ?? '') ??
            0);

        _folderContents = files;
      } else {
        _handleError('Server Error: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      _handleError('Request timed out. Please try again.');
    } on SocketException catch (_) {
      _handleError('No internet connection. Please check your network.');
    } on FormatException catch (_) {
      _handleError('Error parsing response. Please try again later.');
    } catch (e) {
      _handleError('An unexpected error occurred: $e');
    } finally {
      _setLoadingState(false);
    }
  }

  // Helper function to handle setting loading state
  void _setLoadingState(bool state) {
    _isLoading = state;
    notifyListeners();
  }

  // Helper function to handle errors
  void _handleError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}
