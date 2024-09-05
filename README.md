# Customizable Chatbot Powered by OpenAI GPT

A Flutter package for integrating a customizable chatbot powered by OpenAI's GPT API. This package allows you to create personalized conversational experiences by configuring various settings or using the default GPT-3.5-turbo model.

![MyChatBot](https://rubio.ink/assets/img/work/workchatgpt.png)

## Features

- Customizable API Integration with OpenAI GPT.
- Default support for the GPT-3.5-turbo model.
- Ability to use your own API service.
- Dynamic configuration options such as model, messages, and token limits.
- Allowing Users to Customize Message Sending Functionality

## Installation
```sh
dependencies:
  your_chatbot_package: ^1.1.0
```

## Usage
ChatBot provides an easy way to implement the ChatGPT API, allowing you to focus on more important matters.
To get started, create a `ChatController` instance and provide it with the API key.

```sh
import 'package:chat_bot/controllers/chat_controller.dart';

final ChatController chatController = ChatController(
  apiKey: 'your-api-key-here',
);

```
Next, use our `ChatBot` widget, which requires the `chatController` instance
```sh
ChatBot(
  chatController: chatController,
),
```
And that's all!

## Custom Configuration
Customize your ChatGptModel and other properties.

```sh
final ChatController chatController = ChatController(
  apiKey: 'your-api-key-here',
  params: ParamsChatBot(
    model: 'gpt-3.5-turbo',
    maxTokens: 150,
  )
);
```
And modify the style of the widgets as you wish.

```sh
ChatBot(
  chatController: chatController,
  customTypeIndicator: const LinearProgressIndicator(),
  styleInput: const ChatInputStyle(
    activeColor: Colors.red
  ),
),
```

## Using Your Own API Service
In case you wish to use your own implementation, you can easily override the API data source.

```sh
final ChatController chatController =
    ChatController(datasource: SendMessageImplementation()); //Override
...widet body



///Create you own implementation
class SendMessageImplementation extends ChatBotDatasource {
  @override
  Future<MessageChat> sendMessage({required String message}) async {
    await Future.delayed(const Duration(milliseconds: 2000));
    //Implement your custom logic here.
    return MessageChat(
      content: message,
      created: '3:30 PM',
      role: "user",
    );
  }
```


## License

This project is licensed under the GNU License. See the LICENSE file for details.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss improvements or report bugs.

## Acknowledgments

Thanks to OpenAI for providing the GPT API.
Special thanks to the Flutter community for their ongoing support.
And lastly thanks to EmojiPicker for providing an easy way to implement emojis.