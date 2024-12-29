import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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

        // Sort folder contents by name (case-insensitive)
        folderContents.sort((a, b) {
          String nameA = (a['name'] ?? '').toLowerCase();
          String nameB = (b['name'] ?? '').toLowerCase();
          return nameA.compareTo(nameB);
        });
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

class ResultScreenProvider extends ChangeNotifier {
  String currentFolderId = dotenv.env['ROOT_FOLDER_ID'] ?? '';
  String currentFolderName = "Root Folder";
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
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final String apiKey = dotenv.env['API_KEY'] ?? '';
    final String url =
        "https://www.googleapis.com/drive/v3/files?q='$folderId'+in+parents+and+trashed=false&key=$apiKey&fields=files(id,name,mimeType)";
    debugPrint("Fetching folder contents for Folder ID: $folderId");

    try {
      final response =
      await http.get(Uri.parse(url)).timeout(const Duration(seconds: 20));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        folderContents = (data['files'] ?? [])
          ..sort((a, b) {
            // Ensure both names are not null and convert to lowercase before comparing
            String nameA = (a['name'] ?? '').toLowerCase();
            String nameB = (b['name'] ?? '').toLowerCase();
            return nameA.compareTo(nameB);
          });
        isLoading = false;
        debugPrint("Successfully fetched ${folderContents.length} items.");
      } else {
        errorMessage = "Server Error: ${response.statusCode}";
        debugPrint(errorMessage!);
        isLoading = false;
      }
    } on TimeoutException {
      errorMessage = "Request timed out. Please try again.";
      debugPrint(errorMessage!);
      isLoading = false;
    } on SocketException {
      errorMessage = "No internet connection. Please check your network.";
      debugPrint(errorMessage!);
      isLoading = false;
    } catch (e) {
      errorMessage = "An unexpected error occurred: $e";
      debugPrint(errorMessage!);
      isLoading = false;
    }
    notifyListeners();
  }

  /// Navigate to a subfolder.
  void navigateToFolder(String folderId, String folderName) {
    navigationStack.add({
      "id": currentFolderId,
      "name": currentFolderName,
    });
    currentFolderId = folderId;
    currentFolderName = folderName;
    debugPrint("Navigating to folder: $folderName (ID: $folderId)");
    fetchFolderContents(folderId);
  }

  /// Navigate back to the previous folder.
  void navigateBack() {
    if (navigationStack.isNotEmpty) {
      final previousFolder = navigationStack.removeLast();
      currentFolderId = previousFolder["id"]!;
      currentFolderName = previousFolder["name"]!;
      debugPrint("Navigating back to folder: $currentFolderName (ID: $currentFolderId)");
      fetchFolderContents(currentFolderId);
    } else {
      debugPrint("No previous folder to navigate back to.");
    }
  }
}

