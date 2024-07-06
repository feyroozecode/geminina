import 'package:dotenv/dotenv.dart';
import 'package:flutter/material.dart';
import 'package:geminina/const/app_constante.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatService {


  /// init model
  GenerativeModel initModel() {

    // env
    var env = DotEnv(includePlatformEnvironment: true)..load();
    
    return GenerativeModel(
      model: AppConstante.ada_model,
      apiKey: env['GEMINI_API_KEY']!, 
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high), 
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high)
      ]
    );
  }

  Future<String> sendMessage(String prompt) async {
    var env = DotEnv(includePlatformEnvironment: true)..load();

    final List<({Image? image, String? text, bool fromUser})> _generatedContent =
      <({Image? image, String? text, bool fromUser})>[];

    /// comment tout ceci en fr: 
    /// 
    final generativeAi = GenerativeModel(
        model: AppConstante.davinci_model, 
        apiKey: env['GEMINI_API_KEY']!,
        safetySettings: [
          SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high), 
          SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high)
                  ]
      );  
    
   return ""; //generativeAi.generateContent()
  } 
}
