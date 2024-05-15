import 'package:awesome_notifications/awesome_notifications.dart';
import '../../components/birthday_card/birthday_card_listview.dart';
import '../../screens/birthday_add_page.dart';
import '../../screens/settings_page.dart';
import '../../utilities/app_data.dart';
import '../../utilities/constants.dart';
import '../../utilities/notification_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  String _searchQuery = '';
  int _selectedMonth = DateTime.now().month;

  void _runFilter(String name) {
    setState(() {
      _searchQuery = name;
    });
  }

  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then(
      (value) async {
        if (value) {
          addNotificationListener();
        } else if (await isFirstStartup()) {
          requestNotificationAccess(context);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.blackPrimary,
      appBar: appBar(),
      body: body(context),
    );
  }

  Center body(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 30),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                style: TextStyle(
                  color: Constants.whiteSecondary,
                ),
                onChanged: (value) => _runFilter(value),
                decoration: InputDecoration(
                  labelText: 'Search',
                  suffix: IconButton(
                    icon: Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                      });
                      // Call removeFilters method after resetting the search query and selected month
                      BirthdayCardListview(
                              searchQuery: _searchQuery,
                              selectedMonth: _selectedMonth)
                          .removeFilters();
                    },
                  ),
                ),
              ),
            ),
            DropdownButton<int>(
              value: _selectedMonth,
              onChanged: (int? value) {
                setState(() {
                  _selectedMonth = value!;
                });
              },
              items: List<DropdownMenuItem<int>>.generate(
                12,
                (int index) => DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text(_getMonthName(index + 1)),
                ),
              ),
            ),
            BirthdayCardListview(
                searchQuery: _searchQuery, selectedMonth: _selectedMonth),
            addBirthdayButton(context),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }

  AppBar appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Constants.blackPrimary,
      iconTheme: IconThemeData(
        color: Constants.whiteSecondary,
      ),
      title: Text(
        AppLocalizations.of(context)!.birthdays,
        style: const TextStyle(
          color: Constants.purpleSecondary,
          fontSize: Constants.titleFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        settingsButton(context),
      ],
    );
  }

  GestureDetector settingsButton(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        child: const Icon(
          Icons.settings,
          size: 30,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) {
            return const SettingsPage();
          },
        ));
      },
    );
  }

  Container addBirthdayButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0, bottom: 23.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Constants.whiteSecondary,
          backgroundColor: Constants.darkGreySecondary,
          fixedSize: const Size(90, 70),
          side: const BorderSide(color: Constants.greySecondary, width: 3),
          shape: const StadiumBorder(),
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Constants.whiteSecondary,
          size: 35,
        ),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return const AddBirthdayPage();
          })).then(
            (value) => setState(
              () {},
            ),
          );
        },
      ),
    );
  }
}
