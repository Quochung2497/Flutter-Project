import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/social_provider.dart';

class SocialLoginRow extends StatelessWidget {
  final List<SocialPlatform> platforms;
  final Map<SocialPlatform, SocialProvider> providerMap;

  const SocialLoginRow({Key? key,  required this.platforms,  required this.providerMap}) : super(key: key);

  Future<void> launchExternalUrl(BuildContext context, String url, String redirectMessage) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      debugPrint('Invalid URL: $url');
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(redirectMessage)),
    );
    try {
      final didLaunch = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      if (!didLaunch) {
        debugPrint('launchUrl returned false for $url');
      }
    } catch (e, st) {
      debugPrint('error launching $url:\n$e\n$st');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: platforms.map((platform) {
        final provider = providerMap[platform]!;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: IconButton(
            tooltip: provider.tooltip,
            onPressed: () => launchExternalUrl(
              context,
              provider.url,
              'Redirecting to ${provider.name}',
            ),
            icon: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset(provider.iconAsset),
            ),
          ),
        );
      }).toList(),
    );
  }
}