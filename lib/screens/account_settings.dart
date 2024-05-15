import 'package:amp_studenthub/providers/language_provider.dart';
import 'package:amp_studenthub/providers/theme_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  List<String> localesOptions = ['en', 'vi'];
  Map<String, String> localeObj = {'en': 'English', 'vi': "Tiếng Việt"};

  String? selectedLocales = "en";

  @override
  Widget build(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          toolbarHeight: 56,
          title: Text(
            'StudentHub',
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold),
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
                      child: Text(
                        '${AppLocalizations.of(context)!.settings}:',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary),
                      )),
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.language,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  DropdownButtonFormField2<String>(
                    isExpanded: true,
                    value: languageProvider.appLocal.languageCode,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(top: 8, left: 8, right: 8),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 1)),
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
                      Provider.of<LanguageProvider>(context, listen: false)
                          .updateLanguage(Locale(value!));
                    },
                    iconStyleData: IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).colorScheme.tertiary,
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
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.theme,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  ToggleSwitch(
                    minWidth: MediaQuery.of(context).size.width * 0.75,
                    minHeight: 52.0,
                    initialLabelIndex:
                        themeProvider.mode == ThemeMode.dark ? 0 : 1,
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
                      if (index == 0) {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .setMode(ThemeMode.dark);
                      } else {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .setMode(ThemeMode.light);
                      }
                    },
                  ),
                ],
              )),
        ));
  }
}
