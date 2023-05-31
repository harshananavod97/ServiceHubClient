import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentApi {
  //************* base url *********************************************************/
  String baseurl = "https://api.uat.geniebiz.lk/public";

  //*******************************************************************************/
  Future<void> CreateTransaction(double amount, String currency) async {
    final transaction = await SharedPreferences.getInstance();
    Map data = {
      "amount": amount,
      "currency": currency,
    };

    print("post data $data");
    int index_of_no = 0;
    String body = json.encode(data);
    var url = Uri.parse(baseurl + '/v2/transactions');
    print("post url $url"); // Print the URL
    var response = await http.post(
      url,
      body: body,
      headers: {
        "accept": "application/json",
        "Authorization":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6IjM2YmFmY2U3LWEyMDEtNDI5Yi1hOWUyLWM1Yjc4NTQ2Njc3YyIsImNvbXBhbnlJZCI6IjYzOTdmMzlkZjA3ZmJhMDAwODQyYTkwYiIsImlhdCI6MTY3MDkwMjY4NSwiZXhwIjo0ODI2NTc2Mjg1fQ.fy12dgFhA3iB_RCjD7y8j5HClNRZUiBZgAg-QzFpxaE"
      },
    );
    print(response.body);
    print(response.statusCode);
    var jsonData = jsonDecode(response.body);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Logger().i('Success');
      print('Response ID: ${jsonData['id']}'); // Print the response ID
      print('Response URL: ${jsonData['url']}');
      //ID SAVE
      await transaction.setString('transaction_id', jsonData['id'].toString());
      //URL SAVE
      await transaction.setString('url', jsonData['url'].toString());

      index_of_no = 0;

      // Print the URL
    } else {
      Logger().e('Error');
      index_of_no = 1;
    }
    // await transaction.setInt('index_of_no', index_of_no);
  }

//get payment details
  void getTransaction(String transactionId) async {
    String amount;

    final response = await http.get(
      Uri.parse(baseurl + '/transactions/$transactionId'),
      headers: {
        'Authorization':
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6IjM2YmFmY2U3LWEyMDEtNDI5Yi1hOWUyLWM1Yjc4NTQ2Njc3YyIsImNvbXBhbnlJZCI6IjYzOTdmMzlkZjA3ZmJhMDAwODQyYTkwYiIsImlhdCI6MTY3MDkwMjY4NSwiZXhwIjo0ODI2NTc2Mjg1fQ.fy12dgFhA3iB_RCjD7y8j5HClNRZUiBZgAg-QzFpxaE",
        'Content-Type': 'application/json',
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      amount = {jsonResponse['amount']}.toString();

      // Do something with the response data
    } else {
      // Handle error response
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
