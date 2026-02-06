import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_tts/flutter_tts.dart';

class GeminiServices {
  final FlutterTts _flutterTts = FlutterTts();

  static const apiKey = "AIzaSyDnTTSRg6BxJ_-cwgV9DtmAoIpFg8D4HfE";
  final model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: apiKey,
  );

  late ChatSession _chat;
  bool _isInitialized = false;

  void init() {
    _chat = model.startChat(history: []);
    _chat.sendMessage(Content.text('''
آپ ایک ذہین اردو بولنے والے AI ایجنٹ اسسٹنٹ ہیں۔
ہمیشہ مختصر، مہذب، اور اردو زبان میں پاکستانی انداز میں جواب دیں۔
جب کوئی آپ سے آپ کے بنانے والے کے بارے میں پوچھے تو ہمیشہ کہیں:
"میرے بنانے والے نکھل اور روپ ریکھا ہیں۔"
جب کوئی آپ سے پوچھے "آپ کون ہیں؟" یا اس کا مطلب رکھنے والا سوال کرے، تو ہمیشہ کہیں:
"میں ایک ذہین اردو بولنے والا AI ایجنٹ ہوں۔"
'''));
    _isInitialized = true;
  }

  Future<String> getResponse(String input) async {
    try {
      final response = await _chat.sendMessage(Content.text(input));
      if ((response.text ?? '').trim().isNotEmpty) {
        return response.text!;
      } else {
        return "خالی جواب ملا۔";
      }
    } on http.ClientException {
      return "انٹرنیٹ کنکشن دستیاب نہیں ہے۔";
    } on SocketException {
      return "انٹرنیٹ کنکشن دستیاب نہیں ہے۔";
    } on TimeoutException {
      return "وقت ختم ہو گیا، دوبارہ کوشش کریں۔";
    } catch (e) {
      print('Exception: $e');
      return "کچھ غلط ہو گیا، دوبارہ کوشش کریں۔";
    }
  }

  // Resets the chat and personality
  Future<void> resetChat() async {
    _chat = model.startChat(history: []);
    await _chat.sendMessage(Content.text('''
آپ ایک ذہین اردو بولنے والے AI ایجنٹ اسسٹنٹ ہیں۔
ہمیشہ مختصر، مہذب، اور اردو زبان میں پاکستانی انداز میں جواب دیں۔
جب کوئی آپ سے آپ کے بنانے والے کے بارے میں پوچھے تو ہمیشہ کہیں:
"میرے بنانے والے نکھل اور روپ ریکھا ہیں۔"
جب کوئی آپ سے پوچھے "آپ کون ہیں؟" یا اس کا مطلب رکھنے والا سوال کرے، تو ہمیشہ کہیں:
"میں ایک ذہین اردو بولنے والا AI ایجنٹ ہوں۔"
'''));
    print('Chat reset with personality.');
  }

  Future<void> speak(String text) async {
    await _flutterTts.setLanguage("ur-PK");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.speak(text);
  }
}
