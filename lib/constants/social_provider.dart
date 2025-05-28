enum SocialPlatform { google, facebook }

class SocialProvider {
  final String name;
  final String iconAsset;
  final String url;
  final String tooltip;

  const SocialProvider({
    required this.name,
    required this.iconAsset,
    required this.url,
    required this.tooltip,
  });
}

const Map<SocialPlatform, SocialProvider> socialSignInProviders = {
  SocialPlatform.google: SocialProvider(
    name: "Google",
    iconAsset: "assets/Google_Icon.png",
    url: "https://google.com", // Future sign-in API endpoint
    tooltip: "Sign in with Google",
  ),
  SocialPlatform.facebook: SocialProvider(
    name: "Facebook",
    iconAsset: "assets/facebook_Icon.png",
    url: "https://facebook.com",
    tooltip: "Sign in with Facebook",
  ),
};

const Map<SocialPlatform, SocialProvider> socialSignUpProviders = {
  SocialPlatform.google: SocialProvider(
    name: "Google",
    iconAsset: "assets/Google_Icon.png",
    url: "https://google.com",
    tooltip: "Sign up with Google",
  ),
  SocialPlatform.facebook: SocialProvider(
    name: "Facebook",
    iconAsset: "assets/facebook_Icon.png",
    url: "https://facebook.com",
    tooltip: "Sign up with Facebook",
  ),
};