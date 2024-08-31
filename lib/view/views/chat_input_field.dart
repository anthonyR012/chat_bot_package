import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField(
      {super.key,
      required this.onSend,
      required this.controller,
      required this.focus,
      ChatInputStyle? style})
      : style = style ?? const ChatInputStyle();
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
      children: [
        _buildInputRow(),
        if(_isEmojiVisible)
         _buildEmojiPicker()
      ],
    );
  }

  Widget _buildInputRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
      child: Row(
        children: [
          IconButton(
            icon: Icon(style.iconLending ?? Icons.emoji_emotions_outlined,
                color:
                    _isEmojiVisible ? style.activeColor : style.inactiveColor),
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
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1, end: 0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value * widget.style.height),
          child: Opacity(
            opacity: 1 - value,
            child: child),
        );
      },
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          _controller.text += emoji.emoji;
        },
        config: Config(
          height: widget.style.height,
          checkPlatformCompatibility: true,
          swapCategoryAndBottomBar: false,
        ),
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

class ChatInputStyle {
  final TextStyle styleText;
  final ButtonStyle? styleIconButton;
  final InputDecoration? inputDecoration;
  final FocusNode? focusNode;
  final IconData? iconTrailing;
  final IconData? iconLending;
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

  const ChatInputStyle(
      {this.styleText = const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      this.height = 256,
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
