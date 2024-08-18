# Customizable Chatbot Powered by OpenAI GPT

A Flutter package for integrating a customizable chatbot powered by OpenAI's GPT API. This package allows you to create personalized conversational experiences by configuring various settings or using the default GPT-3.5-turbo model.

## Features

- Customizable API Integration with OpenAI GPT.
- Default support for the GPT-3.5-turbo model.
- Ability to use your own API service.
- Dynamic configuration options such as model, messages, and token limits.

## Getting Started

### Requirements

- **Flutter**: 3.22.1
- **Dart**: 3.4.1
- **DevTools**: 2.34.3

Ensure you have the correct version of Flutter installed:

```sh
flutter --version
```

# Installation
```sh
dependencies:
  your_chatbot_package: ^1.0.0
```

# Usage
```sh
import 'package:your_chatbot_package/your_chatbot_package.dart';

final chatBot = ChatBot(
  apiKey: 'your-api-key-here',
);

final response = await chatBot.sendMessage(
  message: 'Hello, how can I help you?',
);

print(response.content);
```

# Custom Configuration

```sh
final chatBot = ChatBot(
  apiKey: 'your-api-key-here',
  model: 'gpt-3.5-turbo',
  maxTokens: 150,
);

final response = await chatBot.sendMessage(
  message: 'What is the weather like today?',
);

print(response.content);
```

# Using Your Own API Service

```sh
final chatBot = ChatBot(
  apiKey: 'your-api-key-here',
  apiUrl: 'https://your-custom-api.com/v1/chat',
);

final response = await chatBot.sendMessage(
  message: 'Tell me a joke!',
);

print(response.content);
```

# License

This project is licensed under the GNU License. See the LICENSE file for details.

# Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss improvements or report bugs.

# Acknowledgments

Thanks to OpenAI for providing the GPT API.
Special thanks to the Flutter community for their ongoing support.