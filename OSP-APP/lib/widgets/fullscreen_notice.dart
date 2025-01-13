import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:osp/core/appearance.dart';

/// Widget to show in case we want to display centered progress indicator while loading's in progress.
class FullscreenNotice extends StatelessWidget {
  final String notice;
  final String? header;
  final Widget? child;
  final Widget? icon;

  const FullscreenNotice({
    required this.notice,
    this.header,
    this.child,
    this.icon,
    super.key
  });

  Widget _defaultChild(BuildContext context) => FilledButton(
    onPressed: () => Navigator.of(context).pop(),
    style: ButtonStyle(backgroundColor: WidgetStateProperty.resolveWith<Color>((_) => Colors.redAccent)),
    child: Text('errors.generic.button'.tr())
  );

  @override
  Widget build(BuildContext context) {
    String noticeHeader = false == header is String ? 'errors.generic.button'.tr() : header!;

    return Stack(
      children: [
        Container(
          color: CoreColors.primary,
          height: double.infinity,
          width: double.infinity,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 50),

                null == icon ? const Icon(Icons.error_outline, color: Colors.white, size: 128) : icon!,

                Text(noticeHeader, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 20),

                Text(notice, style: const TextStyle(color: Colors.white, fontSize: 15), textAlign: TextAlign.justify),

                const SizedBox(height: 20),
                null == child ? _defaultChild(context) : child!,
              ],
            ),
          ),
        )
      ],
    );

  }
}
