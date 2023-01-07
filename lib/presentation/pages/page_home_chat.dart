import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/provider_home_chat.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/utils/shower_pages.dart';
import 'package:provider/provider.dart';
import 'package:locationprojectflutter/core/constants/constants_colors.dart';

class PageHomeChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderHomeChat>(
      builder: (context, results, child) {
        return PageHomeChatProv();
      },
    );
  }
}

class PageHomeChatProv extends StatefulWidget {
  @override
  _PageHomeChatProvState createState() => _PageHomeChatProvState();
}

class _PageHomeChatProvState extends State<PageHomeChatProv> {
  ProviderHomeChat _provider;

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<ProviderHomeChat>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider.initGetSharedPrefs();
      _provider.initNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.indigoAccent,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.settings),
          color: ConstantsColors.LIGHT_BLUE,
          onPressed: () => ShowerPages.pushPageChatSettings(context),
        ),
      ],
      leading: IconButton(
        icon: Icon(
          Icons.navigate_before,
          color: ConstantsColors.LIGHT_BLUE,
          size: 40,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _body() {
    return Container(
      child: Center(
        child: StreamBuilder(
          stream: _provider.firestoreGet
              .collection('users')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(ConstantsColors.ORANGE),
                ),
              );
            } else {
              _provider.listMessage(snapshot.data.documents);
              return _provider.listMessageGet.length == 0
                  ? const Text(
                      'No Users',
                      style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 30,
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(
                          ResponsiveScreen().widthMediaQuery(context, 10)),
                      itemBuilder: (context, index) =>
                          _buildItem(context, _provider.listMessageGet[index]),
                      itemCount: _provider.listMessageGet.length,
                    );
            }
          },
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, DocumentSnapshot document) {
    if (document.data()['id'] == _provider.valueIdUserGet) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: document.data()['photoUrl'] != null
                    ? CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                              strokeWidth: ResponsiveScreen()
                                  .widthMediaQuery(context, 1),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  ConstantsColors.ORANGE)),
                          width:
                              ResponsiveScreen().widthMediaQuery(context, 50),
                          height:
                              ResponsiveScreen().widthMediaQuery(context, 50),
                          padding: EdgeInsets.all(
                              ResponsiveScreen().widthMediaQuery(context, 15)),
                        ),
                        imageUrl: document.data()['photoUrl'],
                        width: ResponsiveScreen().widthMediaQuery(context, 50),
                        height: ResponsiveScreen().widthMediaQuery(context, 50),
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 50.0,
                        color: ConstantsColors.DARK_GRAY,
                      ),
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Nickname: ${document.data()['nickname'] ?? 'Not available'}',
                          style: TextStyle(color: ConstantsColors.DARK_BLUE),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(
                          ResponsiveScreen().widthMediaQuery(context, 10),
                          ResponsiveScreen().heightMediaQuery(context, 0),
                          ResponsiveScreen().widthMediaQuery(context, 0),
                          ResponsiveScreen().heightMediaQuery(context, 5),
                        ),
                      ),
                      Container(
                        child: Text(
                          'About Me: ${document.data()['aboutMe'] ?? 'Not available'}',
                          style: TextStyle(color: ConstantsColors.DARK_BLUE),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(
                          ResponsiveScreen().widthMediaQuery(context, 10),
                          ResponsiveScreen().heightMediaQuery(context, 0),
                          ResponsiveScreen().widthMediaQuery(context, 0),
                          ResponsiveScreen().heightMediaQuery(context, 5),
                        ),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(
                      left: ResponsiveScreen().widthMediaQuery(context, 20)),
                ),
              ),
            ],
          ),
          onPressed: () {
            ShowerPages.pushPageChatScreen(
              context,
              document.id,
              document.data()['photoUrl'],
            );
          },
          color: ConstantsColors.LIGHT_GRAY,
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveScreen().heightMediaQuery(context, 10),
            horizontal: ResponsiveScreen().widthMediaQuery(context, 25),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        margin: EdgeInsets.only(
          bottom: ResponsiveScreen().heightMediaQuery(context, 10),
          left: ResponsiveScreen().widthMediaQuery(context, 5),
          right: ResponsiveScreen().widthMediaQuery(context, 5),
        ),
      );
    }
  }
}
