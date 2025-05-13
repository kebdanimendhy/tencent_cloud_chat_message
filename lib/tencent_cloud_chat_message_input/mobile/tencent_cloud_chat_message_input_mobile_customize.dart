part of 'tencent_cloud_chat_message_input_mobile.dart';

// 将原来的私有函数，暴露到子类
class TencentCloudChatMessageInputMobileCustomizeState extends _TencentCloudChatMessageInputMobileState {
  void onTextChanged() {}

  @override
  void _onTextChanged() {
    onTextChanged();
    super._onTextChanged();
  }

  @protected
  double? getBottomContainerHeight() => null;

  @override
  double _getBottomContainerHeight() {
    final h = getBottomContainerHeight();
    if (h != null) return h;
    return super._getBottomContainerHeight();
  }

  // 不再只表示表情Panel了，而表示自定义
  @protected
  Widget? buildStickerPanelWidget() => null;

  @override
  Future<bool> getStickerPanelWidget() {
    final widget = buildStickerPanelWidget();
    if (widget != null) {
      stickerWidget = widget;
      return Future.value(true);
    } else {
      return super.getStickerPanelWidget();
    }
  }

  @protected
  Widget buildInputTextField() {
    return _buildInputTextField();
  }

  @protected
  Widget buildMic(TencentCloudChatThemeColors colorTheme, TencentCloudChatTextStyle textStyle, {Widget? icon}) {
    return Tooltip(
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

  @protected
  bool get showStickerPanel => _showStickerPanel;

  @protected
  FocusNode get textEditingFocusNode => _textEditingFocusNode;

  @protected
  TextEditingController get textEditingController => _textEditingController;

  @protected
  List<({String userID, String label})> get mentionedUsers => _mentionedUsers;

  @protected
  void setShowStickerPanel(bool v) => _showStickerPanel = v;

  @protected
  void setShowKeyboard(bool v) => _showKeyboard = v;

  void sendTextMessage() {
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
  @protected
  Widget buildInputTextFieldWithStyle(TencentCloudChatThemeColors colorTheme, {Widget? tailIcon}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: getWidth(10), horizontal: getHeight(16)),
      decoration: BoxDecoration(
        color: colorTheme.inputFieldBackgroundColor,
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

  @protected
  Widget? buildInputWidget(BoxConstraints constraints) => null;

  @override
  Widget _buildInputWidget(BoxConstraints constraints) {
    final widget = buildInputWidget(constraints);
    if (widget != null) return widget;
    return super._buildInputWidget(constraints);
  }
}
