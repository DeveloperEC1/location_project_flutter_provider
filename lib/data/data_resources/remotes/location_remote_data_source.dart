import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:locationprojectflutter/core/constants/constants.dart';
import 'package:locationprojectflutter/data/models/model_location/error.dart';
import 'package:locationprojectflutter/data/models/model_location/place_response.dart';
import 'package:locationprojectflutter/data/models/model_location/results.dart';
//import 'package:dio/dio.dart';

class LocationRemoteDataSource {
  static final LocationRemoteDataSource _instance =
      LocationRemoteDataSource.internal();

  factory LocationRemoteDataSource() => _instance;

  LocationRemoteDataSource.internal();

  Error _error;
  List<Results> _places = List();
  String _baseUrl = Constants.baseUrl;
  String _API_KEY = Constants.API_KEY;

//  Dio _dio = new Dio();

  Future responseJsonLocation(double latitude, double longitude, String open,
      String type, int valueRadiusText, String text) async {
    String url =
        '$_baseUrl?key=$_API_KEY&location=$latitude,$longitude$open&types=$type&radius=$valueRadiusText&keyword=$text';
    print(url);
    final response = await http.get(url);
//    final response = await _dio.get(url); // dio
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _handleResponse(data);
//      _handleResponse(response.data); // dio
    } else {
      throw Exception('An error occurred getting places nearby');
    }
    return _places;
  }

  _handleResponse(data) {
    if (data['status'] == "REQUEST_DENIED") {
      _error = Error.fromJson(data);
      print(_error);
    } else if (data['status'] == "OK") {
      _places = PlaceResponse.parseResults(data['results']);
    } else {
      print(data);
    }
  }
}
