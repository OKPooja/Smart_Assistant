import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:voice_assistant_app/feature_box.dart';
import 'package:voice_assistant_app/openai_service.dart';
import 'package:voice_assistant_app/pallet.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget{
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{
  final speechToText = SpeechToText();
  final OpenAIService openAIService = OpenAIService();
  final flutterTts = FlutterTts();
  String lastWords = '';
  String? generatedContent;
  int start = 200, delay = 200;

  @override
  void initState(){
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }
  Future<void> initTextToSpeech() async{
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }
  Future<void> initSpeechToText() async{
    await speechToText.initialize();
    setState(() { });
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  Future<Uint8List> bytesFromImageProvider(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    return response.bodyBytes;
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
    //print(lastWords);
  }
  Future<void> systemSpeak(String content) async{
    await flutterTts.speak(content);
  }
  @override
  void dispose(){
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(child: const Text('Ella')),
        foregroundColor: Pallete.whiteColor ,
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
      child: Column(
          children: [
            //virtual assistant picture
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      margin: const EdgeInsets.only(top:4),
                      decoration: const BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        shape: BoxShape.circle,
                    	),
                     ),
                  ),
                  Container(
                    height: 123,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/Assistant.png'
                        ),
                      )
                    ),
                  )
                ],
              ),
            ),
            //chat bubble
            FadeInRight(
                child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 30).copyWith(top:30),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Pallete.borderColor,
                      ),
                      borderRadius: BorderRadius.circular((20)).copyWith(
                        topLeft: Radius.zero,
                      ),
                    ),
                      child:  Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0,),
                        child:  Text(
                        generatedContent ==  null
                        ?'Hello there, what task can I do for you?'
                        : generatedContent!,
                        style: TextStyle(
                        color: Pallete.mainFontColor,
                        fontSize: generatedContent == null? 20: 18,
                      ),
                    ),
                  ),
                ),
            ),


            //suggestions list
            SlideInLeft(
              child: Visibility(
                  visible: generatedContent == null,
                  child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 10,left: 30),
                  child: const Text('Look at my features:',
                    style: TextStyle(
                      color: Pallete.mainFontColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            //features list
            Visibility(
              visible: generatedContent == null,
              child: Column(
                children: [
                  SlideInLeft(
                    delay: Duration(milliseconds: start),
                    child: const FeatureBox(
                       color: Pallete.firstSuggestionBoxColor,
                       headerText: 'ChatGPT',
                      description: 'Experience a smarter and effortless solution for completing tasks and resolving doubts.',
                    ),
                  ),
                    SlideInRight(
                      delay: Duration(milliseconds: start + 2 * delay),
                      child: const FeatureBox(
                      color: Pallete.thirdSuggestionBoxColor,
                      headerText: 'Smart Voice Assistant',
                      description: 'Get the best of both worlds with a voice assistant powered by ChatGPT.',
                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: start + 3 * delay),
        child: FloatingActionButton(
          backgroundColor: Pallete.assistantCircleColor,
          onPressed: () async{
            if(await speechToText.hasPermission && speechToText.isNotListening){
              //print("Started listening");
              await startListening();
            }
            else if(speechToText.isListening){
              //print(lastWords);
              final speech = await openAIService.chatGPTAPI(lastWords);
              //print(speech);
              generatedContent = speech;
              setState(() {});
              await systemSpeak(speech);
              if(speechToText.isNotListening){
                await stopListening();
              }
            } else{
              initSpeechToText();
            }
          },
          child: Icon(
              speechToText.isListening ? Icons.stop :Icons.mic,
          ),
        ),
      ),
    );
  }
}