import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/controller/room_controller.dart';
import 'package:monday/model/room_model.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/common/utils.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:monday/ui/components/category_buttons_row.dart';
import 'package:monday/ui/components/room_buttons_row_selection.dart';
import 'package:monday/ui/components/text_input_field.dart';
import 'package:monday/ui/home.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/common/r.dart';
import 'package:monday/common/r.dart';

const String _kFontFam = 'Monday';

class NewRoom extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new NewRoomState();
  }
}

class NewRoomState extends State<NewRoom> {

  //Constant values
  static const IconData right_arrow = const IconData(0xe80d, fontFamily: _kFontFam);
  static const IconData cameraIcon = const IconData(0xe810, fontFamily: _kFontFam);
  static const IconData galleryIcon = const IconData(0xe80f, fontFamily: _kFontFam);

  //Variables
  static File selectedRoomImagePath;

  //UI components
  static final nameController = TextEditingController();

  static var imagePaths = [
    'assets/images/livingroom.jpg',
    'assets/images/kitchen.jpg',
    'assets/images/bathroom.jpg',
    'assets/images/bedroom.jpg',
    'assets/images/hallway.jpg',
    'assets/images/wardrobe.jpg',
    'assets/images/tiny_bedroom.jpg',
    'assets/images/garage.jpg',
    'assets/images/terrace.jpg',
    'assets/images/study.jpg',
    'assets/images/washing_room.jpg',
    'assets/images/attic.jpg',
    'assets/images/cellar.jpg',
  ];

  static Widget drawer;

  @override
  Widget build(BuildContext context) {

    List<RoomModel> rooms = createRoomObjects(imagePaths);
    Widget roomButtonsRow = new RoomButtonsRowSelection(rooms, false);

    Widget roomNameField = new TextInputField(R.of(context).newRoomName, nameController, false, true);

    Widget categorySelectionText = Utils.createTextRow(
     R.of(context).newRoomCategorySelection, 10, 10);

    //Static lists of strings
    List<String> categoryItems = [R.of(context).roomTypeLiving,
                                  R.of(context).roomTypeKitchen,
                                  R.of(context).roomTypeBedroom,
                                  R.of(context).roomTypeBathroom,
                                  R.of(context).roomTypeTiny,
                                  R.of(context).roomTypeCloset,
                                  R.of(context).roomTypeHallway,
                                  R.of(context).roomTypeTerrace,
                                  R.of(context).roomTypeStudy,
                                  R.of(context).roomTypeWashing,
                                  R.of(context).roomTypeAttic,
                                  R.of(context).roomTypeGarage,
                                  R.of(context).roomTypeCellar,
                                  R.of(context).roomTypeOther];
    Widget categoryRow = new CategoryButtonsRow(categoryItems);

    Widget roomsTitleText = Utils.createTextRow(
      R.of(context).newRoomPicSelection, 20, 10);

    Widget orText = Utils.createTextRow(R.of(context).newRoomOr, 20, 10);

    //App bar widget
    final Widget appBar = new AppBar(
      title: new Text(R.of(context).newRoomTitle),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );

    //Pick an image from gallery
    imageSelectorGallery() async {
      selectedRoomImagePath = await ImagePicker.pickImage(
        source: ImageSource.gallery,
      );
      print("You selected gallery image : " + selectedRoomImagePath.path);
      imagePaths.add(selectedRoomImagePath.path);
      moveItemAtIndexToFront(imagePaths, imagePaths.length-1);
      setState(() {
      });
    }

    //Shoot a pic by camera
    imageSelectorCamera() async {
      selectedRoomImagePath = await ImagePicker.pickImage(
        source: ImageSource.camera,
        //maxHeight: 50.0,
        //maxWidth: 50.0,
      );
      print("You selected camera image : " + selectedRoomImagePath.path);
      imagePaths.add(selectedRoomImagePath.path);
      moveItemAtIndexToFront(imagePaths, imagePaths.length-1);
      setState(() {
      });
    }

    Widget body = Container(
      child: ListView(
        children: [
          Container(
            height:10,
          ),
          roomNameField,
          Container(
            height: 15,
          ),
          categorySelectionText,
          categoryRow,
          roomsTitleText,
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container (
                  padding: EdgeInsets.only (right: 20),
                  child: IconButton(
                    onPressed: imageSelectorGallery,
                    //padding: const EdgeInsets.only(top:50),
                    icon: Icon(
                      galleryIcon,
                      color: Colors.grey[200],
                      size: 40,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: imageSelectorCamera,
                  //padding: const EdgeInsets.only(right:50),
                  icon: Icon(
                    cameraIcon,
                    color: Colors.grey[200],
                    size: 40,
                  ),
                ),
              ]
            ),
          ),
          orText,
          roomButtonsRow,
          Container(
            height: 20,
          ),
          IconButton(//button for sending data to Monday
            onPressed: () async {
              String roomName = nameController.text;
              nameController.text = "";//refresh text of name controller
              if(!Utils.validateInputText(roomName))
                Utils.showDialogPanel(R.of(context).warningMsg,
                    R.of(context).textInputWrongChars, context);
              else {
                String roomCategory = Utils.roomCategory;
                String roomButtonImgPath = Utils.roomButtonImgPath;
                if (await RoomController.sendNewRoomData(context, roomName,
                    roomCategory, roomButtonImgPath)) {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) =>
                      Home()));
                }
                /*print("Room name: " + roomName);
              print("Room category: " + roomCategory);
              print("Room button img path: "+roomButtonImgPath);*/
              //Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
              }
            },
            //padding: const EdgeInsets.only(top:50),
            icon: Icon(
              Monday.ok_1,
              color: Colors.grey[200],
              size: 45,
            ),
          ),
        ],
      ),
    );
    return new BasicRouteStructure(appBar, body, drawer);
  }

  //Methods

  /*
  This method moves the last element of the list to the first position.
  It's used to show the last inserted room button (when you pick a picture or
  you shoot a new picture) at the beginning of the list of room buttons
   */
  static void moveItemAtIndexToFront<T>(List<T> list, int index) {
    T item = list[index];
    for (int i = index; i > 0; i--)
        list[i] = list[i - 1];
    list[0] = item;
  }

  /*
  This method creates room objects from buttons image paths
   */
  List<RoomModel> createRoomObjects(List<String> imgPaths){
    List<RoomModel> rooms = List();
    imgPaths.forEach((item){
      RoomModel room = new RoomModel();
      room.imgPath = item;
      rooms.add(room);
    });
    return rooms;
  }
}