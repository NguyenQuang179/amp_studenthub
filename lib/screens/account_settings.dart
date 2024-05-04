import 'package:amp_studenthub/configs/constant.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  List<String> localesOptions = ['en', 'vi'];
  Map<String, String> localeObj = {'en': 'English', 'vi': "Vietnamese"};

  String? selectedLocales = "en";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constant.backgroundColor,
          toolbarHeight: 56,
          title: const Text(
            'StudentHub',
            style: TextStyle(
                color: Constant.primaryColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              child: Column(
                children: [
                  // Title
                  Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: const Text(
                        "Settings:",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Constant.primaryColor),
                      )),
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: const Row(
                      children: [
                        Text(
                          'Language:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  DropdownButtonFormField2<String>(
                    isExpanded: true,
                    value: selectedLocales,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(top: 8, left: 8, right: 8),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Constant.primaryColor, width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Constant.primaryColor, width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Constant.secondaryColor, width: 1)),
                      labelStyle: TextStyle(color: Colors.grey[600]),
                    ),
                    hint: const Text(
                      'Select Your Language',
                      style: TextStyle(fontSize: 14),
                    ),
                    items: localesOptions
                        .map((locale) => DropdownMenuItem<String>(
                              value: locale,
                              child: Text(
                                localeObj[locale] ?? "Unknown",
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a techstack';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      //Do something when selected item is changed.
                      setState(() {
                        selectedLocales = value;
                      });
                    },
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16, bottom: 8),
                    child: const Row(
                      children: [
                        Text(
                          'Theme:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  ToggleSwitch(
                    minWidth: MediaQuery.of(context).size.width * 0.75,
                    minHeight: 52.0,
                    initialLabelIndex: 0,
                    cornerRadius: 30.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    totalSwitches: 2,
                    icons: const [
                      FontAwesomeIcons.lightbulb,
                      FontAwesomeIcons.solidLightbulb,
                    ],
                    iconSize: 20.0,
                    activeBgColors: const [
                      [Colors.black45, Colors.black26],
                      [Colors.yellow, Colors.orange]
                    ],

                    // animate:
                    //     true, // with just animate set to true, default curve = Curves.easeIn
                    // curve: Curves
                    //     .linear, // animate must be set to true when using custom curve
                    onToggle: (index) {
                      print('switched to: $index');
                    },
                  ),
                ],
              )),
        ));
  }
}
