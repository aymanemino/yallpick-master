import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AppUpdateService {
  static const String _lastUpdateCheckKey = 'last_update_check';
  static const String _updateDismissedKey = 'update_dismissed';
  static const Duration _checkInterval =
  Duration(hours: 24); // Check once per day

  // API endpoint - Update this with your actual domain
  static const String _apiBaseUrl =
      'https://yallapick.com/up/api/v1/app-update';
  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      print('🔍 App update check started...');

      // Check if we should check for updates
      if (!await _shouldCheckForUpdate()) {
        print('⏰ Update check skipped - too soon since last check');
        return;
      }

      print('📱 Checking for updates...');
      final updateInfo = await _checkForUpdates();

      if (updateInfo.canUpdate) {
        print(
            '✅ Update available: ${updateInfo.localVersion} -> ${updateInfo.storeVersion}');
        // Check if user has dismissed this update
        if (!await _isUpdateDismissed(updateInfo.storeVersion)) {
          print('🎯 Showing update dialog...');
          _showUpdateDialog(context, updateInfo);
        } else {
          print(
              '🚫 Update dialog dismissed for version ${updateInfo.storeVersion}');
        }
      } else {
        print('ℹ️ No update available or error occurred');
      }

      // Update last check time
      await _updateLastCheckTime();
      print('⏰ Last check time updated');
    } catch (e) {
      // Silently handle errors to avoid disrupting app startup
      print('❌ App update check failed: $e');
    }
  }

  // Blocking update check - shows dialog and waits for user action
  static Future<bool> checkForUpdateBlocking(BuildContext context) async {
    try {
      print('🔒 BLOCKING update check started...');

      final updateInfo = await _checkForUpdates();

      if (updateInfo.canUpdate) {
        print(
            '🚨 BLOCKING UPDATE REQUIRED: ${updateInfo.localVersion} -> ${updateInfo.storeVersion}');

        // Show blocking update dialog
        final result = await _showBlockingUpdateDialog(context, updateInfo);
        return result; // true if user chose to update, false if dismissed
      } else {
        print('✅ No blocking update required');
        return; // Allow app to proceed
      }
    } catch (e) {
      print('❌ Blocking update check failed: $e');
      return; // Allow app to proceed on error
    }
  }

  static Future<UpdateInfo> _checkForUpdates() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      print('📱 Current app version: $currentVersion');

      if (Platform.isAndroid) {
        print('🤖 Checking Android update...');
        return await _checkAndroidUpdate(currentVersion);
      } else if (Platform.isIOS) {
        print('🍎 Checking iOS update...');
        return await _checkIOSUpdate(currentVersion);
      }
    } catch (e) {
      print('❌ Error checking for updates: $e');
    }
    return null;
  }

  static Future<UpdateInfo> _checkAndroidUpdate(String currentVersion) async {
    try {
      final latestVersion = await _getLatestVersionFromServer();
      print(
          '🔍 Android update check: current=$currentVersion, latest=$latestVersion');

      if (latestVersion != null) {
        final comparison = _compareVersions(currentVersion, latestVersion);
        print('🔍 Version comparison result: $comparison');

        if (comparison < 0) {
          print('✅ Update needed: $currentVersion < $latestVersion');
          return UpdateInfo(
            localVersion: currentVersion,
            storeVersion: latestVersion,
            canUpdate: true,
            releaseNotes: 'Bug fixes and performance improvements',
          );
        } else {
          print('ℹ️ No update needed: $currentVersion >= $latestVersion');
        }
      } else {
        print('❌ No latest version received from API');
      }
    } catch (e) {
      print('❌ Error checking Android update: $e');
    }
    return null;
  }

  static Future<UpdateInfo> _checkIOSUpdate(String currentVersion) async {
    try {
      final latestVersion = await _getLatestVersionFromServer();
      if (_compareVersions(currentVersion, latestVersion) < 0) {
        return UpdateInfo(
          localVersion: currentVersion,
          storeVersion: latestVersion,
          canUpdate: true,
          releaseNotes: 'Bug fixes and performance improvements',
        );
      }
    } catch (e) {
      print('Error checking iOS update: $e');
    }
    return null;
  }

  static Future<String> _getLatestVersionFromServer() async {
    try {
      // Get current app info
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final packageId = packageInfo.packageName;
      print(
          '🌐 API call - Current version: $currentVersion, Package: $packageId');

      // Determine platform
      String platform;
      if (Platform.isAndroid) {
        platform = 'android';
      } else if (Platform.isIOS) {
        platform = 'ios';
      } else {
        return null;
      }

      // Make API call to your Laravel endpoint
      final url = '$_apiBaseUrl/check';
      print('🌐 Calling API: $url');
      print(
          '🌐 Request body: platform=$platform, version=$currentVersion, package_id=$packageId');

      final response = await http.post(
        Uri.parse(url),
        body: {
          'platform': platform,
          'version': currentVersion,
          'package_id': packageId,
        },
      );

      print('🌐 API Response status: ${response.statusCode}');
      print('🌐 API Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('🌐 API Response data: $data');

        if (data['success'] == true) {
          final latestVersion = data['data']['latest_version'];
          final canUpdate = data['data']['can_update'];
          print(
              '✅ API Response - Latest version: $latestVersion, Can update: $canUpdate');

          // Always return the latest version, let the app decide if update is needed
          return latestVersion;
        } else {
          print('❌ API success is false: ${data['success']}');
        }
      }

      // No fallback - return null if API fails
      print('🔄 No fallback version - API failed');
      return null;
    } catch (e) {
      print('❌ Error getting latest version from server: $e');
      // No fallback - return null if error occurs
      print('🔄 No fallback version due to error');
      return null;
    }
  }

  static int _compareVersions(String version1, String version2) {
    final v1Parts = version1.split('.').map(int.parse).toList();
    final v2Parts = version2.split('.').map(int.parse).toList();

    // Pad with zeros if needed
    while (v1Parts.length < v2Parts.length) v1Parts.add(0);
    while (v2Parts.length < v1Parts.length) v2Parts.add(0);

    for (int i = 0; i < v1Parts.length; i++) {
      if (v1Parts[i] < v2Parts[i]) return -1;
      if (v1Parts[i] > v2Parts[i]) return 1;
    }
    return 0;
  }

  static Future<bool> _shouldCheckForUpdate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastCheck = prefs.getInt(_lastUpdateCheckKey) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;

      // Check if enough time has passed since last check
      return (now - lastCheck) >= _checkInterval.inMilliseconds;
    } catch (e) {
      // If there's an error, allow the check to proceed
      return;
    }
  }

  static Future<void> _updateLastCheckTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
          _lastUpdateCheckKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Silently handle errors
    }
  }

  static Future<bool> _isUpdateDismissed(String storeVersion) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dismissedVersion = prefs.getString(_updateDismissedKey);
      return dismissedVersion == storeVersion;
    } catch (e) {
      return false;
    }
  }

  static Future<void> _dismissUpdate(String storeVersion) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_updateDismissedKey, storeVersion);
    } catch (e) {
      // Silently handle errors
    }
  }

  static void _showUpdateDialog(BuildContext context, UpdateInfo updateInfo) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.system_update,
                  color: Colors.blue,
                  size: 28,
                ),
                SizedBox(width: 10),
                Text(
                  'Update Available',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A new version of the app is available.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800]!!!,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Update now to get the latest features and improvements.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600]!!!,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await _dismissUpdate(updateInfo.storeVersion);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Later',
                  style: TextStyle(
                    color: Colors.grey[600]!!!,
                    fontSize: 16,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => _launchUpdate(),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  'Update Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Blocking update dialog - prevents app from proceeding
  static Future<bool> _showBlockingUpdateDialog(
      BuildContext context, UpdateInfo updateInfo) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false, // User cannot dismiss by tapping outside
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // User cannot go back
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.system_update,
                  color: Colors.orange,
                  size: 28,
                ),
                SizedBox(width: 10),
                Text(
                  'Update Required',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A new version of the app is available.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800]!!!,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Please update to continue using all features.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600]!!!,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  // Dismiss for this session only - will show again on next app launch
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'Later',
                  style: TextStyle(
                    color: Colors.grey[600]!!!,
                    fontSize: 16,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _launchUpdate();
                  Navigator.of(context).pop(true);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  'Update Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ) ??
        false;
  }

  static Widget _buildVersionInfo(String label, String version) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700]!!!,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue[200]),
          ),
          child: Text(
            version,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
            ),
          ),
        ),
      ],
    );
  }

  static Future<void> _launchUpdate() async {
    try {
      if (Platform.isAndroid) {
        // Launch Play Store
        const url =
            'https://play.google.com/store/apps/details?id=com.yalla.pick';
        if (await canLaunch(url)) {
          await launch(url);
        }
      } else if (Platform.isIOS) {
        // Launch App Store - Replace with your actual App Store ID
        const url = 'https://apps.apple.com/app/yallpick/id123456789';
        if (await canLaunch(url)) {
          await launch(url);
        }
      }
    } catch (e) {
      print('Failed to launch store: $e');
    }
  }

  // Method to manually check for updates (can be called from settings)
  static Future<void> manualUpdateCheck(BuildContext context) async {
    try {
      print('🔍 Manual update check started');
      final updateInfo = await _checkForUpdates();
      print(
          '🔍 UpdateInfo: ${updateInfo.localVersion} -> ${updateInfo.storeVersion}');
      if (updateInfo.canUpdate) {
        print(
            '🎯 Showing update dialog with: ${updateInfo.localVersion} -> ${updateInfo.storeVersion}');
        _showUpdateDialog(context, updateInfo);
      } else {
        print('ℹ️ No update available');
        _showNoUpdateDialog(context);
      }
    } catch (e) {
      print('❌ Error in manual update check: $e');
      _showErrorDialog(context, e.toString());
    }
  }

  static void _showNoUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Updates Available'),
          content: Text('You are using the latest version of the app.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Check Failed'),
          content: Text('Unable to check for updates: $error'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class UpdateInfo {
  final String localVersion;
  final String storeVersion;
  final bool canUpdate;
  final String releaseNotes;

  UpdateInfo({
    required this.localVersion,
    required this.storeVersion,
    required this.canUpdate,
    this.releaseNotes,
  });
}
