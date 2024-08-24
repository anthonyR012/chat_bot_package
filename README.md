# Customizable Chatbot Powered by OpenAI GPT

A Flutter package for integrating a customizable chatbot powered by OpenAI's GPT API. This package allows you to create personalized conversational experiences by configuring various settings or using the default GPT-3.5-turbo model.

## Features

- Customizable API Integration with OpenAI GPT.
- Default support for the GPT-3.5-turbo model.
- Ability to use your own API service.
- Dynamic configuration options such as model, messages, and token limits.

## Getting Started

Ensure you have the correct version of Flutter installed:

```sh
flutter --version
```

# Installation
```sh
dependencies:
  your_chatbot_package: ^1.0.1
```

# Usage
```sh
import 'package:chat_bot/controllers/chat_controller.dart';

final ChatController chatController = ChatController(
  apiKey: 'your-api-key-here',
);

```

# Custom Configuration

```sh
final ChatController chatController = ChatController(
  apiKey: 'your-api-key-here',
  params: ParamsChatBot(
    model: 'gpt-3.5-turbo',
    maxTokens: 150,
  )
);


```

# Using Your Own API Service

```sh
final ChatController chatController = ChatController(
    params: ParamsChatBot(
      baseUrl: "https://myownapi.com",
      data: ...,
      queryParameters: ...,
    )
);
final chatBot = ChatBot(
  apiKey: 'your-api-key-here',
  apiUrl: 'https://your-custom-api.com/v1/chat',
);

```

# License

This project is licensed under the GNU License. See the LICENSE file for details.

# Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss improvements or report bugs.

# Acknowledgments

Thanks to OpenAI for providing the GPT API.
Special thanks to the Flutter community for their ongoing support.