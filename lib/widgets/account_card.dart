import 'package:amp_studenthub/models/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AccountCard extends StatelessWidget {
  final String? imageUrl;
  final Account account;

  const AccountCard({
    Key? key,
    this.imageUrl,
    required this.account,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? imageUrl = this.imageUrl ?? 'assets/logo.png';
    return Padding(
      padding: const EdgeInsets.all(0),
      child: SizedBox(
        height: 100,
        child: Card(
          color: Color(0xFF3F72AF),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      width: 70,
                      height: 70,
                      image: AssetImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8, // Add spacing between image and text
                ),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        account.fullName,
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        account.type,
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
