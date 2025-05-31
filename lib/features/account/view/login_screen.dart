import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:example_app/widgets/widgets.dart';
import 'package:example_app/utils/utils.dart';
import 'package:example_app/constants/constants.dart';
import 'package:provider/provider.dart';
import '../provider/IAuth.dart';
import '../provider/auth_model.dart';


class LoginScreen extends StatefulWidget{
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>{
  final formKey   = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void onSignin() async
  {
    final validLogin = formKey.currentState?.validate() ?? false;
    if (!validLogin) return;

    final email = emailController.text.trim();
    final password = passwordController.text;

    context.read<IAuth>().clearError();
    final auth = context.read<IAuth>();
    final success = await auth.login(email, password);
    if (success) {
      showDialog(
        context: context,
        builder: (_) =>
        AlertDialog(
          title: const Text('Login'),
          content: const Text('Login successful!'),
          actions: [
            TextButton(
              onPressed: () async {
                await auth.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Oke'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void Dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IAuth>().clearError();
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                buildLogo(),
                buildTitle(),
                const SizedBox(height: 40),
                buildEmail(),
                const SizedBox(height:12),
                buildPassword(),

                buildErrorMessage(),

                const SizedBox(height: 40),
                buildSigninButton(),

                const SizedBox(height: 20),
                buildOrDivider(),

                const SizedBox(height: 20),
                buildSocialLogin(),

                const SizedBox(height: 20),
                buildSignupLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget buildLogo() => const Logo(assetPath: 'assets/Tour_Travel_Business_Logo.png');
  
  Widget buildTitle() => const TitleBlock(title: 'Sign in', subtitle: 'Hi Welcome back, Plan your next trip');

  Widget buildEmail() => LabelTextField(
    label: 'Email',
    controller: emailController,
    keyboardType: TextInputType.emailAddress,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'\s')),
    ],
    validator: Validators.validateEmail,
  );

  Widget buildPassword() => PasswordField(
    label: 'Password',
    controller: passwordController,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'\s')),
      FilteringTextInputFormatter.deny(RegExp('[^\x00-\x7F]')),
    ],
    validator: Validators.validatePassword,
    onForgotPassword: (){
      print('Redirecting to password recovery');
    },
  );

  Widget buildErrorMessage() {
    return Consumer<IAuth>(
      builder: (_, auth, __) {
        if (auth.error == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(auth.error!, style: const TextStyle(color: Colors.red)),
        );
      },
    );
  }

  Widget buildSigninButton() {
    return Consumer<IAuth>(
      builder: (_, auth, __) => ServicesButton(
        label: auth.status == AuthStatus.loading ? 'Signing in…' : 'Sign in',
        onPressed: auth.status == AuthStatus.loading ? null : onSignin,
      ),
    );
  }

  Widget buildOrDivider() => const OrDivider(label: 'OR',);

  Widget buildSocialLogin() => const SocialLoginRow(
    platforms: [
      SocialPlatform.google,
      SocialPlatform.facebook,
    ],
    providerMap: socialSignInProviders,
  );

  Widget buildSignupLink() => SignTextLink(onTap:
      () => Navigator.pushReplacementNamed(context, AppRoutes.register),
      normalText: "Don't have an account? ",
      linkText: 'Sign up');
}