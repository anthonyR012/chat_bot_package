import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

/// A widget that displays a chat input field.
class ChatTextField extends StatefulWidget {
  /// required [onSend] callback when user sends a message
  /// required [controller] for text input
  /// required [focus] for text input
  const ChatTextField(
      {super.key,
      required this.onSend,
      required this.controller,
      required this.focus,
      ChatInputStyle? style})
      : style = style ?? const ChatInputStyle();

  /// [onSend] callback when user sends a message
  final VoidCallback onSend;
  final TextEditingController controller;
  final FocusNode focus;
  final ChatInputStyle style;

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  late final TextEditingController _controller;
  late FocusNode _focusNode;
  late final ChatInputStyle style;
  bool _isEmojiVisible = false;

  @override
  void initState() {
    _controller = widget.controller;
    _focusNode = widget.focus;
    style = widget.style;
    _focusNode.addListener(() {
      if (_isEmojiVisible && _focusNode.hasFocus) {
        _toggleEmojiPicker();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [_buildInputRow(), if (_isEmojiVisible) _buildEmojiPicker()],
    );
  }

  Widget _buildInputRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
      child: Row(
        children: [
          if (style.enableLeandingIcon)
            IconButton(
              icon: Icon(style.iconLending ?? Icons.emoji_emotions_outlined,
                  color: _isEmojiVisible
                      ? style.activeColor
                      : style.inactiveColor),
              onPressed: _toggleEmojiPicker,
            ),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              minLines: 1,
              maxLines: 5,
              decoration: style.inputDecoration ??
                  InputDecoration(
                    hintText: style.hintText ?? "Start typing...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                  ),
            ),
          ),
          _SendButton(
              textController: _controller, style: style, onSend: widget.onSend),
        ],
      ),
    );
  }

  Widget _buildEmojiPicker() {
    return EmojiPicker(
      onEmojiSelected: (category, emoji) {
        _controller.text += emoji.emoji;
      },
      onBackspacePressed: () {
        if (_controller.text.isNotEmpty) {
          _controller.text =
              _controller.text.substring(0, _controller.text.length - 1);
        }
      },
      config: widget.style.configEmojiPicker ??
          Config(
            height: widget.style.height,
            checkPlatformCompatibility: true,
            bottomActionBarConfig: const BottomActionBarConfig(enabled: false),
            swapCategoryAndBottomBar: false,
          ),
    );
  }

  void _toggleEmojiPicker() {
    if (_isEmojiVisible) {
      _focusNode.requestFocus();
    } else {
      _focusNode.unfocus();
    }
    setState(() {
      _isEmojiVisible = !_isEmojiVisible;
    });
  }
}

class _SendButton extends StatefulWidget {
  const _SendButton(
      {required this.textController,
      required this.style,
      required this.onSend});

  final TextEditingController textController;
  final ChatInputStyle style;
  final VoidCallback onSend;

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
  bool isActive = false;

  @override
  void initState() {
    widget.textController.addListener(() {
      /// Start typing change color of send button
      if (widget.textController.text.isNotEmpty && !isActive) {
        setState(() {
          isActive = true;
        });

        /// Stop typing and there is no text in textfield
      } else if (widget.textController.text.isEmpty && isActive) {
        setState(() {
          isActive = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(widget.style.iconTrailing ?? Icons.send,
          color:
              isActive ? widget.style.activeColor : widget.style.inactiveColor),
      style: widget.style.styleIconButton,
      onPressed: widget.onSend,
    );
  }
}

/// Define style of ChatInputField
class ChatInputStyle {
  /// Define style of textfield input
  final TextStyle styleText;

  /// Define style of send button
  final ButtonStyle? styleIconButton;

  /// You can define style of textfield input
  final InputDecoration? inputDecoration;
  final FocusNode? focusNode;

  /// For default it will be used [Icon(Icons.send)]
  final IconData? iconTrailing;

  /// For default it will be used [Icon(Icons.emoji_emotions_outlined)]
  final IconData? iconLending;
  final bool enableLeandingIcon;

  /// Define min and max lines of textfield input main
  final int minLines;
  final int maxLines;

  /// [hintText] and [hintTextStyle] are optional
  /// for default textfield input will be used "Start typing..."
  final String? hintText;
  final TextStyle? hintTextStyle;
  final Color activeColor;
  final Color inactiveColor;

  /// [height] of the emoji picker container
  final double height;

  /// [Config] of the emoji picker
  final Config? configEmojiPicker;

  const ChatInputStyle(
      {this.styleText = const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      this.enableLeandingIcon = true,
      this.height = 256,
      this.configEmojiPicker,
      this.activeColor = Colors.blue,
      this.inactiveColor = Colors.grey,
      this.hintText,
      this.hintTextStyle,
      this.minLines = 1,
      this.maxLines = 5,
      this.iconTrailing,
      this.iconLending,
      this.focusNode,
      this.inputDecoration,
      this.styleIconButton});
}
