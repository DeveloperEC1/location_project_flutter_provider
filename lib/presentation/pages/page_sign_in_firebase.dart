import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:locationprojectflutter/core/constants/constants_images.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/provider_sign_in_firebase.dart';
import 'package:locationprojectflutter/presentation/utils/shower_pages.dart';
import 'package:locationprojectflutter/presentation/utils/utils_app.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/widgets/widget_btn_firebase.dart';
import 'package:locationprojectflutter/presentation/widgets/widget_tff_firebase.dart';
import 'package:provider/provider.dart';

class PageSignInFirebase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderSignInFirebase>(
      builder: (context, results, child) {
        return PageSignInFirebaseProv();
      },
    );
  }
}

class PageSignInFirebaseProv extends StatefulWidget {
  @override
  _PageSignInFirebaseProvState createState() => _PageSignInFirebaseProvState();
}

class _PageSignInFirebaseProvState extends State<PageSignInFirebaseProv> {
  ProviderSignInFirebase _provider;

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<ProviderSignInFirebase>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider.checkUserLogin(context);
      _provider.initGetSharedPrefs();
      _provider.isSuccess(null);
      _provider.isLoading(false);
      _provider.textError('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Form(
      key: _provider.formKeyGet,
      child: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _title(),
                UtilsApp.dividerHeight(context, 70),
                _textFieldsData(),
                UtilsApp.dividerHeight(context, 20),
                _buttonLogin(),
                UtilsApp.dividerHeight(context, 5),
                _showErrors(),
                _buttonToRegister(),
                UtilsApp.dividerHeight(context, 20),
                _loginFacebookGmailSms(),
                UtilsApp.dividerHeight(context, 20),
                _loading(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return const Text(
      'Login',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.greenAccent,
        fontSize: 40,
      ),
    );
  }

  Widget _textFieldsData() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            bottom: ResponsiveScreen().heightMediaQuery(context, 20),
          ),
          child: WidgetTFFFirebase(
            key: const Key('emailLogin'),
            icon: const Icon(Icons.email),
            hint: "Email",
            controller: _provider.emailControllerGet,
            textInputType: TextInputType.emailAddress,
            obSecure: false,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: ResponsiveScreen().heightMediaQuery(context, 20),
          ),
          child: WidgetTFFFirebase(
            key: const Key('passwordLogin'),
            icon: const Icon(Icons.lock),
            hint: "Password",
            controller: _provider.passwordControllerGet,
            textInputType: TextInputType.text,
            obSecure: true,
          ),
        ),
      ],
    );
  }

  Widget _buttonLogin() {
    return Padding(
      padding: EdgeInsets.only(
          left: ResponsiveScreen().widthMediaQuery(context, 20),
          right: ResponsiveScreen().widthMediaQuery(context, 20),
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: WidgetBtnFirebase(
        text: 'Login',
        onTap: () => _provider.checkClickBtnLogin(context),
      ),
    );
  }

  Widget _showErrors() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        _provider.isSuccessGet == null
            ? ''
            : _provider.isSuccessGet
                ? ''
                : _provider.textErrorGet,
        style: const TextStyle(
          color: Colors.redAccent,
          fontSize: 15,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buttonToRegister() {
    return GestureDetector(
      onTap: () {
        ShowerPages.pushPageRegisterEmailFirebase(context);
      },
      child: const Text(
        'Don' + "'" + 't Have an account? click here to register',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _loginFacebookGmailSms() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: ResponsiveScreen().widthMediaQuery(context, 60),
          height: ResponsiveScreen().widthMediaQuery(context, 60),
          child: MaterialButton(
            shape: const CircleBorder(),
            child: Image.asset(ConstantsImages.FACEBOOK_ICON),
            color: Colors.white,
            onPressed: () {
              _provider.facebookLogin(context);
              _provider.isLoading(true);
              _provider.textError('');
            },
          ),
        ),
        UtilsApp.dividerWidth(context, 20),
        Container(
          width: ResponsiveScreen().widthMediaQuery(context, 60),
          height: ResponsiveScreen().widthMediaQuery(context, 60),
          child: MaterialButton(
            shape: const CircleBorder(),
            child: Image.asset(ConstantsImages.GOOGLE_ICON),
            color: Colors.white,
            onPressed: () {
              _provider.signInWithGoogle(context);
              _provider.isLoading(true);
              _provider.textError('');
            },
          ),
        ),
        UtilsApp.dividerWidth(context, 20),
        Container(
          width: ResponsiveScreen().widthMediaQuery(context, 60),
          height: ResponsiveScreen().widthMediaQuery(context, 60),
          child: MaterialButton(
            shape: const CircleBorder(),
            child: Image.asset(ConstantsImages.PHONE_ICON),
            color: Colors.white,
            onPressed: () {
              ShowerPages.pushPagePhoneSmsAuth(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _loading() {
    return _provider.isLoadingGet == true
        ? const CircularProgressIndicator()
        : Container();
  }
}
