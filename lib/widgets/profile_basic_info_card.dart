import 'package:flutter/material.dart';
import 'package:halifax_dating/screens/edit_profile_screen.dart';
import 'package:halifax_dating/widgets/default_card_border.dart';

class ProfileBasicInfoCard extends StatelessWidget {
  final String userName;
  final String userPhotoUrl;

  const ProfileBasicInfoCard({
    Key? key,
    required this.userName,
    required this.userPhotoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ScrollPhysics(),
      child: Card(
        color: Theme.of(context).primaryColor,
        elevation: 4.0,
        shape: defaultCardBorder(),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width - 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    padding: const EdgeInsets.all(3.0),
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 40,
                      backgroundImage: NetworkImage(userPhotoUrl),
                      onBackgroundImageError: (e, s) =>
                          {debugPrint(e.toString())},
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
              //   ],
              // ),
              const SizedBox(height: 10),

              /// Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 30,
                    child: OutlinedButton.icon(
                        icon: const Icon(Icons.remove_red_eye,
                            color: Colors.white),
                        label: Text('View',
                            style: const TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                            side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(color: Colors.white)),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ))),
                        onPressed: () {
                          /// Go to profile screen
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => ProfileScreen(
                          //         user: UserModel().user, showButtons: false)));
                        }),
                  ),
                  SizedBox(
                    height: 35,
                    child: TextButton.icon(
                        icon: Icon(Icons.edit,
                            color: Theme.of(context).primaryColor),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ))),
                        label: Text('Edit',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),
                        onPressed: () {
                          /// Go to edit profile screen
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const EditProfileScreen()));
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
