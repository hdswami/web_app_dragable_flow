import 'package:flutter/material.dart';
import 'package:flutter_user_profile_app/user_shared_preferences.dart';
import 'package:flutter_user_profile_app/utils/seats_mapper.dart';

class MobileBody extends StatefulWidget {
  const MobileBody({Key? key}) : super(key: key);

  @override
  State<MobileBody> createState() => _MobileBodyState();
}

class _MobileBodyState extends State<MobileBody> {
  Future<bool?> _displayTextInputDialog(BuildContext context) async {
    TextEditingController textFieldController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Booth number'),
          content: TextField(
            controller: textFieldController,
            decoration: const InputDecoration(hintText: "type your choice"),
          ),
          actions: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.cancel),
              label: const Text("Dismiss"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text("Proceed"),
              onPressed: () {
                if (textFieldController.text.trim().isNotEmpty) {
                  SeatMapper.singleton.seats.add(Seat(
                      textFieldController.text.trim(),
                      SeatMapper.defaultOffsetMobile,
                      SeatMapper.defaultOffset.dx - 200,
                      SeatMapper.defaultOffset.dy - 90));
                  Navigator.pop(context, true);
                } else {
                  Navigator.pop(context, false);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> restoredItems() async {
    await SeatMapper.singleton.restore();
    debugPrint('restoredItems ::: ${SeatMapper.singleton.seats.length}');
    setState(() {});
  }

  @override
  initState() {
    restoredItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                _displayTextInputDialog(context).then((value) {
                  if (value != null && value == true) {
                    setState(() {});
                  }
                });
              },
              icon: const Icon(
                Icons.chair_alt,
                color: Colors.orange,
                size: 40,
              ))
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: getChildren(constraints),
          );
        },
      ),
    );
  }

  List<Widget> getChildren(BoxConstraints constraints) {
    debugPrint(
        'getChildren restoredItems ::: ${SeatMapper.singleton.seats.length}');

    List<Widget> children = [];
    children.add(Center(
      child: Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        height: 480,
        width: 640,
        child: Image.network(
          "https://www.eventsgram.in/images/event-img/9531685361473l.jpeg",
          fit: BoxFit.cover,
        ),
      ),
    ));
    for (var element in SeatMapper.singleton.seats) {
      debugPrint('${element.toJson()}');
      children.add(
        Positioned(
          key: Key('${element.seatNo}'),
          left: element.offset?.dx ?? 0,
          top: element.offset?.dy ?? 0,
          child: LongPressDraggable(
            feedback: const Icon(
              Icons.chair,
              color: Colors.orange,
              size: 18,
            ),
            child: Stack(alignment: Alignment.center, children: <Widget>[
              const Icon(Icons.chair, color: Colors.green, size: 18),
              Text(
                "${element.seatNo}",
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0),
              ),
            ]),
            onDragEnd: (details) {
              setState(() {
                final adjustment =
                    MediaQuery.of(context).size.height - constraints.maxHeight;
                element.offset =
                    Offset(details.offset.dx, details.offset.dy - adjustment);
                SeatMapper.singleton.seats
                    .firstWhere((findSeat) => findSeat.seatNo == element.seatNo)
                    .offset = element.offset;

                UserSharedPreferences.saveSeatState(SeatMapper.singleton.seats);
              });
            },
          ),
        ),
      );
    }
    return children;
  }
}
