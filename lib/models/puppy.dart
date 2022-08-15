class Puppy {
  int? id;
  String? name;
  String? serviceDetails;
  String? date;
  String? arrivalTime;
  int? isServiced;

  Puppy({
    this.id,
    this.name,
    this.serviceDetails,
    this.date,
    this.arrivalTime,
    this.isServiced
});
  Puppy.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    serviceDetails = json['serviceDetails'];
    date = json['date'];
    arrivalTime = json['arrivalTime'];
    isServiced = json['isServiced'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['serviceDetails'] = serviceDetails;
    data['date'] = date;
    data['arrivalTime'] = arrivalTime;
    data['isServiced'] = isServiced;
    return data;
  }
}