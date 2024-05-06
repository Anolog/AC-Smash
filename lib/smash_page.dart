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
import 'database/DatabaseHelper.dart';
import 'StatsDialog.dart';
import 'WelcomeDialog.dart';

class SwipeCardsPage extends StatefulWidget {
  @override
  _SwipeCardsPageState createState() => _SwipeCardsPageState();
}

class _SwipeCardsPageState extends State<SwipeCardsPage> {
  SharedPreferences? _prefs;

  MatchEngine? _matchEngine;
  List<SwipeItem> _swipeItems = [];
  List<AnimalData> _villagerData = [];
  Map<String, String> _swipedVillagerData = {};
  AnimalData? _previousAnimalData;
  int _smashCount = 0;
  int _passCount = 0;

  int _currentIndex = 1;
  int _total = 0;
  bool _complete = false;
  bool _hasPlayedBruh = false;
  bool _hasPlayedFBI = false;

  Future<void> LoadVillagerData() async {
    // Fetch data from Firebase
    final Map<String, dynamic> firebaseData =
        await DatabaseHelper().GetFirebaseVillagerData();

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
          nameColor: HexToColor(data['Name Color']),
          nameContainerColor: HexToColor(data['Bubble Color']),
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
      CreateSwipeItems();
    });

    // Load smash and pass count from local storage
    _smashCount = await DatabaseHelper().GetSmashCount();
    _passCount = await DatabaseHelper().GetPassCount();
  }

  void CreateSwipeItems() {
    // Clear the existing _swipeItems list
    _swipeItems.clear();

    for (final data in _villagerData) {
      _swipeItems.add(SwipeItem(
        likeAction: () {
          SwipeRight();
        },
        nopeAction: () {
          SwipeLeft();
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
                data.nameColor == "" ? HexToColor("#4d2a20") : data.nameColor,
            nameContainerColor: data.nameContainerColor == ""
                ? HexToColor("#de8735")
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

  Color HexToColor(String pHexString) {
    if (pHexString.length == 0) {
      return HexToColor("#4d2a20");
    }
    if (pHexString.length < 7) {
      print('error hex: ' + pHexString);
      throw FormatException('Invalid HEX color.');
    }

    if (pHexString.length == 7) pHexString = 'FF' + pHexString.substring(1);

    return Color(int.parse(pHexString, radix: 16));
  }

  void SwipeLeft() async {
    final SwipeItem? currentItem = _matchEngine?.currentItem;

    if (currentItem != null) {
      final AnimalCard currentCard = currentItem.content as AnimalCard;
      currentCard.animalData.smashValue = 'pass';
      _swipedVillagerData[currentCard.animalData.animalImage] = 'pass';

      await handleSwipe(currentCard.animalData);
      final int newPassCount = await DatabaseHelper().GetPassCount();
      setState(() {
        _passCount = newPassCount;
      });

      _previousAnimalData = currentCard.animalData;
    }
  }

  void SwipeRight() async {
    final SwipeItem? currentItem = _matchEngine?.currentItem;
    if (currentItem != null) {
      final AnimalCard currentCard = currentItem.content as AnimalCard;
      currentCard.animalData.smashValue = 'smash';
      _swipedVillagerData[currentCard.animalData.animalImage] = 'smash';

      if (currentCard.animalData.name == 'Tommy' ||
          currentCard.animalData.name == 'Timmy') {
        if (_hasPlayedBruh == false) {
          SoundManager().PlaySoundOnce('Bruh');
          _hasPlayedBruh = true;
        } else {
          SoundManager().PlaySoundOnce('FBI');
          _hasPlayedFBI = true;
        }
      }
      //Could probably be a case instead of ifs, but here we are...
      if (currentCard.animalData.name == "Daisy Mae") {
        SoundManager().PlaySoundOnce('VineBoom');
      }

      if (currentCard.animalData.name == "Leila") {
        SoundManager().PlaySoundOnceVolumeAdjust('Ayo', 0.5);
      }

      if (currentCard.animalData.name == "Katie") {
        SoundManager().PlaySoundOnce('Shocked');
      }

      if (currentCard.animalData == "Ankha") {
        SoundManager().PlaySoundOnce('Rizz');
      }

      await handleSwipe(currentCard.animalData);
      final int newSmashCount = await DatabaseHelper().GetSmashCount();
      setState(() {
        _smashCount = newSmashCount;
      });

      _previousAnimalData = currentCard.animalData;
    }
  }

  Future<void> InitSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> handleSwipe(AnimalData animalData) async {
    await DatabaseHelper().InsertAnimal(animalData);
    //await DatabaseHelper().logAllSwipedData();
  }

  void ShowWelcomeDialog() {
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
    InitSharedPreferences();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowWelcomeDialog();
    });
    LoadVillagerData();
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
                        .PlaySoundOnceVolumeAdjust('Achievement', 0.7);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => StatsDialog(
                        pPassCount: _passCount,
                        pSmashCount: _smashCount,
                        pCompleted: _complete,
                        pVillagersSwiped: _swipedVillagerData,
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
                      "Pass ($_passCount)",
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
                      "Smash ($_smashCount)",
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
                        pPassCount: _passCount,
                        pSmashCount: _smashCount,
                        pCompleted: _complete,
                        pVillagersSwiped: _swipedVillagerData,
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
                          .GetVillagerCounts(_previousAnimalData!.id),
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
                          pVillagerName: _previousAnimalData?.name ?? "",
                          pImageURL: _previousAnimalData?.animalImage ?? "",
                          pSmashCount: smashCount,
                          pPassCount: passCount,
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
