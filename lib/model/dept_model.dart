class Department {
  final String name;
  final String icon;

  Department({required this.name, required this.icon});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      name: json['name'] as String,
      icon: json['icon'] as String,
    );
  }
}
