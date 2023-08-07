import 'package:beat_jerky/screens/auth_screen/login_screen.dart';
import 'package:beat_jerky/services/shared_preferences_Services/auth_preferences.dart';
import 'package:beat_jerky/utils/color.dart';
import 'package:beat_jerky/widget/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import '../services/api_services/user_services.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: blackColor,
          title: const Text('Settings'),
        ),
        body: SettingsList(
          darkTheme: const SettingsThemeData(
              settingsListBackground: blackColor,
              settingsSectionBackground: blackColor),
          sections: [
            SettingsSection(
              title: const ReusableText(
                title: 'Common',
                size: 16,
                weight: FontWeight.w700,
                color: whiteColor,
              ),
              tiles: [
                SettingsTile(
                  title: const ReusableText(
                    title: 'Language',
                    size: 16,
                    weight: FontWeight.w700,
                    color: whiteColor,
                  ),
                  leading: const Icon(Icons.language),
                  onPressed: (BuildContext context) {
                    // Handle the tile press
                  },
                ),
                SettingsTile(
                  title: const ReusableText(
                    title: 'Theme',
                    size: 16,
                    weight: FontWeight.w700,
                    color: whiteColor,
                  ),
                  leading: const Icon(Icons.color_lens),
                  onPressed: (BuildContext context) {
                    // Handle the tile press
                  },
                ),
              ],
            ),
            SettingsSection(
              title: const ReusableText(
                title: 'Account',
                size: 16,
                weight: FontWeight.w700,
                color: whiteColor,
              ),
              tiles: [
                SettingsTile(
                  title: const ReusableText(
                    title: 'Profile',
                    size: 16,
                    weight: FontWeight.w700,
                    color: whiteColor,
                  ),
                  leading: const Icon(Icons.person),
                  onPressed: (BuildContext context) {
                    // Handle the tile press
                  },
                ),
                SettingsTile(
                  title: const ReusableText(
                    title: 'Notifications',
                    size: 16,
                    weight: FontWeight.w700,
                    color: whiteColor,
                  ),
                  leading: const Icon(Icons.notifications),
                  onPressed: (BuildContext context) {
                    // Handle the tile press
                  },
                ),
                SettingsTile(
                  title: const ReusableText(
                    title: 'Sign Out',
                    size: 16,
                    weight: FontWeight.w700,
                    color: whiteColor,
                  ),
                  leading: const Icon(Icons.logout),
                  onPressed: (BuildContext context)async{
                    await UserServices().logoutUser(context);
                    await AuthPreferences().setAuthPreferences('', '');
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false);
                    // Handle the tile press
                  },
                ),
              ],
            ),
            SettingsSection(
              title: const ReusableText(
                title: 'Security',
                size: 16,
                weight: FontWeight.w700,
                color: whiteColor,
              ),
              tiles: [
                SettingsTile(
                  title: const ReusableText(
                    title: 'Change Password',
                    size: 16,
                    weight: FontWeight.w700,
                    color: whiteColor,
                  ),
                  leading: const Icon(Icons.lock),
                  onPressed: (BuildContext context) {
                    // Handle the tile press
                  },
                ),
                SettingsTile(
                  title: const ReusableText(
                    title: 'Two-Factor Authentication',
                    size: 16,
                    weight: FontWeight.w700,
                    color: whiteColor,
                  ),
                  leading: const Icon(Icons.verified_user),
                  onPressed: (BuildContext context) {
                    // Handle the tile press
                  },
                ),
              ],
            ),
          ],
        ));
  }
}
