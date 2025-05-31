import 'package:example_app/features/account/provider/IAuth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:example_app/widgets/widgets.dart';
import 'package:example_app/features/account/model/model.dart';
import 'package:example_app/utils/utils.dart';
import 'package:example_app/constants/constants.dart';
import 'package:provider/provider.dart';
import '../provider/auth_model.dart';

class CreateAccountScreen extends StatefulWidget{
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => CreateAccountScreenState();
}

class CreateAccountScreenState extends State<CreateAccountScreen> {

  var formKey   = GlobalKey<FormState>();

  void onRegister() async {
    var ok = formKey.currentState!.validate();

    if (!agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must agree to the Terms & Conditions')),
      );
      return;
    }
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the errors above.')),
      );
      return;
    }

    final auth    = context.read<IAuth>();
    final newUser = User(
      email:     emailController.text.trim(),
      password:  passwordController.text,
      firstName: firstNameController.text.trim(),
      lastName:  lastNameController.text.trim(),
    );

    context.read<IAuth>().clearError();
    final success = await auth.register(newUser);
    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  var agreedToTerms = false;

  void onAgreeChanged(bool value) {
    setState(() {
      agreedToTerms = value;
    });
  }

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formKey,
            child: Column(
            children: [
              buildLogo(context),

              buildHeader(context),
              const SizedBox(height: 40),

              buildFirstNameField(),
              const SizedBox(height: 16),
              buildLastNameField(),
              const SizedBox(height: 16),

              buildEmailField(),
              const SizedBox(height: 16),

              buildPasswordField(),
              const SizedBox(height: 16),

              buildErrorMessage(),

              buildTermsAndConditions(),
              const SizedBox(height: 8),

              buildRegisterButton(),

              const SizedBox(height: 20),
              buildOrDivider(),

              const SizedBox(height: 20),
              buildSocialLogin(),

              const SizedBox(height: 20),
              buildSigninLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLogo(BuildContext context) => const Logo(assetPath: 'assets/Tour_Travel_Business_Logo.png');

  Widget buildHeader(BuildContext context) => const TitleBlock(
    title: 'Create an account',
    subtitle: 'Fill your information below or register with your social account',
  );

  Widget buildFirstNameField() => LabelTextField(
    label: 'First Name',
    controller: firstNameController,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
    ],
  );

  Widget buildLastNameField() => LabelTextField(
    label: 'Last Name',
    controller: lastNameController,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
    ],
  );

  Widget buildEmailField() => LabelTextField(
    label: 'Email',
    controller: emailController,
    keyboardType: TextInputType.emailAddress,
    inputFormatters: [
      FilteringTextInputFormatter.deny( RegExp(r'\s')),
    ],
    validator: Validators.validateEmail,
  );

  Widget buildPasswordField() => PasswordField(
    label: 'Password',
    controller: passwordController,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'\s')),
      FilteringTextInputFormatter.deny(RegExp(r'[^\x00-\x7F]')),
    ],
    validator: Validators.validatePassword,
  );

  Widget buildErrorMessage() {
    return Consumer<IAuth>(
      builder: (ctx, auth, _) {
        if (auth.error == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(auth.error!, style: const TextStyle(color: Colors.red)),
        );
      },
    );
  }

  Widget buildTermsAndConditions()   => TermsAndConditionsCheckbox(onChanged: onAgreeChanged);

  Widget buildRegisterButton() {
    return Consumer<IAuth>(
      builder: (context, auth, _) {
        return ServicesButton(
          label: auth.status == AuthStatus.loading ? 'Registering…' : 'Register',
          onPressed: auth.status == AuthStatus.loading ? null : onRegister,
        );
      },
    );
  }

  Widget buildOrDivider() => const OrDivider(label: 'OR');

  Widget buildSocialLogin() => const SocialLoginRow(
    platforms: [
      SocialPlatform.google,
      SocialPlatform.facebook,
    ],
    providerMap: socialSignUpProviders,
  );

  Widget buildSigninLink() => SignTextLink(onTap:
      () => Navigator.pushReplacementNamed(context, AppRoutes.login),
    normalText: 'Do you have an account? ',
    linkText: 'Sign in',
  );
}