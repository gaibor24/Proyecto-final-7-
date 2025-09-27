import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../themes/themes.dart';

class CustomImageCache extends StatelessWidget {
  const CustomImageCache({
    super.key,
    this.url = '',
    this.fit = BoxFit.cover,
    this.imageDefault = '',
    this.imageColor,
    this.height,
    this.width,
  });

  final String url;
  final BoxFit fit;
  final String imageDefault;
  final Color? imageColor;
  final double? height;
  final double? width;

  static final CacheManager _customCacheManager = CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: const Duration(days: 7), // 🟢 Guarda imágenes por 7 días
      maxNrOfCacheObjects: 100, // 🔵 Máximo de imágenes en caché
    ),
  );

  bool get isValidUrl {
    final urlRegex = RegExp(
      r'^(https?:\/\/)?[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?',
    );

    if (url.isEmpty) return false;
    return urlRegex.hasMatch(url);
  }

  bool get isSvgUrl {
    RegExp regex = RegExp(r'\.svg$', caseSensitive: false);
    if (url.isEmpty) return false;
    return regex.hasMatch(url);
  }

  @override
  Widget build(BuildContext context) {
    if (isValidUrl) {
      return CachedNetworkImage(
        imageUrl: url,
        cacheManager: _customCacheManager, // 🔥 Usa caché personalizada
        filterQuality: FilterQuality.medium,
        fit: fit,
        width: width,
        height: height,
        placeholder:
            (context, url) => Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: Colors.blue,
                size: 18,
              ),
            ),
        errorWidget:
            (context, url, error) => const Center(
              child: Icon(Icons.error, color: Colors.red, size: 18),
            ),
      );
    } else if (isSvgUrl) {
      return SvgPicture.asset(
        url,
        fit: fit,
        width: width,
        height: height,
        semanticsLabel: 'A red up arrow',
        colorFilter: ColorFilter.mode(
          imageColor ?? Theme.of(context).textTheme.bodyLarge!.color!,
          BlendMode.srcIn,
        ),
      );
    }
    // si no llega a ser ana url, se hara de cuenta que es un asset
    else if (url.isNotEmpty) {
      return Image.asset(
        url,
        fit: fit,
        color: imageColor,
        width: width,
        height: height,
      );
    }
    // de ser necesario se dara una imagen por defecto
    else {
      return Center(
        child: Text('Sin imagen', style: TextsStyle(context).bodySmall),
      );
    }
  }
}
