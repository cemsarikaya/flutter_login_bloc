import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_bloc/login/cubit/login_cubit.dart';
import 'package:flutter_login_bloc/login/cubit/login_state_cubit.dart';
import 'package:flutter_login_bloc/login/service/login_service.dart';
import 'package:flutter_login_bloc/login/view/user_view.dart';
import 'package:vexana/vexana.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formLoginKey = GlobalKey();
  final pagePadding = const EdgeInsets.all(10);
  String buttonName = 'Login';
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) =>
          LoginCubit(LoginService(NetworkManager(options: BaseOptions(baseUrl: 'https://reqres.in/')))),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              return state.isLoading ? const CircularProgressIndicator(color: Colors.amber) : const SizedBox();
            },
          ),
        ),
        body: Form(
          key: _formLoginKey,
          child: Padding(
            padding: pagePadding,
            child: Column(
              children: [
                LoginTextView(
                  email: _emailController,
                  password: _passwordController,
                ),
                LoginButton(
                    formLoginKey: _formLoginKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    buttonName: buttonName),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key? key,
    required GlobalKey<FormState> formLoginKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required this.buttonName,
  })  : _formLoginKey = formLoginKey,
        _emailController = emailController,
        _passwordController = passwordController,
        super(key: key);

  final GlobalKey<FormState> _formLoginKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final String buttonName;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.isCompleted) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserView()));
        }
      },
      builder: (context, state) {
        return BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: () {
                if (_formLoginKey.currentState?.validate() ?? false) {
                  context.read<LoginCubit>().checkUser(_emailController.text, _passwordController.text);
                }
              },
              child: Text(buttonName),
            );
          },
        );
      },
    );
  }
}

class LoginTextView extends StatelessWidget {
  const LoginTextView({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);
  final TextEditingController email;
  final TextEditingController password;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LoginCubit, LoginState, bool>(
      selector: (state) {
        return state.isLoading;
      },
      builder: (context, state) {
        return IgnorePointer(
          ignoring: state,
          child: AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: state ? 0.3 : 1,
            child: Column(
              children: [
                TextFormField(
                  controller: email,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your email";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: password,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your password";
                    } else {
                      return null;
                    }
                  },
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
