import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AccountCard extends StatelessWidget {
  final String? imageUrl;
  final Account account;

  const AccountCard({
    super.key,
    this.imageUrl,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    String? imageUrl = this.imageUrl ?? 'assets/logo.png';
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Card(
        color: Constant.primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              SizedBox(
                height: 52,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image(
                    width: 52,
                    height: 52,
                    image: AssetImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 16, // Add spacing between image and text
              ),
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      account.fullName,
                      style: const TextStyle(color: Constant.onPrimaryColor),
                    ),
                    Text(
                      account.type,
                      style: const TextStyle(color: Constant.onPrimaryColor),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
