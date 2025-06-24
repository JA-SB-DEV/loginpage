class User {
  String? token;
  String? id;
  String? name;
  String? email;
  //String? phone;
  String? city;
  String? idrole;

  User({this.id, this.name, this.email, this.token, this.city, this.idrole});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    token = json['token'];
    city = json['city'];
    idrole = json['idrole'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['token'] = token;
    data['city'] = city;
    data['idrole'] = idrole;
    return data;
  }
}

final User currentUser = User(
  id: '1',
  name: 'Daniel Peralta',
  email: 'admin@heris.com',
  token: '1234', //hasheado obviamente
  city: 'Valledupar', // se le pasaria un id
  idrole: '3',
);
