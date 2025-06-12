import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:example_app/src/di/dependencies_injection.dart' show sl;
import 'package:example_app/src/features/auth/Bloc/auth_cubit.dart';
import 'package:example_app/src/constants/routes.dart';
import 'package:example_app/src/constants/social_provider.dart';
import 'package:example_app/src/utils/utils.dart';
import 'package:example_app/src/ui/components/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final AuthCubit _cubit;

  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();

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
    _emailController.dispose();
    _passwordController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onSignin() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _cubit.login(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          bloc: _cubit,
          listener: (ctx, state) {
            if (state.user != null) {
              showDialog(
                context: ctx,
                builder: (_) => AlertDialog(
                  title: const Text('Login'),
                  content: const Text('Login successful!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _cubit.clear();
                      },
                      child: const Text('Ok'),
                    ),
                  ],
                ),
              );
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
                  _buildTitle(),
                  const SizedBox(height: 40),

                  _buildEmailField(),
                  const SizedBox(height: 12),
                  _buildPasswordField(),
                  const SizedBox(height: 16),

                  _buildSigninButton(),
                  const SizedBox(height: 20),

                  _buildOrDivider(),
                  const SizedBox(height: 20),

                  _buildSocialLogin(),
                  const SizedBox(height: 20),

                  _buildSignupLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() => const Logo(assetPath: 'assets/Tour_Travel_Business_Logo.png');

  Widget _buildTitle() => const TitleBlock(
    title:    'Sign in',
    subtitle: 'Hi Welcome back, Plan your next trip',
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
    onForgotPassword: () {
      print('Forgot password pressed');
    },
  );

  Widget _buildSigninButton() {
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: _cubit,
      builder: (_, state) {
        return ServicesButton(
          label:    state.isLoading ? 'Signing in…' : 'Sign in',
          onPressed: state.isLoading ? null : _onSignin,
        );
      },
    );
  }

  Widget _buildOrDivider() => const OrDivider(label: 'OR');

  Widget _buildSocialLogin() => SocialLoginRow(
    platforms:  socialSignInProviders.keys.toList(),
    providerMap: socialSignInProviders,
  );

  Widget _buildSignupLink() => SignTextLink(
    normalText: "Don't have an account? ",
    linkText:   'Sign up',
    onTap:      () => Navigator.pushReplacementNamed(context, AppRoutes.register),
  );
}