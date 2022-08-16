import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:waiting_list/models/puppy.dart';
import 'package:http/http.dart' as http;

class PuppyController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  var puppyList = <Puppy>[].obs;

  Future<http.Response> addPuppy({Puppy? puppy}) async {
    final http.Response response = await http.post(
      Uri.parse('http://localhost:8080/api/puppy'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(puppy),
    );
    getPuppies();
    return response;
  }

  void getPuppies() async {
    String url = "http://localhost:8080/api/puppy";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var results = jsonDecode(response.body);
      puppyList.assignAll(createPuppyList(results).toList());
    } else {
      throw Exception('Unable to fetch puppies from the REST API');
    }
  }

  Future<http.Response> deletePuppy(Puppy puppy) async {
    var id = puppy.id;
    final http.Response response = await http.delete(
      Uri.parse('http://localhost:8080/api/puppy/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    getPuppies();
    return response;
  }

  void markAsServiced(int id) async {
    updatePuppy(id);
    getPuppies();
  }

  Future<http.Response> updatePuppy(int id) async {
    final http.Response response = await http.put(
      Uri.parse('http://localhost:8080/api/puppy/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    getPuppies();
    return response;
  }

  List<Puppy> createPuppyList(List data){
    List<Puppy> list = [];
    for (int i = 0; i < data.length; i++) {
      Puppy puppy = new Puppy.fromJson(data[i]);
      list.add(puppy);
    }
    return list;
  }

}