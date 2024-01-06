import 'package:flutter/material.dart';
import 'package:halifax_dating/widgets/default_card_border.dart';

class ProfileStatisticsCard extends StatelessWidget {
  // Text style
  final _textStyle = const TextStyle(
    color: Colors.redAccent ,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );

  const ProfileStatisticsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Initialization

    return Card(
      elevation: 4.0,
      color: Colors.grey[100],
      shape: defaultCardBorder(),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(("LIKES"), style: _textStyle),
            trailing: _counter(context, 3),
            onTap: () {
              /// Go to profile likes screen
              // Navigator.of(context).push(
              //     MaterialPageRoute(
              //         builder: (context) => const ProfileLikesScreen()));
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(("VISITS"), style: _textStyle),
            trailing: _counter(context, 3),
            onTap: () {
              /// Go to profile visits screen
              // Navigator.of(context).push(
              //     MaterialPageRoute(
              //         builder: (context) => const ProfileVisitsScreen()));
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(("DISLIKED_PROFILES"), style: _textStyle),
            trailing: _counter(context, 3),
            onTap: () {
              /// Go to disliked profile screen
              // Navigator.of(context).push(
              //     MaterialPageRoute(
              //         builder: (context) => const DislikedProfilesScreen()));
            },
          ),
        ],
      ),
    );
  }

  Widget _counter(BuildContext context, int value) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor, //.withAlpha(85),
            shape: BoxShape.circle),
        padding: const EdgeInsets.all(6.0),
        child: Text(value.toString(),
            style: const TextStyle(color: Colors.white)));
  }
}
