import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';

updateApi( BuildContext context,{String? pKey}) async {
  try {
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${EndPoints.baseUrl}${EndPoints.updateUser}${PrefService.getString(PrefKey.userId)}'));
    request.fields.addAll({pKey!: "true",});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

    } else {

      debugPrint(response.reasonPhrase);
    }
  } catch (e) {

    debugPrint(e.toString());
  }
}
