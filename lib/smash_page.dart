import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'AnimalCard.dart';
import 'SpeechBlobs.dart';

class SwipeCardsPage extends StatefulWidget {
  @override
  _SwipeCardsPageState createState() => _SwipeCardsPageState();
}

class _SwipeCardsPageState extends State<SwipeCardsPage> {
  MatchEngine? _matchEngine;
  List<SwipeItem> _swipeItems = [];
  List<Map<String, dynamic>> _villagerData = [];

  Future<void> _loadVillagerData() async {
    final jsonString = await rootBundle.loadString('assets/villager_data.json');
    final jsonData = json.decode(jsonString);
    setState(() {
      _villagerData = List<Map<String, dynamic>>.from(jsonData);
      _createSwipeItems();
    });
  }

  void _createSwipeItems() {
    // Clear the existing _swipeItems list
    _swipeItems.clear();

    for (final data in _villagerData) {
      _swipeItems.add(
        SwipeItem(
          content: AnimalCard(
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
          likeAction: () {
            // Handle like action
          },
          nopeAction: () {
            // Handle nope action
          },
          onSlideUpdate: (SlideRegion? region) async {
            print("Region $region");
          },
        ),
      );
    }
    // Initialize the _matchEngine once all items are created
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  Color hexToColor(String hexString) {
    if (hexString.length < 7) throw FormatException('Invalid HEX color.');

    if (hexString.length == 7) hexString = 'FF' + hexString.substring(1);

    return Color(int.parse(hexString, radix: 16));
  }

  void _swipeLeft() {
    _matchEngine?.currentItem?.nope(); // Trigger left swipe (No)
  }

  void _swipeRight() {
    _matchEngine?.currentItem?.like(); // Trigger right swipe (Yes)
  }

  @override
  void initState() {
    super.initState();
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
                  upSwipeAllowed: true,
                  fillSpace: true,
                ),
              ),
            Padding(padding: const EdgeInsets.all(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _swipeLeft,
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
                      "Pass",
                      style: TextStyle(fontSize: 26.0),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: _swipeRight,
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
                      "Smash",
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
