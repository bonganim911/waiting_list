import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:waiting_list/db/db_helper.dart';
import 'package:waiting_list/models/puppy.dart';

class PuppyController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  var puppyList = <Puppy>[].obs;

  Future<int> addPuppy({Puppy? puppy}) async {
    return await DBHelper.insert(puppy);
  }

  void getPuppies() async {
    List<Map<String, dynamic>> puppies = await DBHelper.query();
    puppyList.assignAll(puppies.map((data) => new Puppy.fromJson(data)).toList());
  }

  void deletePuppy(Puppy puppy){
    DBHelper.delete(puppy);
    getPuppies();
  }

  void markAsServiced(int id) async {
   await DBHelper.update(id);
   getPuppies();
  }
}