import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:voice_assistant_app/secrets.dart';

class OpenAIService{
  final List<Map<String, String>> messages = [];
  Future<String> chatGPTAPI(String prompt) async{
    messages.add({
      'role' : 'user',
      'content' : prompt,
    });
    try{
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAPIKey',
        },
        body: jsonEncode({
          'model': "gpt-3.5-turbo",
          "messages": messages,
        }),
      );
      //print(res.body);
      if(res.statusCode == 200){
        String content = jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
        //print(content);

        messages.add({
          'role' : 'assistant',
          'content' : content,
        });
        return content;
      }
      return 'Internal error occurred';
    }catch(e){
      return e.toString();
    }
  }
}