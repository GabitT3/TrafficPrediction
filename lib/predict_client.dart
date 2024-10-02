import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  var originLat = await promptUserInput('Enter origin latitude:');
  var originLon = await promptUserInput('Enter origin longitude:');
  var destLat = await promptUserInput('Enter destination latitude:');
  var destLon = await promptUserInput('Enter destination longitude:');
  var dateTime = await promptUserInput('Enter date and time (YYYY-MM-DDTHH:mm:ss):');
  var trafficCondition = await promptUserInput('Enter traffic condition (e.g., Moderate Traffic):');

  var formattedDateTime = DateTime.parse(dateTime).toIso8601String();

  var url = Uri.parse('http://127.0.0.1:8000/predict');

  var requestBody = jsonEncode({
    "origin_lat": double.parse(originLat),
    "origin_lon": double.parse(originLon),
    "dest_lat": double.parse(destLat),
    "dest_lon": double.parse(destLon),
    "datetime": formattedDateTime,
    "traffic_condition": trafficCondition
  });

  var response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
    },
    body: requestBody,
  );

  if (response.statusCode == 200) {
    try {
      var responseData = jsonDecode(response.body);

      if (responseData.containsKey('prediction') && responseData.containsKey('category')) {
        var prediction = responseData['prediction'][0].toStringAsFixed(2);
        var category = responseData['category'];

        print('Prediction: $prediction');
        print('Category: $category');
      } else {
        print("Error: Unexpected response format");
      }
    } catch (e) {
      print("Error parsing JSON response: $e");
    }
  } else {
    print("Request failed with status: ${response.statusCode}");
    print("Response body: ${response.body}");
  }
}

Future<String> promptUserInput(String prompt) async {
  stdout.write('$prompt ');
  return stdin.readLineSync()!;
}
