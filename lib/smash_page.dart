import 'dart:convert';
import 'dart:math';
import 'package:ac_smash/SoundManager.dart';
import 'package:ac_smash/VillagerFeedbackWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'AnimalCard.dart';
import 'AnimalData.dart';
import 'SpeechBlobs.dart';
import 'database/DatabaseHelper.dart';
import 'StatsDialog.dart';
import 'WelcomeDialog.dart';

class SwipeCardsPage extends StatefulWidget {
  @override
  _SwipeCardsPageState createState() => _SwipeCardsPageState();
}

class _SwipeCardsPageState extends State<SwipeCardsPage> {
  SharedPreferences? prefs;

  MatchEngine? _matchEngine;
  List<SwipeItem> _swipeItems = [];
  List<AnimalData> _villagerData = [];
  Map<String, String> _swipedVillagerData = {};
  AnimalData? _previousAnimalData;
  int smashCount = 0;
  int passCount = 0;

  int _currentIndex = 1;
  int _total = 0;
  bool _complete = false;
  bool _hasPlayedBruh = false;
  bool _hasPlayedFBI = false;

  Future<void> _loadVillagerData() async {
    // Fetch data from Firebase
    final Map<String, dynamic> firebaseData =
        await DatabaseHelper().getFirebaseVillagerData();

    // Convert Firebase data to AnimalData objects
    List<AnimalData> animalDataList = [];

    firebaseData.entries.forEach((entry) {
      String id = entry.key;
      Map<String, dynamic> data = entry.value;

      // Check if all required fields are present and not null
      if (data['Name'] != null &&
          data['Icon Image'] != null &&
          data['Name Color'] != null &&
          data['Bubble Color'] != null &&
          data['Birthday'] != null &&
          data['Favorite Saying'] != null &&
          data['Hobby'] != null) {
        AnimalData animalData = AnimalData(
          name: data['Name'],
          id: id,
          animalImage: data['Icon Image'],
          backgroundImage: "assets/images/AC-Background.png",
          nameColor: hexToColor(data['Name Color']),
          nameContainerColor: hexToColor(data['Bubble Color']),
          birthday: data['Birthday'],
          favoriteSaying: data['Favorite Saying'],
          hobby: data['Hobby'],
        );
        animalDataList.add(animalData);
      } else {
        // Handle missing or null values if needed
        print('Missing or null value for villager with ID: $id');
      }
    });

    setState(() {
      _villagerData = animalDataList;
      _createSwipeItems();
    });

    // Load smash and pass count from local storage
    smashCount = await DatabaseHelper().getSmashCount();
    passCount = await DatabaseHelper().getPassCount();
  }

  void _createSwipeItems() {
    // Clear the existing _swipeItems list
    _swipeItems.clear();

    for (final data in _villagerData) {
      _swipeItems.add(SwipeItem(
        likeAction: () {
          _swipeRight();
        },
        nopeAction: () {
          _swipeLeft();
        },
        onSlideUpdate: (SlideRegion? region) async {},
        content: AnimalCard(
          animalData: AnimalData(
            name: data.name,
            id: data.id,
            animalImage: data.name != 'Ankha'
                ? data.animalImage
                : 'https://i.kym-cdn.com/photos/images/original/002/249/029/212.gif',
            backgroundImage:
                'https://i.pinimg.com/originals/4c/b9/ce/4cb9cee09c182385c16fc51c9e029a91.jpg',
            nameColor:
                data.nameColor == "" ? hexToColor("#4d2a20") : data.nameColor,
            nameContainerColor: data.nameContainerColor == ""
                ? hexToColor("#de8735")
                : data.nameContainerColor,
            birthday: data.birthday,
            favoriteSaying: data.favoriteSaying,
            hobby: data.hobby,
          ),
        ),
      ));
    }

    _swipeItems.shuffle(Random());
    _total = _swipeItems.length;

    // Initialize the _matchEngine once all items are created
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  Color hexToColor(String hexString) {
    if (hexString.length == 0) {
      return hexToColor("#4d2a20");
    }
    if (hexString.length < 7) {
      print('error hex: ' + hexString);
      throw FormatException('Invalid HEX color.');
    }

    if (hexString.length == 7) hexString = 'FF' + hexString.substring(1);

    return Color(int.parse(hexString, radix: 16));
  }

  void _swipeLeft() async {
    final SwipeItem? currentItem = _matchEngine?.currentItem;

    if (currentItem != null) {
      final AnimalCard currentCard = currentItem.content as AnimalCard;
      currentCard.animalData.smashValue = 'pass';
      _swipedVillagerData[currentCard.animalData.animalImage] = 'pass';

      await handleSwipe(currentCard.animalData);
      final int newPassCount = await DatabaseHelper().getPassCount();
      setState(() {
        passCount = newPassCount;
      });

      _previousAnimalData = currentCard.animalData;
    }
  }

  void _swipeRight() async {
    final SwipeItem? currentItem = _matchEngine?.currentItem;
    if (currentItem != null) {
      final AnimalCard currentCard = currentItem.content as AnimalCard;
      currentCard.animalData.smashValue = 'smash';
      _swipedVillagerData[currentCard.animalData.animalImage] = 'smash';

      if (currentCard.animalData.name == 'Tommy' ||
          currentCard.animalData.name == 'Timmy') {
        if (_hasPlayedBruh == false) {
          SoundManager().playSoundOnce('Bruh');
          _hasPlayedBruh = true;
        } else {
          SoundManager().playSoundOnce('FBI');
          _hasPlayedFBI = true;
        }
      }

      if (currentCard.animalData.name == "Daisy Mae") {
        SoundManager().playSoundOnce('VineBoom');
      }

      if (currentCard.animalData.name == "Leila") {
        SoundManager().playSoundOnceVolumeAdjust('Ayo', 2.5);
      }

      if (currentCard.animalData.name == "Katie") {
        SoundManager().playSoundOnce('Shocked');
      }

      if (currentCard.animalData == "Ankha") {
        SoundManager().playSoundOnce('Rizz');
      }

      await handleSwipe(currentCard.animalData);
      final int newSmashCount = await DatabaseHelper().getSmashCount();
      setState(() {
        smashCount = newSmashCount;
      });

      _previousAnimalData = currentCard.animalData;
    }
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> handleSwipe(AnimalData animalData) async {
    await DatabaseHelper().insertAnimal(animalData);
    //await DatabaseHelper().logAllSwipedData();
  }

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WelcomeDialog();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    SoundManager().playSoundOnceVolumeAdjust('MainTheme', 0.7);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomeDialog();
    });
    _loadVillagerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 29, 29, 29),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10),
            if (_matchEngine !=
                null) // Conditionally build SwipeCards only if _matchEngine is not null
              Container(
                height: 650,
                width: 550,
                child: SwipeCards(
                  likeTag: Stack(
                    children: [
                      // Outline Text
                      Text(
                        'Smash',
                        style: TextStyle(
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6
                            ..color = Colors.black,
                        ),
                      ),
                      // Inner Text
                      Text(
                        'Smash',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  nopeTag: Stack(
                    children: [
                      // Outline Text
                      Text(
                        'Pass',
                        style: TextStyle(
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6
                            ..color = Colors.black,
                        ),
                      ),
                      // Inner Text
                      Text(
                        'Pass',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  matchEngine: _matchEngine!,
                  itemBuilder: (BuildContext context, int index) {
                    return _swipeItems[index].content;
                  },
                  onStackFinished: () {
                    _complete = true;
                    SoundManager()
                        .playSoundOnceVolumeAdjust('Achievement', 0.7);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => StatsDialog(
                        passCount: passCount,
                        smashCount: smashCount,
                        completed: _complete,
                        villagersSwiped: _swipedVillagerData,
                      ),
                    );
                  },
                  itemChanged: (SwipeItem item, int index) {
                    setState(() {
                      _currentIndex = index + 1;
                    });
                  },
                  upSwipeAllowed: false,
                  fillSpace: true,
                ),
              ),
            Padding(padding: const EdgeInsets.all(10)),
            Text('$_currentIndex out of $_total',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _matchEngine?.currentItem?.nope(),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    primary: Color.fromRGBO(0, 199, 165, 1.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    child: Text(
                      "Pass ($passCount)",
                      style: TextStyle(fontSize: 26.0),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () => _matchEngine?.currentItem?.like(),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    primary: Color.fromRGBO(0, 199, 165, 1.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    child: Text(
                      "Smash ($smashCount)",
                      style: TextStyle(fontSize: 26.0),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => StatsDialog(
                        passCount: passCount,
                        smashCount: smashCount,
                        completed: _complete,
                        villagersSwiped: _swipedVillagerData,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    primary: Color.fromRGBO(0, 199, 165, 1.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    child: Text("Show Stats", style: TextStyle(fontSize: 26.0)),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: _previousAnimalData != null ? 20 : 0,
              child: _previousAnimalData != null
                  ? FutureBuilder<Map<String, dynamic>>(
                      future: DatabaseHelper()
                          .getVillagerCounts(_previousAnimalData!.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Show a loading indicator while fetching data
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        // Convert dynamic values to int
                        int smashCount =
                            (snapshot.data?['smashCount'] ?? 0) as int;
                        int passCount =
                            (snapshot.data?['passCount'] ?? 0) as int;
                        return VillagerFeedbackWidget(
                          villagerName: _previousAnimalData?.name ?? "",
                          imageURL: _previousAnimalData?.animalImage ?? "",
                          smashCount: smashCount,
                          passCount: passCount,
                        );
                      },
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
