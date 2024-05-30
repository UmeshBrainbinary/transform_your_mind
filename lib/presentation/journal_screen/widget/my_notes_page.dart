import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:transform_your_mind/core/common_widget/custom_tab_bar.dart';
import 'package:transform_your_mind/core/common_widget/lottie_icon_button.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/common_widget/tab_text.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_notes_page.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/folder_descrptions.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/my_folders_note.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';


class MyNotesPage extends StatefulWidget {
  const MyNotesPage({
    Key? key,
  }) : super(key: key);
  static const myNotes = '/myNotes';

  @override
  State<MyNotesPage> createState() => _MyNotesPageState();
}

class _MyNotesPageState extends State<MyNotesPage>
    with TickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();

  int pageNumber = 1;
  int totalItemCountOfNotes = 0;
  Timer? _debounce;
  int itemIndexToRemove = -1;
  ScrollController scrollController = ScrollController();

  //Drafts
  int pageNumberDrafts = 1;

  int totalItemCountOfNotesDrafts = 0;

  List notesDraftList = [];

  ValueNotifier<bool> isTutorialVideoVisible = ValueNotifier(false);
  int noteAddedCount = 0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
 /*   _notesBloc.add(
      GetFolderEvent(),
    );*/
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
/*    noteAddedCount = SharedPrefUtils.getValue(
      SharedPrefUtilsKeys.noteAddedCount,
      0,
    );*/
    isTutorialVideoVisible.value = (noteAddedCount < 3);
    if (isTutorialVideoVisible.value) {
      _controller.forward();
    }
/*    tutorialVideoData = TutorialVideoData();
    BlocProvider.of<DashboardBloc>(context)
        .tutorialVideoData
        ?.forEach((element) {
      if (element.contentType == TutorialContentType.notes.value) {
        tutorialVideoData = element;
      }
    });

    SharedPrefUtils.setValue(
      SharedPrefUtilsKeys.goalAddedCount,
      noteAddedCount + 1,
    );*/
    _tabController = TabController(length: Dimens.d2.toInt(), vsync: this);
    _tabControllerFolder =
        TabController(length: Dimens.d2.toInt(), vsync: this);
/*    _notesBloc.add(
      GetMyNotesEvent(
        paginationRequest: PaginationRequest(
          page: pageNumber,
          perPage: Dimens.d10.toInt(),
          isSaved: true,
        ),
      ),
    );*/
  }

/*  Future<void> getFoldersApi() async {
    getFolderModel = GetFolderModel();

    getFolderModel = await getFolders();
    setState(() {});
    debugPrint("folders name $getFolderModel");
  }*/

/*
  getFolders() async {
    final LocalService local = sl<LocalService>();

    var headers = {
      'Authorization': 'Bearer ${local.getLogInfo()?.accessToken ?? ""}',
      'devicetype': '1',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('GET', Uri.parse('${Apis.baseUrl}/folder?folderType=5'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      // Parse the response body JSON

      // Convert the parsed JSON into a voiceRecordingModel object
      return getFolderModelFromJson(responseBody);
    } else {
      print(response.reasonPhrase);
    }
  }
*/

  createFolders({String? text}) async {

   // final LocalService local = sl<LocalService>();

  /*  var headers = {
      'Authorization': 'Bearer ${local.getLogInfo()?.accessToken ?? ""}',
      'devicetype': '1',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('${Apis.baseUrl}/folder'));
    request.headers.addAll(headers);
    request.body = json.encode({"folderId": "", "name": text, "folderType": 5});
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      // Parse the response body JSON
      showSnackBarSuccess(context, "New folder added successfully" ?? "");

      // Convert the parsed JSON into a voiceRecordingModel object
      return createFolderModelFromJson(responseBody);
    } else {
      print(response.reasonPhrase);
    }*/
  }

  deleteFolders({String? id , int? index}) async {
   getFolderData.removeAt(index!);
   setState(() {
     
   });
 /*   var headers = {
      'Authorization': 'Bearer ${local.getLogInfo()?.accessToken ?? ""}',
      'devicetype': '1',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'DELETE', Uri.parse('${Apis.baseUrl}/folder?folderId=$id'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      showSnackBarSuccess(context, "Delete Folder Success" ?? "");
    } else {
      debugPrint(response.reasonPhrase);
    }*/
  }

  editApi({String? id, String? text}) async {
    await editFolders(id: id, text: text);
   /* _notesBloc.add(
      GetFolderEvent(),
    );*/
  }

  editFolders({String? id, String? text}) async {
/*    final LocalService local = sl<LocalService>();

    var headers = {
      'Authorization': 'Bearer ${local.getLogInfo()?.accessToken ?? ""}',
      'devicetype': '1',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('${Apis.baseUrl}/folder'));
    request.headers.addAll(headers);
    request.body = json.encode({"folderId": id, "name": text, "folderType": 5});
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      showSnackBarSuccess(context, "Edit Folder Success" ?? "");

      // Convert the parsed JSON into a voiceRecordingModel object
      return createFolderModelFromJson(responseBody);
    } else {
      print(response.reasonPhrase);
    }*/
  }

  TextEditingController ser = TextEditingController();
  TextEditingController enterFolderName = TextEditingController();
  TextEditingController renameFolderController = TextEditingController();
  String? _selectedOption;

  Future<void> createFolder() async {
    await createFolders(text: enterFolderName.text);
   /* _notesBloc.add(
      GetFolderEvent(),
    );*/
    getFolderData.add({"name":enterFolderName.text,"id":"","counts":""});
    setState(() {});
    Navigator.of(context).pop();
  }

  deleteFolderApi({
    int? index,
  }) async {
    await deleteFolders(id: getFolderData[index!]["id"],index: index);
  /*  _notesBloc.add(
      GetFolderEvent(),
    );*/
  }

  List  getFolderData = [];
  List filteredData = [];
  List originalData = [];
  List  notesList = [];
  List  notesListFilterList = [];

  void filterSearchResults(String query) {
    List searchResult = [];
    if (query.isNotEmpty) {
      searchResult = originalData
          .where(
              (item) => item.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      searchResult = originalData;
    }
    setState(() {
      filteredData = searchResult;
    });
  }

  void filterNotesSearchResults(String query) {
    List searchResult = [];
    if (query.isNotEmpty) {
      searchResult = notesList
          .where(
              (item) => item.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      searchResult = notesList;
    }
    setState(() {
      notesListFilterList = searchResult;
    });
  }

  late TabController _tabController;
  late TabController _tabControllerFolder;
  int _currentTabIndex = Dimens.d0.toInt();
  int _currentTabIndexFolder = Dimens.d0.toInt();
  bool recentJournal = false;
  bool getListOpen = false;
  String folderName = "Select Folder";
  String folderId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: getFolderData != null
            ? getFolderData!.isNotEmpty
            ? _currentTabIndex == 0
            ? GestureDetector(
            onTap: () {
              setState(() {
                enterFolderName.clear();
              });
              folderAdd();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                ImageConstant.folderIcon,
                height: 30,
                width: 30,
              ),
            ))
            : const SizedBox()
            : const SizedBox()
            : const SizedBox(),
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(showBack: true,
          // title: i10n.dailyJournal,
          title: "Daily Journal",
          action: Row(
            children: [
              _currentTabIndex == 0
                  ? const SizedBox()
                  : Padding(
                padding: const EdgeInsets.only(right: Dimens.d10),
                child: LottieIconButton(
                  icon: ImageConstant.lottieNavAdd,
                  iconHeight: 35,
                  iconWidth: 35,
                  repeat: true,
                  onTap: () => _onAddClick(context,value: true),
                ),
              ),
            ],
          ),
        ),
        body:getFolderData!.isNotEmpty
            ? SingleChildScrollView(
            child: Column(
              children: [
                Dimens.d20.spaceHeight,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 6.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.search,
                                  color:Colors.grey,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    onChanged: (value) {
                                      _currentTabIndex == 0
                                          ? filterSearchResults(value)
                                          : filterNotesSearchResults(value);
                                    },
                                    controller: ser,
                                    style: Style.montserratRegular(
                                        fontSize: Dimens.d14,
                                        color:
                                        Colors.black.withOpacity(0.8),
                                        fontWeight: FontWeight.w200),
                                    decoration: InputDecoration(
                                      hintStyle: Style.montserratRegular(
                                          fontSize: Dimens.d14,
                                          color: Colors.black
                                              .withOpacity(0.8),
                                          fontWeight: FontWeight.w200),
                                      hintText: 'Search', // Hint text
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.only(
                                          left: 10, bottom: 0),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        /*   Container(
                                height: 35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.3))),
                                child: Center(
                                  child: Row(
                                    children: [
                                      TextFormField(
                                        onChanged: (value) {
                                          _currentTabIndex == 0
                                              ? filterSearchResults(value)
                                              : filterNotesSearchResults(value);
                                        },
                                        controller: ser,
                                        style: Style.mockinacLight(
                                            fontSize: Dimens.d14,
                                            color:
                                            AppColors.black.withOpacity(0.8),
                                            fontWeight: FontWeight.w200),
                                        decoration: InputDecoration(
                                          hintStyle: Style.mockinacLight(
                                              fontSize: Dimens.d14,
                                              color: AppColors.black
                                                  .withOpacity(0.8),
                                              fontWeight: FontWeight.w200),
                                          hintText: 'Search', // Hint text
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.only(
                                              left: 30, bottom: 10),
                                        ),
                                      ),
                                      Icon(
                                        Icons.search,
                                        color:Colors.grey
                                            ,
                                      )
                                    ],
                                  ),
                                )),*/
                        Dimens.d30.spaceHeight,
                        Align(
                          alignment: Alignment.center,
                          child: CustomTabBar(
                            bgColor: ColorConstant.themeColor
                                .withOpacity(Dimens.d0_1),
                            padding: Dimens.d12.paddingHorizontal,
                            labelPadding: Dimens.d12.paddingHorizontal,
                            tabBarIndicatorSize:
                            TabBarIndicatorSize.label,
                            isScrollable: true,
                            listOfItems: [
                              TabText(
                                text: "My Folders",
                                value: Dimens.d0,
                                selectedIndex:
                                _currentTabIndex.toDouble(),
                                padding: Dimens.d15.paddingAll,
                                textHeight: Dimens.d1_2,
                                fontSize: Dimens.d14,
                              ),
                              TabText(
                                // text: i10n.journal,
                                text: 'Recent Journals',
                                value: Dimens.d1,
                                selectedIndex:
                                _currentTabIndex.toDouble(),
                                padding: Dimens.d15.paddingAll,
                                textHeight: Dimens.d1_2,
                                fontSize: Dimens.d14,
                              ),
                            ],
                            tabController: _tabController,
                            onTapCallBack: (value) {
                              if (_currentTabIndex == value) {
                                return;
                              }
                              FocusManager.instance.primaryFocus
                                  ?.unfocus();
                              // searchController.text = '';
                              _currentTabIndex = value;
                              if (value == 0) {
                                setState(() {
                                  recentJournal = false;
                                  ser.clear();
                                  filteredData = [];
                                  notesListFilterList = [];
                                });
                            /*    _notesBloc.add(
                                  GetFolderEvent(),
                                );*/
                              }
                              setState(() {});
                            },
                            unSelectedLabelColor: ColorConstant.textGreyColor,
                          ),
                        ),
                        Dimens.d13.spaceHeight,
                        Text(
                          "Organise Folder",
                          style: Style.montserratRegular(
                              fontSize: Dimens.d12,
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w200),
                        ),
                        Dimens.d25.spaceHeight,
                        _currentTabIndex == 0
                            ? SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.grey
                                        .withOpacity(0.3))),
                            child: filteredData.isNotEmpty
                                ? ListView.builder(
                              padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20),
                              shrinkWrap: true,
                              physics:
                              const NeverScrollableScrollPhysics(),
                              itemCount:
                              filteredData.length ?? 0,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return MyFoldersNote(
                                                id: filteredData[
                                                index]
                                                    .folderId,
                                                title:
                                                filteredData[
                                                index]
                                                    .name);
                                          },
                                        )).then((value) {
                                      setState(() {

                                      });
                                 /*     _notesBloc.add(
                                        GetMyNotesEvent(
                                          paginationRequest:
                                          PaginationRequest(
                                            page: pageNumber,
                                            perPage: Dimens
                                                .d10
                                                .toInt(),
                                            isSaved: true,
                                          ),
                                        ),
                                      );
                                      _notesBloc.add(
                                        GetFolderEvent(),
                                      );*/
                                    });
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                              ImageConstant.folderIcon,
                                              height: 20,
                                              width: 20),
                                          Dimens
                                              .d15.spaceWidth,
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                filteredData[
                                                index]
                                                    .name!,
                                                style: Style.montserratMedium(
                                                    fontSize:
                                                    Dimens
                                                        .d14,
                                                    color: Colors
                                                        .black
                                                        .withOpacity(
                                                        0.8),
                                                    fontWeight:
                                                    FontWeight
                                                        .w200),
                                              ),
                                              Dimens.d2
                                                  .spaceHeight,
                                              Text(
                                                "${filteredData[index].counts} Notes",
                                                style: Style.montserratMedium(
                                                    fontSize:
                                                    Dimens
                                                        .d10,
                                                    fontWeight:
                                                    FontWeight
                                                        .w200),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          PopupMenuButton(
                                              color: Colors
                                                  .white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      10)),
                                              constraints:
                                              const BoxConstraints(
                                                  maxHeight:
                                                  80,
                                                  maxWidth:
                                                  120,
                                                  minHeight:
                                                  80,
                                                  minWidth:
                                                  120),
                                              position:
                                              PopupMenuPosition
                                                  .under,
                                              padding:
                                              const EdgeInsets
                                                  .only(
                                                  top:
                                                  80),
                                              itemBuilder:
                                                  (context) =>
                                              [
                                                PopupMenuItem(
                                                  padding: const EdgeInsets.only(
                                                      left: 20,
                                                      bottom: 20,
                                                      top: 10),
                                                  height:
                                                  20,
                                                  value:
                                                  'rename',
                                                  child:
                                                  Text('Rename', style: Style.montserratMedium(fontSize: Dimens.d12, fontWeight: FontWeight.w200)),
                                                ),
                                                PopupMenuItem(
                                                  height:
                                                  20,
                                                  padding:
                                                  const EdgeInsets.only(left: 20, bottom: 10),
                                                  value:
                                                  'delete',
                                                  child:
                                                  Text('Delete Folder', style: Style.montserratMedium(fontSize: Dimens.d12, fontWeight: FontWeight.w200)),
                                                ),
                                              ],
                                              onSelected:
                                                  (value) async {
                                                if (value ==
                                                    'rename') {
                                                  alertBoxForRename(
                                                      index:
                                                      index);

                                                  debugPrint(
                                                      "rename");
                                                } else if (value ==
                                                    'delete') {
                                                  deleteFolderApi(
                                                      index:
                                                      index);
                                                  debugPrint(
                                                      "delete");
                                                }
                                              },
                                              child:
                                              SvgPicture.asset(
                                               ImageConstant.transformDot,
                                                height: 20,
                                                width: 20,
                                              )),
                                        ],
                                      ),
                                      if (index <
                                          filteredData
                                              .length -
                                              1) ...[
                                        Dimens
                                            .d15.spaceHeight,
                                        customDivider(),
                                        Dimens
                                            .d15.spaceHeight,
                                      ],
                                    ],
                                  ),
                                );
                              },
                            )
                                : ListView.builder(
                              padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20),
                              shrinkWrap: true,
                              physics:
                              const NeverScrollableScrollPhysics(),
                              itemCount:
                              getFolderData?.length ?? 0,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return MyFoldersNote(
                                                id: getFolderData![
                                                index]["id"],
                                                title:
                                                getFolderData![
                                                index]["name"]);
                                          },
                                        )).then((value) {

                                      setState(() {});
                                    });
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                              ImageConstant
                                                  .icNewFolder,
                                              height: 30,
                                              width: 30),
                                          Dimens
                                              .d15.spaceWidth,
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                getFolderData![
                                                index]["name"]!,
                                                style: Style.montserratMedium(
                                                    fontSize:
                                                    Dimens
                                                        .d14,
                                                    color: Colors
                                                        .black
                                                        .withOpacity(
                                                        0.8),
                                                    fontWeight:
                                                    FontWeight
                                                        .w200),
                                              ),
                                              Dimens.d2
                                                  .spaceHeight,
                                              Text(
                                                "${getFolderData[index]["counts"]} Notes",
                                                style: Style.montserratMedium(
                                                    fontSize:
                                                    Dimens
                                                        .d10,
                                                    fontWeight:
                                                    FontWeight
                                                        .w200),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          PopupMenuButton(
                                              color: Colors
                                                  .white,
                                              constraints:
                                              const BoxConstraints(
                                                  maxHeight:
                                                  80,
                                                  maxWidth:
                                                  120,
                                                  minHeight:
                                                  80,
                                                  minWidth:
                                                  120),
                                              position:
                                              PopupMenuPosition
                                                  .under,
                                              padding:
                                              const EdgeInsets
                                                  .only(
                                                  top:
                                                  80),
                                              itemBuilder:
                                                  (context) =>
                                              [
                                                PopupMenuItem(
                                                  padding: const EdgeInsets.only(
                                                      left: 20,
                                                      bottom: 20,
                                                      top: 10),
                                                  height:
                                                  20,
                                                  value:
                                                  'rename',
                                                  child:
                                                  Text('Rename', style: Style.montserratMedium(fontSize: Dimens.d12, fontWeight: FontWeight.w200)),
                                                ),
                                                PopupMenuItem(
                                                  height:
                                                  20,
                                                  padding:
                                                  const EdgeInsets.only(left: 20, bottom: 10),
                                                  value:
                                                  'delete',
                                                  child:
                                                  Text('Delete Folder', style: Style.montserratMedium(fontSize: Dimens.d12, fontWeight: FontWeight.w200)),
                                                ),
                                              ],
                                              onSelected:
                                                  (value) async {
                                                if (value ==
                                                    'rename') {
                                                  alertBoxForRename(
                                                      index:
                                                      index);

                                                  debugPrint(
                                                      "rename");
                                                } else if (value ==
                                                    'delete') {
                                                  deleteFolderApi(
                                                      index:
                                                      index);
                                                  debugPrint(
                                                      "delete");
                                                }
                                              },
                                              child:
                                              Image.asset(
                                                ImageConstant
                                                    .icMenuFolder,
                                                height: 20,
                                                width: 20,
                                              )),
                                        ],
                                      ),
                                      if (index <
                                          getFolderData!
                                              .length -
                                              1) ...[
                                        Dimens
                                            .d15.spaceHeight,
                                        customDivider(),
                                        Dimens
                                            .d15.spaceHeight,
                                      ],
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                            : notesListFilterList.isNotEmpty
                            ? SizedBox(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                            notesListFilterList.length,
                            physics:
                            const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return AddNotesPage(isFromMyNotes: true,
                                  folderId: "",
                                  folderTitle: "",);
                                  },)).then((value) {

                                    setState(() {

                                    });
                                  },);

                                },
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(
                                      bottom: 20),
                                  child: AllNotesJournal(
                                    type: "",
                                    description:
                                    notesListFilterList[
                                    index]
                                        .description ??
                                        "",
                                    margin:
                                    const EdgeInsets.only(
                                        right: Dimens.d16),
                                    title: notesListFilterList[
                                    index]
                                        .title ??
                                        '',
                                    image: notesListFilterList[
                                    index]
                                        .imageUrl ??
                                        '',
                                    createdDate:
                                    notesListFilterList[
                                    index]
                                        .createdOn ??
                                        '',
                                    showDelete: true,
                                    onDeleteTapCallback: () {

                                      notesListFilterList
                                          .removeAt(index);

                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                            : SizedBox(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: notesList.length,
                            physics:
                            const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return AddNotesPage(isFromMyNotes: true,
                                      folderId: "",
                                      folderTitle: "",);
                                  },)).then((value) {
                                    setState(() {

                                    });
                                  },);
                                },
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(
                                      bottom: 20),
                                  child: AllNotesJournal(
                                    type: "",
                                    description:
                                    notesList[index]
                                        .description ??
                                        "",
                                    margin:
                                    const EdgeInsets.only(
                                        right: Dimens.d16),
                                    title: notesList[index]
                                        .title ??
                                        '',
                                    image: notesList[index]
                                        .imageUrl ??
                                        '',
                                    createdDate:
                                    notesList[index]
                                        .createdOn ??
                                        '',
                                    showDelete: true,
                                    onDeleteTapCallback: () {

                                      notesList.removeAt(index);

                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(),
                        Dimens.d80.spaceHeight,
                      ],
                    ),
                  ),
                )
              ],
            ))
            : listNotAvailable());
  }

  Widget listNotAvailable() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Add Folder",
              style: Style.montserratMedium(
                  fontSize: Dimens.d20,
                  color: Colors.black.withOpacity(0.8),
                  fontWeight: FontWeight.w200),
            ),
            Dimens.d15.spaceHeight,
            GestureDetector(
              onTap: () => _onAddClick(context,value: false),
              child: Lottie.asset(
                ImageConstant.lottieNavAdd,
                fit: BoxFit.fill,
                height: Dimens.d90.h,
              ),
            ),
            Dimens.d15.spaceHeight,
            Text(
            "Start Ideas Folder",
              textAlign: TextAlign.center,
              style: Style.montserratMedium(
                  fontSize: Dimens.d14,
                  color: Colors.black.withOpacity(0.8),
                  fontWeight: FontWeight.w200),
            ),
          ],
        ),
      ),
    );
  }

  Widget customDivider() {
    return Container(
      color: ColorConstant.colorThemed4.withOpacity(0.5),
      height: 1,
      width: double.infinity,
    );
  }

  void _onAddClick(BuildContext context,{bool? value}) {
    setState(() {
      recentJournal = value!;
      folderName = "Select Folder";
    });
    final subscriptionStatus = "SUBSCRIBED";


    /// to check if item counts are not more then the config count in case of no subscription
    if (!(subscriptionStatus == "SUBSCRIBED" )) {
 /*     Navigator.pushNamed(context, SubscriptionPage.subscription, arguments: {
        AppConstants.isInitialUser: AppConstants.noSubscription,
        AppConstants.subscriptionMessage: i10n.journalNoSubscriptionMessage,
      });*/
    } else {
      enterFolderName.clear();
      folderAdd();
      /*Navigator.pushNamed(context, AddNotesPage.addNotes, arguments: {
        AppConstants.isFromMyNotes: true,
      }).then((value) {
        if (value != null && value is bool) {
          _refreshNotes(value);
        }
      });*/
    }
  }

  folderAdd() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            Dimens.d24,
          ),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height - 80,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Dimens.d20.spaceHeight,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState.call(() {
                                    enterFolderName.clear();
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Cancel",
                                  style: Style.montserratMedium(
                                      fontSize: Dimens.d16,
                                      fontWeight: FontWeight.w200),
                                ),
                              ),
                              const Spacer(),
                              recentJournal == true && _currentTabIndexFolder == 0
                                  ? const SizedBox()
                                  : GestureDetector(
                                onTap: () async {
                                  await createFolder();
                                },
                                child: Text(
                                  "Done",
                                  style: Style.montserratMedium(
                                    fontSize: Dimens.d16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Dimens.d20.spaceHeight,
                        recentJournal == true
                            ? Align(
                          alignment: Alignment.center,
                          child: CustomTabBar(
                            bgColor: ColorConstant.themeColor
                                .withOpacity(Dimens.d0_1),
                            padding: Dimens.d12.paddingHorizontal,
                            labelPadding: Dimens.d12.paddingHorizontal,
                            tabBarIndicatorSize: TabBarIndicatorSize.label,
                            isScrollable: true,
                            listOfItems: [
                              TabText(
                                text: "Select Folder",
                                value: Dimens.d0,
                                selectedIndex: _currentTabIndex.toDouble(),
                                padding: Dimens.d15.paddingAll,
                                textHeight: Dimens.d1_2,
                                fontSize: Dimens.d14,
                              ),
                              TabText(
                                // text: i10n.journal,
                                text: 'Add New Folder',
                                value: Dimens.d1,
                                selectedIndex:
                                _currentTabIndexFolder.toDouble(),
                                padding: Dimens.d15.paddingAll,
                                textHeight: Dimens.d1_2,
                                fontSize: Dimens.d14,
                              ),
                            ],
                            tabController: _tabControllerFolder,
                            onTapCallBack: (value) {
                              if (_currentTabIndexFolder == value) {
                                return;
                              }
                              FocusManager.instance.primaryFocus?.unfocus();
                              // searchController.text = '';
                              _currentTabIndexFolder = value;
                              if (value == 0) {
                                setState.call(() {});
                              }
                              setState.call(() {});
                            },
                            unSelectedLabelColor: ColorConstant.textGreyColor,
                          ),
                        )
                            : const SizedBox(),
                        Dimens.d10.spaceHeight,
                        recentJournal == true
                            ? Column(
                          children: [
                            _currentTabIndexFolder == 0
                                ? GestureDetector(
                              onTap: () {
                                setState.call(() {
                                  getListOpen = true;
                                });
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black
                                            .withOpacity(0.2)),
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(30)),
                                child: Row(
                                  children: [
                                    Dimens.d25.spaceWidth,
                                    Image.asset(
                                      ImageConstant.icFolderColor,
                                      height: 20,
                                      width: 20,
                                    ),
                                    Dimens.d15.spaceWidth,
                                    Text(
                                      folderName,
                                      style: Style.montserratMedium(
                                          color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                            )
                                : Column(
                              children: [
                                Dimens.d10.spaceHeight,
                                Text(
                                  "Add New Folder",
                                  style: Style.montserratMedium(
                                      fontSize: Dimens.d16,
                                      fontWeight: FontWeight.w200),
                                ),
                                Dimens.d30.spaceHeight,
                                Container(
                                    height: 35,
                                    margin:
                                    const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(20),
                                        color: ColorConstant.themeColor),
                                    child: Center(
                                      child: TextFormField(
                                        onChanged: (value) {
                                          if (value.isNotEmpty) {
                                            // Capitalize the first letter
                                            enterFolderName.value = TextEditingValue(
                                              text: value[0].toUpperCase() + value.substring(1),
                                              selection: enterFolderName.selection,
                                            );
                                          }
                                        },
                                        controller: enterFolderName,
                                        decoration: InputDecoration(
                                          hintStyle:
                                          Style.montserratMedium(
                                              fontSize:
                                              Dimens.d14,
                                              color: ColorConstant
                                                  .whiteLight.withOpacity(0.8),
                                              fontWeight:
                                              FontWeight
                                                  .w200),
                                          hintText:
                                          "Enter FolderName",
                                          // Hint text
                                          border: InputBorder.none,
                                          contentPadding:
                                          const EdgeInsets.only(
                                              left: 22,
                                              bottom: 10),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                            getListOpen == true &&
                                _currentTabIndexFolder == 0
                                ? Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0,
                                          3), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(20)),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: getFolderData?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState.call(() {
                                        folderName =
                                        getFolderData![index]["name"]!;
                                        folderId =
                                        getFolderData![index]["id"]!;
                                        getListOpen = false;
                                      });
                                    },
                                    child:  Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                                      child: Text(
                                        getFolderData![index]["name"]!,
                                        style: Style.montserratMedium(
                                            color:Colors.black),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                                : const SizedBox(),
                            Dimens.d20.spaceHeight,
                          ],
                        )
                            : const SizedBox(),
                        recentJournal == true
                            ? Dimens.d20.spaceHeight
                            : const SizedBox(),
                        recentJournal == true
                            ? const SizedBox()
                            : Text(
                          "Add New Folder",
                          style: Style.montserratMedium(
                              fontSize: Dimens.d16,
                              fontWeight: FontWeight.w200),
                        ),
                        Dimens.d20.spaceHeight,
                        recentJournal == true
                            ? _currentTabIndexFolder==0?GestureDetector(
                          onTap: () {
                            if(folderName!="Select Folder"){
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return AddNotesPage(isFromMyNotes: true,
                                  folderId: "",
                                  folderTitle: "",);
                              },)).then((value) {
                                Get.back();
                                setState(() {

                                });
                              },);
                            }
                          },
                          child: Container(
                            height: 25,
                            width: 70,
                            decoration: BoxDecoration(
                                color: ColorConstant.themeColor,
                                borderRadius: BorderRadius.circular(25)),
                            child: Center(
                              child: Text(
                                "Done",
                                style: Style.montserratMedium(
                                    fontSize: Dimens.d15,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ):const SizedBox()
                            :  Container(
                            height: 35,
                            margin:
                            const EdgeInsets.symmetric(
                                horizontal: 20),
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(20),
                                color: ColorConstant.themeColor,),
                            child: Center(
                              child: TextFormField(
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    // Capitalize the first letter
                                    enterFolderName.value = TextEditingValue(
                                      text: value[0].toUpperCase() + value.substring(1),
                                      selection: enterFolderName.selection,
                                    );
                                  }
                                },
                                controller: enterFolderName,
                                decoration: InputDecoration(
                                  hintStyle:
                                  Style.montserratMedium(
                                      fontSize:
                                      Dimens.d14,
                                      color: ColorConstant
                                          .whiteLight.withOpacity(0.8),
                                      fontWeight:
                                      FontWeight
                                          .w200),
                                  hintText:
                                  "Enter FolderName",
                                  // Hint text
                                  border: InputBorder.none,
                                  contentPadding:
                                  const EdgeInsets.only(
                                      left: 22,
                                      bottom: 10),
                                ),
                              ),
                            )),
                      ],
                    ),
                  )),
            );
          },
        );
      },
    );
  }

  alertBoxForRename({int? index}) {
    renameFolderController.text = getFolderData![index!]["name"]!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Rename Folder',
                  style: Style.montserratMedium(
                      fontSize: Dimens.d14,
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w200),
                ),
                const SizedBox(height: 17),
                Container(
                    height: 30,
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                        border:
                        Border.all(color: Colors.grey.withOpacity(0.3))),
                    child: Center(
                      child: TextFormField(
                        controller: renameFolderController,
                        style: Style.montserratMedium(
                            fontSize: Dimens.d12,
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w200),
                        decoration: InputDecoration(
                          hintStyle: Style.montserratMedium(
                              fontSize: Dimens.d12,
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w200),
                          hintText: 'folder', // Hint text
                          border: InputBorder.none,
                          contentPadding:
                          const EdgeInsets.only(left: 30, bottom: 15),
                        ),
                      ),
                    )),
                const SizedBox(height: 17),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        renameFolderController.clear();
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border:
                            Border.all(color: ColorConstant.themeColor)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 2),
                          child: Text(
                            'Cancel',
                            style: Style.montserratMedium(
                                fontSize: Dimens.d12,
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.w200),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        getFolderData.add({"name":renameFolderController.text,"id":"","counts":""});
                        await editApi(
                            id: getFolderData[index]["id"],
                            text: renameFolderController.text);
                        renameFolderController.clear();
                        setState(() {
                        });
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: ColorConstant.themeColor,
                            border:
                            Border.all(color: ColorConstant.themeColor)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 2),
                          child: Text(
                          "Save",
                            style: Style.montserratMedium(
                                fontSize: Dimens.d12,
                                color: Colors.white,
                                fontWeight: FontWeight.w200),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
