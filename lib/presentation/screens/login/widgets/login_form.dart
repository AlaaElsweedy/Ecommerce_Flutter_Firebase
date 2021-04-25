import 'package:e_commerce_app/presentation/common_blocs/auth/auth.dart';
import 'package:e_commerce_app/presentation/common_blocs/auth/bloc.dart';
import 'package:e_commerce_app/configs/config.dart';
import 'package:e_commerce_app/constants/constants.dart';
import 'package:e_commerce_app/presentation/screens/login/bloc/bloc.dart';
import 'package:e_commerce_app/presentation/widgets/custom_widgets.dart';
import 'package:e_commerce_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late LoginBloc loginBloc;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isShowPassword = false;

  @override
  void initState() {
    loginBloc = BlocProvider.of<LoginBloc>(context);

    super.initState();
  }

  bool get isPopulated =>
      emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled() {
    return loginBloc.state.isFormValid &&
        !loginBloc.state.isSubmitting &&
        isPopulated;
  }

  void onLogin() {
    if (isLoginButtonEnabled()) {
      loginBloc.add(LoginWithCredential(
        email: emailController.text,
        password: passwordController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        /// Success
        if (state.isSuccess) {
          UtilDialog.hideWaiting(context);
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }

        /// Failure
        if (state.isFailure) {
          UtilDialog.hideWaiting(context);
          UtilDialog.showInformation(context, content: state.message);
        }

        /// Logging
        if (state.isSubmitting) {
          UtilDialog.showWaiting(context);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Container(
            margin:
            EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 1.5),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.defaultPadding,
              vertical: SizeConfig.defaultSize * 3,
            ),
            child: Form(
              child: Column(
                children: <Widget>[
                  _buildTextFieldUsername(),
                  SizedBox(height: SizeConfig.defaultSize),
                  _buildTextFieldPassword(),
                  SizedBox(height: SizeConfig.defaultSize),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        Translate.of(context).translate('forgot_password')),
                  ),
                  SizedBox(height: SizeConfig.defaultSize * 2),
                  _buildButtonLogin(state),
                  SizedBox(height: SizeConfig.defaultSize * 2),
                  _buildTextOr(),
                  SizedBox(height: SizeConfig.defaultSize * 2),

                  ElevatedButton(
                    onPressed: (){},
                    child:
                    _buildNoAccountText(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build content
  _buildTextFieldUsername() {
    return TextFormField(
      controller: emailController,
      onChanged: (value) {
        loginBloc.add(EmailChanged(email: value));
      },
      validator: (_) {
        return !loginBloc.state.isEmailValid
            ? Translate.of(context).translate('invalid_email')
            : null;
      },
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: Translate.of(context).translate('email'),
        suffixIcon: Icon(Icons.email_outlined),
      ),
      textInputAction: TextInputAction.next, // thay nút enter thành next
      onEditingComplete:_emailEditingComplete,
    );
  }
  final FocusNode _passwordFocusNode = FocusNode();
  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }


  _buildTextFieldPassword() {
    return TextFormField(
      controller: passwordController,
      onChanged: (value) {
        loginBloc.add(PasswordChanged(password: value));
      },
      validator: (_) {
        return !loginBloc.state.isPasswordValid
            ? Translate.of(context).translate('invalid_password')
            : null;
      },
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.text,
      obscureText: !isShowPassword,
      decoration: InputDecoration(
        hintText: Translate.of(context).translate('password'),
        suffixIcon: IconButton(
          icon: isShowPassword
              ? Icon(Icons.visibility)
              : Icon(Icons.visibility_off),
          onPressed: () {
            setState(() => isShowPassword = !isShowPassword);
          },
        ),
      ),
      focusNode: _passwordFocusNode,
      onEditingComplete: onLogin,
    );
  }

  _buildButtonLogin(LoginState state) {
    return DefaultButton(
      child: Text(
        Translate.of(context).translate('login').toUpperCase(),
        style: FONT_CONST.BOLD_WHITE_18,
      ),
      onPressed: onLogin,
    );
  }

  _buildTextOr() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Divider(color: Colors.black26),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            color: COLOR_CONST.backgroundColor,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.defaultSize,
                vertical: 0,
              ),
              child: Text(Translate.of(context).translate('or')),
            ),
          ),
        )
      ],
    );
  }

  _buildNoAccountText() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(Translate.of(context).translate('don\'t_have_an_account')),
          SizedBox(width: 5),
          GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              AppRouter.INITIALIZE_INFO,
            ),
            child: Text(
              Translate.of(context).translate('register'),
              style: FONT_CONST.BOLD_PRIMARY_16,
            ),
          ),
        ],
      ),
    );
  }
}
