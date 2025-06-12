import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:example_app/src/di/dependencies_injection.dart' show sl;
import 'package:example_app/src/features/auth/Bloc/auth_cubit.dart';
import 'package:example_app/src/features/auth/model/model.dart';
import 'package:example_app/src/constants/routes.dart';
import 'package:example_app/src/constants/social_provider.dart';
import 'package:example_app/src/utils/utils.dart';
import 'package:example_app/src/ui/components/widgets.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late final AuthCubit _cubit;
  bool _agreed = false;

  final _firstNameController = TextEditingController();
  final _lastNameController  = TextEditingController();
  final _emailController     = TextEditingController();
  final _passwordController  = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit = sl<AuthCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.clearError();
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onAgreeChanged(bool v) => setState(() => _agreed = v);

  void _onRegister() {
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must agree to the Terms & Conditions')),
      );
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the errors above.')),
      );
      return;
    }

    final newUser = User(
      email:     _emailController.text.trim(),
      password:  _passwordController.text,
      firstName: _firstNameController.text.trim(),
      lastName:  _lastNameController.text.trim(),
    );
    _cubit.register(newUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          bloc: _cubit,
          listener: (ctx, state) {
            if (state.registered) {
              Navigator.pushReplacementNamed(ctx, AppRoutes.login);
            } else if (state.error != null) {
              ScaffoldMessenger.of(ctx)
                  .showSnackBar(SnackBar(content: Text(state.error!)));
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildLogo(),
                  _buildHeader(),
                  const SizedBox(height: 40),

                  _buildFirstNameField(),
                  const SizedBox(height: 8),
                  _buildLastNameField(),
                  const SizedBox(height: 8),

                  _buildEmailField(),
                  const SizedBox(height: 8),

                  _buildPasswordField(),
                  const SizedBox(height: 8),

                  _buildErrorMessage(),
                  const SizedBox(height: 0),

                  _buildTermsCheckbox(),
                  const SizedBox(height: 8),

                  _buildRegisterButton(),
                  const SizedBox(height: 8),

                  _buildOrDivider(),
                  const SizedBox(height: 20),

                  _buildSocialLogin(),
                  const SizedBox(height: 20),

                  _buildSignInLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() => const Logo(assetPath: 'assets/Tour_Travel_Business_Logo.png');

  Widget _buildHeader() => const TitleBlock(
    title:    'Create an account',
    subtitle: 'Fill your information below or register with your social account',
  );

  Widget _buildFirstNameField() => LabelTextField(
    label:       'First Name',
    controller:  _firstNameController,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
    ],
  );

  Widget _buildLastNameField() => LabelTextField(
    label:       'Last Name',
    controller:  _lastNameController,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
    ],
  );

  Widget _buildEmailField() => LabelTextField(
    label:       'Email',
    controller:  _emailController,
    keyboardType: TextInputType.emailAddress,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'\s')),
    ],
    validator: Validators.validateEmail,
  );

  Widget _buildPasswordField() => PasswordField(
    label:      'Password',
    controller: _passwordController,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'\s')),
      FilteringTextInputFormatter.deny(RegExp(r'[^\x00-\x7F]')),
    ],
    validator:  Validators.validatePassword,
  );

  Widget _buildErrorMessage() {
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: _cubit,
      builder: (_, state) {
        if (state.error == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(state.error!, style: const TextStyle(color: Colors.red)),
        );
      },
    );
  }

  Widget _buildTermsCheckbox() => TermsAndConditionsCheckbox(onChanged: _onAgreeChanged);

  Widget _buildRegisterButton() {
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: _cubit,
      builder: (_, state) {
        return ServicesButton(
          label:    state.isLoading ? 'Registering…' : 'Register',
          onPressed: state.isLoading ? null : _onRegister,
        );
      },
    );
  }

  Widget _buildOrDivider() => const OrDivider(label: 'OR');

  Widget _buildSocialLogin() => SocialLoginRow(
    platforms:  socialSignUpProviders.keys.toList(),
    providerMap: socialSignUpProviders,
  );

  Widget _buildSignInLink() => SignTextLink(
    normalText: 'Already have an account? ',
    linkText:   'Sign in',
    onTap:      () => Navigator.pushReplacementNamed(context, AppRoutes.login),
  );
}