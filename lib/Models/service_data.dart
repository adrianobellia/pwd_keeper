class ServiceData {
  final String serviceName;
  final String username;
  final String password;
  ServiceData({required this.serviceName,required this.username, required this.password});
  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      serviceName: json['serviceName'],
      username: json['username'],
      password: json['password'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'serviceName': serviceName,
      'username': username,
      'password': password,
    };
  }
}