import 'package:locationprojectflutter/data/models/model_location/opening_hours.dart';
import 'package:locationprojectflutter/data/models/model_location/photos.dart';
import 'geometry.dart';

class Results {
  String id;
  String name;
  String vicinity;
  Geometry geometry;
  List<Photos> photos;
  OpeningHours opening_hours;

  Results.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.vicinity = json['vicinity'];
    this.geometry = Geometry.fromJson(
      json['geometry'],
    );
    this.photos = json.containsKey("photos")
        ? List<Photos>.from(
            json['photos']
                .map<Photos>(
                  (i) => Photos.fromJson(i),
                )
                .toList(),
          )
        : [];
    this.opening_hours = json.containsKey("opening_hours")
        ? OpeningHours.fromJson(
            json['opening_hours'],
          )
        : null;
  }
}
