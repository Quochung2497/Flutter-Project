import 'package:example_app/utils/validator.dart';
import 'package:example_app/widgets/or_divider.dart';
import 'package:example_app/widgets/password_field.dart';
import 'package:example_app/widgets/services_button.dart';
import 'package:example_app/widgets/sign_link.dart';
import 'package:example_app/widgets/social_login.dart';
import 'package:example_app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../constants/social_provider.dart';
import '../../../widgets/logo_widget.dart';
import '../../../widgets/title_widget.dart';
import '../../../services/database.dart';
import '../../../constants/routes.dart';

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

    final user = await MockDatabase().login(email, password);
    if (user != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Login'),
          content: const Text('Login successful!'),
          actions: [
            TextButton(
              onPressed: () async {
                // 1) clear the mock database
                await MockDatabase().clear();
                // 2) close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Oke'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password.')),
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

  Widget buildSigninButton() => ServicesButton(onPressed: onSignin,label: 'Sign in');

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