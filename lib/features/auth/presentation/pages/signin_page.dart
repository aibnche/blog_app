import 'package:blog/core/common/widgets/loader.dart';
import 'package:blog/core/utils/show_snackbar.dart';
import 'package:blog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog/features/auth/presentation/pages/signup_page.dart';
import 'package:blog/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  /*
    @ Purpose: Route to SignInPage
    @ Returns a MaterialPageRoute that builds the SignInPage widget.
      + MaterialPageRoute : Provides platform-specific transitions (slide on iOS, fade on Android)
    @ route() is a static method, Can be called without creating an object: SignInPage.route()
  */
  static route() => MaterialPageRoute(builder: (context) => const SignInPage());

  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose(); // Releases memory used by the email TextEditingControlle
    passwordController.dispose(); // Releases memory used by the password TextEditingController
    super.dispose(); // Calls the dispose method of the superclass to ensure proper cleanup
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        /*
          @ Used to listen for state changes and rebuild UI based on the new state.
          @ Combines BlocListener and BlocBuilder into a single widget.
        */
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackBar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Loader();
            }
            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Sign In.', style: TextStyle(fontSize: 35)),
                  SizedBox(height: 40),
                  AuthField(hintText: 'Email', controller: emailController),
                  SizedBox(height: 20),
                  AuthField(
                    hintText: 'Password',
                    controller: passwordController,
                    obscureText: true,
                  ),
                  SizedBox(height: 40),

                  AuthGradientButton(
                    textVal: 'Sign In',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        /*
                          @ Used to access a Bloc or Cubit without listening for state changes.
                          @ Not rebuild the widget on state changes.
                        */
                        context.read<AuthBloc>().add(
                          AuthSignIn(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          ),
                        );
                      }
                    },
                  ),

                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, SignUpPage.route());
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
