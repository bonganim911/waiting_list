import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:waiting_list/models/puppy.dart';
import 'package:http/http.dart' as http;
import '../api/puppyServiceData.dart';

class PuppyController extends GetxController {
  var puppyServiceData =  PuppyServiceData();
  @override
  void onReady() {
    super.onReady();
    puppyServiceData = PuppyServiceData();
  }

  var puppyList = <Puppy>[].obs;

  Future<http.Response> addPuppy({Puppy? puppy}) async {
    puppyServiceData.fetchPuppies();
    return puppyServiceData.createPuppy(puppy: puppy);
  }

  void getPuppies() async {
    var results = await puppyServiceData.fetchPuppies();
    puppyList.assignAll(results);
  }

  removePuppy(Puppy puppy) async {
    puppyServiceData.deletePuppy(puppy);
    getPuppies();
  }

  void markAsServiced(int id) async {
    puppyServiceData.updatePuppy(id);
    getPuppies();
  }

}