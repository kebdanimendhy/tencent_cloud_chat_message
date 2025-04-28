part of 'tencent_cloud_chat_message_input_mobile.dart';

class TencentCloudChatMessageInputMobileCustomizeData {
  BoxConstraints constraints;
  TencentCloudChatThemeColors colorTheme;
  TencentCloudChatTextStyle textStyle;

  TencentCloudChatMessageInputMobileCustomizeData({
    required this.constraints,
    required this.colorTheme,
    required this.textStyle,
  });
}

class TencentCloudChatMessageInputMobileCustomizeMethods {
  VoidCallback sendTextMessage;
  double Function() getPanelHeight;
  Widget Function({Widget? icon}) micBuilder;
  Widget Function({Widget? tailIcon}) textFieldWithStyleBuilder;
  Widget Function() textFieldBuilder;
  // bool Function() showKeyboard;
  // void Function() toggleShowKeyboard;
  bool Function() isShowStickerPanel;
  void Function() toggleShowStickerPanel;
  bool Function() isTextEditingFocusNodeHasFoucs;
  void Function() textEditingFocusNodeFocus;
  void Function() textEditingFocusNodeUnfocus;
  List<({String userID, String label})> Function() getMentionedUsers;
  String Function() getInputText;

  TencentCloudChatMessageInputMobileCustomizeMethods({
    required this.sendTextMessage,
    required this.getPanelHeight,
    required this.micBuilder,
    required this.textFieldWithStyleBuilder,
    required this.textFieldBuilder,
    // required this.showKeyboard,
    // required this.toggleShowKeyboard,
    required this.isShowStickerPanel,
    required this.toggleShowStickerPanel,
    required this.isTextEditingFocusNodeHasFoucs,
    required this.textEditingFocusNodeFocus,
    required this.textEditingFocusNodeUnfocus,
    required this.getMentionedUsers,
    required this.getInputText,
  });
}

/// 实现按钮的自定义，表情Pannel的自定义
class TencentCloudChatMessageInputMobileCustomize extends TencentCloudChatMessageInputMobile {
  final Widget Function({
    required BuildContext context,
    required TencentCloudChatMessageInputMobileCustomizeData data,
    required TencentCloudChatMessageInputMobileCustomizeMethods methods,
  })? inputWidgetBuilder;
  final Widget Function(BuildContext context)? stickerPanelBuilder;
  final void Function(String text)? onTextChanged;
  const TencentCloudChatMessageInputMobileCustomize({
    super.key,
    required super.inputData,
    required super.inputMethods,
    this.inputWidgetBuilder,
    this.stickerPanelBuilder,
    this.onTextChanged,
  });

  @override
  State<TencentCloudChatMessageInputMobile> createState() => _StateEx();
}

class _StateEx extends _TencentCloudChatMessageInputMobileState {
  @override
  TencentCloudChatMessageInputMobileCustomize get widget => super.widget as TencentCloudChatMessageInputMobileCustomize;

  @override
  void _onTextChanged() {
    super._onTextChanged();
    widget.onTextChanged?.call(_textEditingController.text);
  }

  // 不再只表示表情Panel了，而表示自定义
  @override
  Future<bool> getStickerPanelWidget() async {
    final sticker = widget.stickerPanelBuilder?.call(context);
    if (sticker != null) {
      stickerWidget = sticker;
      return true;
    }
    return super.getStickerPanelWidget();
  }

  Widget Function({Widget? icon}) _getMicBuilder(TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle) {
    return ({Widget? icon}) => Tooltip(
          key: micTooltipKey,
          preferBelow: false,
          verticalOffset: getSquareSize(36),
          triggerMode: TooltipTriggerMode.manual,
          showDuration: const Duration(seconds: 1),
          message: tL10n.holdToRecordReleaseToSend,
          child: Listener(
            onPointerDown: _onStartRecording,
            onPointerUp: _onStopRecording,
            child: Container(
              padding: EdgeInsets.all(getSquareSize(6)),
              child: icon ??
                  Icon(
                    Icons.mic,
                    size: textStyle.inputAreaIcon,
                    color: colorTheme.inputAreaIconColor,
                  ),
            ),
          ),
        );
  }

  void _toggleShowStickerPanel() {
    if (!_showStickerPanel) {
      _textEditingFocusNode.unfocus();
    } else {
      _textEditingFocusNode.requestFocus();
    }
    safeSetState(() {
      _showStickerPanel = !_showStickerPanel;
    });
  }

  void _sendTextMessage() {
    widget.inputMethods.sendTextMessage(
      text: _textEditingController.text,
      mentionedUsers: _mentionedUsers
          .map(
            (e) => e.userID,
          )
          .toList(),
    );
    _inputText = "";
    _mentionedUsers.clear();
    _textEditingController.clear();
  }

  // 参见父类
  Widget _buildInputTextFieldWithStyle(TencentCloudChatThemeColors colorTheme, {Widget? tailIcon}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: getWidth(10), horizontal: getHeight(16)),
      decoration: BoxDecoration(
        color: colorTheme.backgroundColor,
        border: Border.all(color: colorTheme.inputFieldBorderColor),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Input field for the message.
          Expanded(
            child: _buildInputTextField(),
          ),
          if (tailIcon != null) tailIcon,
        ],
      ),
    );
  }

  @override
  Widget _buildInputWidget(BoxConstraints constraints) {
    if (widget.inputWidgetBuilder == null) {
      return super._buildInputWidget(constraints);
    }
    return TencentCloudChatThemeWidget(
      build: (context, colorTheme, textStyle) {
        return widget.inputWidgetBuilder!(
          context: context,
          data: TencentCloudChatMessageInputMobileCustomizeData(
            constraints: constraints,
            colorTheme: colorTheme,
            textStyle: textStyle,
          ),
          methods: TencentCloudChatMessageInputMobileCustomizeMethods(
            sendTextMessage: _sendTextMessage,
            getPanelHeight: _getBottomContainerHeight,
            micBuilder: _getMicBuilder(colorTheme, textStyle),
            textFieldBuilder: _buildInputTextField,
            textFieldWithStyleBuilder: ({Widget? tailIcon}) => _buildInputTextFieldWithStyle(colorTheme, tailIcon: tailIcon),
            // showKeyboard: () => _showKeyboard,
            // toggleShowKeyboard: _toggleShowKeyboard,
            isShowStickerPanel: () => _showStickerPanel,
            toggleShowStickerPanel: _toggleShowStickerPanel,
            isTextEditingFocusNodeHasFoucs: () => _textEditingFocusNode.hasFocus,
            textEditingFocusNodeFocus: _textEditingFocusNode.requestFocus,
            textEditingFocusNodeUnfocus: _textEditingFocusNode.unfocus,
            getMentionedUsers: () => _mentionedUsers,
            getInputText: () => _inputText,
          ),
        );
      },
    );
  }
}
