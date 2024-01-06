import 'dart:io';

import 'package:flutter/material.dart';
import 'package:halifax_dating/widgets/default_card_border.dart';

class AppSectionCard extends StatelessWidget {
  // Variables
  // Text style
  final _textStyle = const TextStyle(
    color: Colors.redAccent,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );

  AppSectionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Initialization

    return Card(
      elevation: 4.0,
      shape: defaultCardBorder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Application',
                style: const TextStyle(fontSize: 20, color: Colors.grey),
                textAlign: TextAlign.left),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text('About Us', style: _textStyle),
            onTap: () {
              /// Go to About us screen
              // Navigator.of(context)
              //     .push(MaterialPageRoute(builder: (context) => const AboutScreen()));
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.share),
            title: Text('Share with your friends', style: _textStyle),
            onTap: () async {
              /// Share app
              // _appHelper.shareApp();
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.star),
            title: Text(
                (Platform.isAndroid
                    ? "rate_on_play_store"
                    : "rate_on_app_store"),
                style: _textStyle),
            onTap: () async {
              /// Rate app
              // _appHelper.reviewApp();
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Privacy Policy', style: _textStyle),
            onTap: () async {
              /// Go to privacy policy
              // _appHelper.openPrivacyPage();
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.copyright_outlined, color: Colors.grey),
            title: Text('Terms of Service', style: _textStyle),
            onTap: () async {
              /// Go to privacy policy
              // _appHelper.openTermsPage();
            },
          ),
        ],
      ),
    );
  }
}
