class Resource {
  final String title;
  final String resourceType;
  final String downloadUrl;

  Resource({
    required this.title,
    required this.resourceType,
    required this.downloadUrl,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      title: json['title'] as String,
      resourceType: json['resource_type'] as String,
      downloadUrl: json['download_url'] as String,
    );
  }
}
