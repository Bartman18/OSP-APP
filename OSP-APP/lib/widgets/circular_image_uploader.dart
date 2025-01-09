import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fox_core/core/appearance.dart';
import 'package:fox_core/core/helpers.dart';
import 'package:fox_core/widgets/buttons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircularImageUploader extends StatefulWidget {
  final Function(XFile) onChange;
  final double size;
  final Image? image;
  final String? imageUrl;

  const CircularImageUploader({
    required this.onChange,
    this.size = 260,
    this.image,
    this.imageUrl,
    super.key,
  });

  @override
  State<CircularImageUploader> createState() => _CircularImageUploaderState();
}

class _CircularImageUploaderState extends State<CircularImageUploader> {
  final ImagePicker picker = ImagePicker();

  Image? _currentImage;
  File? _imageFile;

  @override
  void initState() {
    _currentImage = widget.image;
    super.initState();
  }

  bool _hasImage() {
    return null != _currentImage || null != _imageFile || null != widget.imageUrl;
  }

  void _onClick(ImageSource source, BuildContext context) async {
    XFile? photo;
    bool hasAccess = false;
    
    if (ImageSource.camera == source) {
      await Permission.camera
        .onDeniedCallback(() => Helpers.deniedCameraAccessCallback(context))
        .onPermanentlyDeniedCallback(() => Helpers.deniedCameraAccessCallback(context))
        .onGrantedCallback(() => hasAccess = true)
        .onLimitedCallback(() => hasAccess = true)
        .request();

      if (hasAccess) {
        photo = await picker.pickImage(source: source);
      }
    }

    if (ImageSource.gallery == source) {
      try {
        photo = await picker.pickImage(source: source);
      } catch (e) {
        Helpers.deniedGalleryAccessCallback(context);
      }
    }

    if (false == photo is XFile) {
      return;
    }

    setState(() {
      _imageFile = File(photo!.path);
      _currentImage = Image.file(_imageFile!);
    });

    widget.onChange(photo!);
    Navigator.pop(context);
  }

  DecorationImage? _maybeGetDecorationImage() {
    bool noImage = null == _currentImage || null == _imageFile;

    if (widget.imageUrl is String && noImage) {
      return DecorationImage(
          image: NetworkImage(widget.imageUrl!),
          fit: BoxFit.cover
      );
    }

    if (noImage) {
      return null;
    }

    if (_currentImage is Image) {
      return DecorationImage(
        image: FileImage(_imageFile!),
        fit: BoxFit.cover
      );
    }

    return DecorationImage(
      image: FileImage(_imageFile!),
      fit: BoxFit.cover
    );
  }
  
  BoxDecoration _boxDecoration() {
    if (_hasImage()) {
      return BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                color: CoreColors.primary,
                gradient: LinearGradient(
                  colors: [CoreColors.white, CoreColors.primary],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  ),
              );
    }
    else {
      return BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                color: CoreColors.white.withOpacity(0.11),
                
              );
    }
  }
  Widget _resolveChild() {
    if (_hasImage()) {
      return const Wrap();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 90),
          Text('widgets.circular_image_uploader.label'.tr(), style: CoreTheme.mediumTextStyle.copyWith(color: CoreColors.white.withOpacity(0.8), fontSize: 19, fontVariations: CoreTheme.semiBoldTextStyle.fontVariations,)),
          Text('widgets.circular_image_uploader.subLabel'.tr(), style: CoreTheme.mediumTextStyle.copyWith(color: CoreColors.white.withOpacity(0.3), fontSize: 18))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: widget.size,
      height: widget.size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.all(2),
              width: 300,
              height: 300,
              decoration: _boxDecoration(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: Container(
                decoration: BoxDecoration(
                  image: _maybeGetDecorationImage(),
                ),
                child: Material(
                  color: CoreColors.gray.withOpacity(0.0),
                  child: InkWell(
                    highlightColor: CoreColors.white.withAlpha(30),
                    splashColor: CoreColors.white.withAlpha(80),
                    onTap: () {
                      Helpers.showBottomSheet(context, children: [
                        AppBottomSheetButton(
                          onPressed: () => _onClick(ImageSource.camera, context),
                          icon: Icons.camera_alt,
                          label: 'widgets.bottom_sheet.take_photo'.tr(),
                        ),
                        AppBottomSheetButton(
                          onPressed: () => _onClick(ImageSource.gallery, context),
                          icon: Icons.image_outlined,
                          label: 'widgets.bottom_sheet.select_photo_from_gallery'.tr(),
                        ),
                      ]);
                    },
                    child: _resolveChild(),
                  ),
                ),
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }

}