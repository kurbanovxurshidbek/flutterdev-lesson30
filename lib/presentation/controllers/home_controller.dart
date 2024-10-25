import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/log_service.dart';
import '../../core/services/utils_service.dart';
import '../../data/models/message_model.dart';
import '../../data/respositories/gemini_talk_respository_impl.dart';
import '../../domain/usecases/gemini_text_and_image_usecase.dart';
import '../../domain/usecases/gemini_text_only_usecase.dart';

class HomeController extends GetxController {
  GeminiTextOnlyUseCase textOnlyUseCase =
      GeminiTextOnlyUseCase(GeminiTalkRepositoryImpl());
  GeminiTextAndImageUseCase textAndImageUseCase =
      GeminiTextAndImageUseCase(GeminiTalkRepositoryImpl());

  TextEditingController textController = TextEditingController();
  String response = '';
  String pickedImage64 = '';

  List<MessageModel> messages = [];

  pickImageFromGallery() async {
    var result = await Utils.pickAndConvertImage();
    LogService.i('Image selected !!!');
    pickedImage64 = result;
    update();
  }

  removePickedImage() {
    pickedImage64 = '';
    update();
  }

  askToGemini() {
    String message = textController.text.toString().trim();

    if (pickedImage64.isNotEmpty) {
      MessageModel mine =
          MessageModel(isMine: true, message: message, base64: pickedImage64);
      updateMessages(mine);
      apiTextAndImage(message);
    } else {
      MessageModel mine = MessageModel(isMine: true, message: message);
      updateMessages(mine);

      apiTextOnly(message);
    }
    textController.clear();

    removePickedImage();
  }

  apiTextOnly(String text) async {
    var either = await textOnlyUseCase.call(text);
    either.fold((l) {
      LogService.d(l);
      MessageModel gemini = MessageModel(isMine: false, message: l);
      updateMessages(gemini);
    }, (r) async {
      LogService.d(r);
      MessageModel gemini = MessageModel(isMine: false, message: r);
      updateMessages(gemini);
    });
  }

  apiTextAndImage(String text) async {
    var base64 = await Utils.pickAndConvertImage();

    var either = await textAndImageUseCase.call(text, base64);
    either.fold((l) {
      LogService.d(l);
      MessageModel gemini = MessageModel(isMine: false, message: l);
      updateMessages(gemini);
    }, (r) async {
      LogService.d(r);
      MessageModel gemini = MessageModel(isMine: false, message: r);
      updateMessages(gemini);
    });
  }

  updateMessages(MessageModel messageModel) {
    messages.add(messageModel);
    update();
  }
}
