import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_common/base/tencent_cloud_chat_state_widget.dart';
import 'package:tencent_cloud_chat_common/components/components_definition/tencent_cloud_chat_component_builder_definitions.dart';
import 'package:tencent_cloud_chat_common/tencent_cloud_chat.dart';
import 'package:tencent_cloud_chat_common/utils/tencent_cloud_chat_utils.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data.dart';
import 'package:tencent_cloud_chat_message/model/tencent_cloud_chat_message_separate_data_notifier.dart';
import 'package:tencent_cloud_chat_message/tencent_cloud_chat_message_layout/tencent_cloud_chat_message_layout.dart';

///
/// 这里是把 对应的dataProvider缓存，以方便全局查找,替代到处传递
/// 以解决在message页面外发消息的情况
///
class TencentCloudChatMessageCacheLayout extends StatefulWidget {
  final MessageLayoutBuilderWidgets widgets;
  final MessageLayoutBuilderData data;
  final MessageLayoutBuilderMethods methods;

  const TencentCloudChatMessageCacheLayout({
    super.key,
    required this.widgets,
    required this.data,
    required this.methods,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends TencentCloudChatState<TencentCloudChatMessageCacheLayout> {
  late final TencentCloudChatMessageSeparateDataProvider _provider;

  @override
  void didChangeDependencies() {
    _provider = TencentCloudChatMessageDataProviderInherited.of(context);
    TencentCloudChatMessageDataProviderCache._add(_provider);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    TencentCloudChatMessageDataProviderCache._del(_provider);
  }

  @override
  Widget defaultBuilder(BuildContext context) => TencentCloudChatMessageLayout(
        widgets: widget.widgets,
        data: widget.data,
        methods: widget.methods,
      );
}

class TencentCloudChatMessageDataProviderCache {
  TencentCloudChatMessageDataProviderCache._();
  
  static const _tag = 'TencentCloudChatMessageDataProviderCache';
  static final _cache = <TencentCloudChatMessageSeparateDataProvider>[];

  static console(String log) {
    TencentCloudChat.instance.logInstance.console(
      componentName: _tag,
      logs: log,
    );
  }

  static List<TencentCloudChatMessageSeparateDataProvider> where(
      {String? userID, String? groupID}) {
    final findGroup = TencentCloudChatUtils.checkString(groupID) != null;
    final findC2C = TencentCloudChatUtils.checkString(userID) != null;
    return _cache.where((e) {
      if (findGroup) return e.groupID == groupID;
      if (findC2C) return e.userID == userID;
      assert(false, 'userID or groupID at least one');
      console('find bad userID:$userID, groupID:$groupID');
      return false;
    }).toList();
  }

  static TencentCloudChatMessageSeparateDataProvider? first(
          {String? userID, String? groupID}) =>
      where(userID: userID, groupID: groupID).firstOrNull;

  static void _add(TencentCloudChatMessageSeparateDataProvider dataProvider) {
    final userID = dataProvider.userID;
    final groupID = dataProvider.groupID;
    console(
        'add userID:$userID, groupID:$groupID provider:${identityHashCode(dataProvider)}');
    if (!_cache.contains(dataProvider)) {
      _cache.add(dataProvider);
    }
  }

  static void _del(TencentCloudChatMessageSeparateDataProvider dataProvider) {
    final userID = dataProvider.userID;
    final groupID = dataProvider.groupID;
    console(
        'del userID:$userID, groupID:$groupID provider:${dataProvider.hashCode}');
    _cache.remove(dataProvider);
  }
}
