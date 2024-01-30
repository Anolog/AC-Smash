import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'AnimalCard.dart';
import 'AnimalData.dart';
import 'SpeechBlobs.dart';
import 'database/DatabaseHelper.dart';

class SwipeCardsPage extends StatefulWidget {
  @override
  _SwipeCardsPageState createState() => _SwipeCardsPageState();
}

class _SwipeCardsPageState extends State<SwipeCardsPage> {
  SharedPreferences? prefs;

  MatchEngine? _matchEngine;
  List<SwipeItem> _swipeItems = [];
  List<Map<String, dynamic>> _villagerData = [];
  int smashCount = 0;
  int passCount = 0;

  Future<void> _loadVillagerData() async {
    final jsonString = await rootBundle.loadString('assets/villager_data.json');
    final jsonData = json.decode(jsonString);
    setState(() {
      _villagerData = List<Map<String, dynamic>>.from(jsonData);
      _createSwipeItems();
    });

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
            name: data['Name'],
            id: data['Unique Entry ID'],
            animalImage: data['Name'] != 'Ankha'
                ? 'https://villagerdb.com/images/villagers/full/' +
                    data['Name'].toString().toLowerCase() +
                    '.png'
                : 'https://i.kym-cdn.com/photos/images/original/002/249/029/212.gif',
            backgroundImage:
                'https://i.pinimg.com/originals/4c/b9/ce/4cb9cee09c182385c16fc51c9e029a91.jpg',
            nameColor: hexToColor(data['Name Color']),
            nameContainerColor: hexToColor(data['Bubble Color']),
            birthday: data['Birthday'],
            favoriteSaying: data['Favorite Saying'],
            hobby: data['Hobby'],
          ),
        ),
      ));
    }
    // Initialize the _matchEngine once all items are created
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  Color hexToColor(String hexString) {
    if (hexString.length < 7) throw FormatException('Invalid HEX color.');

    if (hexString.length == 7) hexString = 'FF' + hexString.substring(1);

    return Color(int.parse(hexString, radix: 16));
  }

  void _swipeLeft() async {
    final SwipeItem? currentItem = _matchEngine?.currentItem;

    if (currentItem != null) {
      final AnimalCard currentCard = currentItem.content as AnimalCard;
      currentCard.animalData.smashValue = 'pass';
      await handleSwipe(currentCard.animalData);
      final int newPassCount = await DatabaseHelper().getPassCount();
      setState(() {
        passCount = newPassCount;
      });
    }
  }

  void _swipeRight() async {
    final SwipeItem? currentItem = _matchEngine?.currentItem;
    print("current item: $currentItem");
    if (currentItem != null) {
      final AnimalCard currentCard = currentItem.content as AnimalCard;
      currentCard.animalData.smashValue = 'smash';
      await handleSwipe(currentCard.animalData);
      final int newSmashCount = await DatabaseHelper().getSmashCount();
      setState(() {
        smashCount = newSmashCount;
      });
    }
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> handleSwipe(AnimalData animalData) async {
    await DatabaseHelper().insertAnimal(animalData);
    await DatabaseHelper().logAllSwipedData();
  }

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    _loadVillagerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
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
                    // Handle stack finished
                  },
                  itemChanged: (SwipeItem item, int index) {
                    // Handle item changed
                  },
                  upSwipeAllowed: false,
                  fillSpace: true,
                ),
              ),
            Padding(padding: const EdgeInsets.all(10)),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
