import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/provider_register_email_firebase.dart';
import 'package:locationprojectflutter/presentation/utils/utils_app.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/widgets/widget_btn_firebase.dart';
import 'package:locationprojectflutter/presentation/widgets/widget_tff_firebase.dart';
import 'package:provider/provider.dart';

class PageRegisterEmailFirebase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderRegisterEmailFirebase>(
      builder: (context, results, child) {
        return PageRegisterEmailFirebaseProv();
      },
    );
  }
}

class PageRegisterEmailFirebaseProv extends StatefulWidget {
  @override
  _PageRegisterEmailFirebaseProvState createState() =>
      _PageRegisterEmailFirebaseProvState();
}

class _PageRegisterEmailFirebaseProvState
    extends State<PageRegisterEmailFirebaseProv> {
  ProviderRegisterEmailFirebase _provider;

  @override
  void initState() {
    super.initState();

    _provider =
        Provider.of<ProviderRegisterEmailFirebase>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
                _buttonRegister(),
                UtilsApp.dividerHeight(context, 5),
                _showErrors(),
                _buttonToLogin(),
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
      'Register',
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

  Widget _buttonRegister() {
    return Padding(
      padding: EdgeInsets.only(
          left: ResponsiveScreen().widthMediaQuery(context, 20),
          right: ResponsiveScreen().widthMediaQuery(context, 20),
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: WidgetBtnFirebase(
        text: 'Register',
        onTap: () => _provider.checkClickBtnRegister(context),
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

  Widget _buttonToLogin() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: const Text(
        'Have an account? click here to login',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _loading() {
    return _provider.isLoadingGet == true
        ? const CircularProgressIndicator()
        : Container();
  }
}
