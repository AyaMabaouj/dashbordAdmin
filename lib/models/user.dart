class User {
  final String id;
  final String name;
  final String email;
 final String? password;
  final String address;
  final String number;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
     required  this.password,
    this.address = '',
    this.number = '',
    this.role = 'Client',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
        password: json['password'],
      address: json['address'] ?? '',
      number: json['number'] ?? '',
      role: json['role'] ?? 'Client',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
     'password': password,
      'address': address,
      'number': number,
      'role': role,
    };
  }
}
