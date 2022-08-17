import 'dart:convert';
import '../models/puppy.dart';
import 'package:http/http.dart' as http;

class PuppyServiceData {

  createPuppy({Puppy? puppy}) async {
    final http.Response response = await http.post(
      Uri.parse('http://localhost:8080/api/puppy'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(puppy),
    );
    return response;
  }

  fetchPuppies() async {
    String url = "http://localhost:8080/api/puppy";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var results = jsonDecode(response.body);
      return createPuppyList(results).toList();
    } else {
      throw Exception('Unable to fetch puppies from the REST API');
    }
  }

  deletePuppy(Puppy puppy) async {
    var id = puppy.id;
    final http.Response response = await http.delete(
      Uri.parse('http://localhost:8080/api/puppy/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }

  updatePuppy(int id) async {
    final http.Response response = await http.put(
      Uri.parse('http://localhost:8080/api/puppy/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }

  List<Puppy> createPuppyList(List data) {
    List<Puppy> list = [];
    for (int i = 0; i < data.length; i++) {
      Puppy puppy = new Puppy.fromJson(data[i]);
      list.add(puppy);
    }
    return list;
  }
}
