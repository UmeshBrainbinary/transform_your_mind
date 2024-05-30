import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:http/http.dart' as http ;
import 'package:transform_your_mind/core/common_widget/common_gradiant_container.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/lottie_icon_button.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_notes_page.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/folder_descrptions.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/journal_list_tile_layout.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/journal_no_data.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/journal_shimmer_widget.dart';

import '../../../widgets/custom_appbar.dart';

List notesDraftList = [];
List notesListToday = [];
List notesListLast = [];

class MyFoldersNote extends StatefulWidget {
  String? id,title;
   MyFoldersNote({super.key,this.id,this.title});

  @override
  State<MyFoldersNote> createState() => _MyFoldersNoteState();
}

class _MyFoldersNoteState extends State<MyFoldersNote>  with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();

  List notesList = [];

  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  int pageNumber = 1;
  int totalItemCountOfNotes = 0;
  Timer? _debounce;
  int itemIndexToRemove = -1;
  bool _isSearching = false;
  ScrollController scrollController = ScrollController();
  bool _isScrollingOrNot = false;
  //Drafts
  bool _isLoadingDraft = false;
  int pageNumberDrafts = 1;
  final RefreshController _refreshControllerDrafts =
  RefreshController(initialRefresh: false);
  int totalItemCountOfNotesDrafts = 0;


  ValueNotifier<bool> isTutorialVideoVisible = ValueNotifier(false);
  int noteAddedCount = 0;
  late AnimationController _controller;
  String startDate = "";
  String endDate = "";
    DateTime todayDate = DateTime.now();
  DateTime? startDatePre;
  @override
  void initState() {
    super.initState();
  setState(() {
  startDatePre  = todayDate.subtract(const Duration(days: 30));
});
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    isTutorialVideoVisible.value =
    (noteAddedCount < 3);
    if (isTutorialVideoVisible.value) {
      _controller.forward();
    }





  }




  void filterNotes(List notesList) {
    setState(() {
      notesListToday = [];
      notesListLast = [];
    });
    // Get today's date
    DateTime currentDate = DateTime.now();
    // Get the start date for the previous 30 days
    DateTime startDate = currentDate.subtract(const Duration(days: 30));

 /*   // Iterate through each note in the notesList
    for ([MyNotesData] note in notesList) {
      // Parse the createdOn date string to a DateTime object
      DateTime noteDate = DateTime.parse(note.createdOn!);

      // Compare the note's date with today's date and the start date for the previous 30 days
      if (isSameDate(currentDate, noteDate)) {
        notesListToday.add(note);
      } else if (noteDate.isAfter(startDate) && noteDate.isBefore(currentDate)) {
        notesListLast.add(note);
      }
    }*/
  }

  // Function to check if two dates are on the same day
  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(showBack: true,
        title: widget.title??"",
        action: Row(
          children: [
            LottieIconButton(
                icon: ImageConstant.lottieNavAdd,
                iconHeight: 35,
                iconWidth: 35,
                repeat: true,
                onTap: () {
                  _onAddClick(context);
                }),
           /* (tutorialVideoData?.sId != null)? Padding(
              padding: const EdgeInsets.only(right: Dimens.d22),
              child: GestureDetector(
                onTap: (){
                  isTutorialVideoVisible.value = !isTutorialVideoVisible.value;
                  if (isTutorialVideoVisible.value) {
                    _controller.forward();
                  } else {
                    videoKeys[11].currentState?.pause();
                    _controller.reverse();
                  }
                },
                child: Lottie.asset(
                  themeManager.lottieInfo,
                  height: Dimens.d24,
                  width: Dimens.d24,
                  fit: BoxFit.cover,
                  repeat: false,
                ),
              ),
            ):const SizedBox()*/
          ],
        ),
      ),
      body:notesListToday.isNotEmpty  || notesListLast.isNotEmpty || notesDraftList.isNotEmpty?SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Dimens.d30.spaceHeight,
              ///draft list for notes
              (_isLoadingDraft && pageNumberDrafts == 1)
                  ? const JournalListHorizontalShimmer()
                  : (notesDraftList.isNotEmpty)
                  ? Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimens.d20),
                    child: Text(
                      "Drafts",
                      style: Style.montserratBold(
                        fontSize: Dimens.d16,
                      ),
                    ),
                  ),
                  Dimens.d20.h.spaceHeight,
                  SizedBox(
                    height: Dimens.d110.h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: notesDraftList.length,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20),
                      physics:
                      const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var data = notesDraftList[index];
                        return GestureDetector(
                          onTap: () {

                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return AddNotesPage(isFromMyNotes: true,folderId: widget.id,
                              folderTitle: widget.title,);
                            },)).then((value) {
                              if (value != null &&
                                  value is bool) {
                                filterNotes(notesList);
                                _refreshNotes(value);
                              }
                              setState(() {

                              });
                            },);

                          },
                          child: FolderDescriptionPage(
                            type: widget.title??"",
                            description: data["des"]??"",
                            margin: const EdgeInsets.only(
                                right: Dimens.d16),
                            title: data["title"] ?? '',
                            image: data["image"] ?? '',
                            createdDate: '',
                            showDelete: true,
                            onDeleteTapCallback: () {
                          /*    _notesBloc.add(
                                DeleteNotesEvent(
                                    deleteNotesRequest:
                                    DeleteNotesRequest(
                                        notesId:
                                        data.notesId ??
                                            ""),
                                    isFromDraft: true),
                              );*/
                              notesDraftList
                                  .removeAt(index);
                              setState(() {

                              });
                        /*      _notesBloc.add(
                                  RefreshNotesEvent());*/
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
                  : const SizedBox.shrink(),
              if (_isLoadingDraft || (notesDraftList.isNotEmpty))
                Dimens.d20.spaceHeight,

              ///notes data Today list
              LayoutContainer(
                vertical: 0,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Dimens.d30.spaceHeight,
                    Text(
                      "Today",
                      style: Style.montserratBold(
                        fontSize: Dimens.d16,
                      ),
                    ),
                    Dimens.d20.spaceHeight,
                    NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo is UserScrollNotification) {
                          setState(() {
                            _isScrollingOrNot = true;
                            if( scrollController.offset <= scrollController.position.minScrollExtent &&
                                !scrollController.position.outOfRange) {
                              setState(() {
                                _isScrollingOrNot = false;
                              });
                            }
                          });
                        }
                        return false;
                      },
                      child: /*(state is NotesLoadingState &&
                          pageNumber == 1) &&
                          !_isSearching
                          ? const JournalListShimmer()
                          : notesListToday.isNotEmpty
                          ?*/ Stack(
                        children: [
                          SlidableAutoCloseBehavior(
                            closeWhenOpened: true,
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: notesListToday.length,
                              shrinkWrap: true,
                              physics:
                              const NeverScrollableScrollPhysics(),
                              itemBuilder:
                                  (context, index) {
                                var data =
                                notesListToday[index];

                                var currentDate =
                                DateTime.now();
                                return Slidable(
                                  closeOnScroll: true,
                                  key: const ValueKey<String>(
                                      "" ?? ""),
                                  endActionPane:
                                  ActionPane(
                                    motion:
                                    const ScrollMotion(),
                                    dragDismissible:
                                    false,
                                    extentRatio: 0.26,
                                    children: [
                                      Dimens.d20
                                          .spaceWidth,
                                      GestureDetector(
                                        onTap: () {

                                          notesListToday
                                              .removeAt(
                                              index);
                                          _isSearching =
                                              notesListToday
                                                  .isNotEmpty;
                                          setState(() {

                                          });

                                        },
                                        child: Container(
                                          width: Dimens
                                              .d65,
                                          margin: EdgeInsets.only(
                                              bottom:
                                              Dimens
                                                  .d20
                                                  .h),
                                          decoration:
                                          BoxDecoration(
                                            color: ColorConstant
                                                .deleteRed,
                                            borderRadius:
                                            Dimens.d16
                                                .radiusAll,
                                          ),
                                          alignment:
                                          Alignment
                                              .center,
                                          child:
                                          SvgPicture
                                              .asset(
                                            ImageConstant
                                                .icDeleteWhite,
                                            width: Dimens
                                                .d24,
                                            height: Dimens
                                                .d24,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: () {

                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return AddNotesPage(isFromMyNotes: true,folderId: widget.id,
                                          folderTitle: widget.title,);
                                      },)).then((value) {
                                        if (value != null &&
                                            value is bool) {
                                          filterNotes(notesList);
                                          _refreshNotes(value);
                                        }
                                        setState(() {

                                        });
                                      },);
                                    },
                                    child:
                                    JournalListTileNotesLayout(
                                      type: widget.title??"",
                                      margin:
                                      EdgeInsets.only(
                                          bottom:
                                          Dimens
                                              .d20
                                              .h),
                                      title: data["title"] ??
                                          '',
                                      image:
                                      data["image"] ??
                                          '',
                                      createdDate:
                                          DateTime.now()
                                              .toString(),
                                      desc:
                                      data["des"] ??
                                          '',
                                      showTime: false,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          (_isScrollingOrNot)?commonGradiantContainer(
                              color: ColorConstant
                                  .backgroundWhite,
                              h: 30):const SizedBox()
                        ],
                      )
                        /*  : Center(
                          child:Text("No data Found",style:  Style.montserratMedium(
                            fontSize: Dimens.d16,
                          ),)),*/
                    ),
                  ],
                ),
              ),
              ///notes data list last 30 days
              LayoutContainer(
                vertical: 0,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Dimens.d30.spaceHeight,
                    Text(
                      "Previous 30 Days",
                      style: Style.montserratBold(
                          fontSize: Dimens.d16,
                          color: Colors.black

                      ),
                    ),
                    Dimens.d20.spaceHeight,
                    NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo is UserScrollNotification) {
                          setState(() {
                            _isScrollingOrNot = true;
                            if( scrollController.offset <= scrollController.position.minScrollExtent &&
                                !scrollController.position.outOfRange) {
                              setState(() {
                                _isScrollingOrNot = false;
                              });
                            }
                          });
                        }
                        return false;
                      },
                      child:/* (state is NotesLoadingState &&
                          pageNumber == 1) &&
                          !_isSearching
                          ? const JournalListShimmer()
                          : notesListLast.isNotEmpty
                          ? */Stack(
                        children: [
                          SlidableAutoCloseBehavior(
                            closeWhenOpened: true,

                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: notesListLast.length,
                              shrinkWrap: true,
                              physics:
                              const NeverScrollableScrollPhysics(),
                              itemBuilder:
                                  (context, index) {
                                var data =
                                notesListLast[index];
                                var date = data
                                    .updatedAt !=
                                    null
                                    ?  data.updatedAt!
                                    : DateTime.now();
                                var currentDate =
                                DateTime.now();
                                return Slidable(
                                  closeOnScroll: true,
                                  key: ValueKey<String>(
                                      data.notesId ?? ""),
                                  endActionPane:
                                  ActionPane(
                                    motion:
                                    const ScrollMotion(),
                                    dragDismissible:
                                    false,
                                    extentRatio: 0.26,
                                    children: [
                                      Dimens.d20
                                          .spaceWidth,
                                      GestureDetector(
                                        onTap: () {

                                          notesListToday
                                              .removeAt(
                                              index);
                                          _isSearching =
                                              notesListLast
                                                  .isNotEmpty;
                                          setState(() {

                                          });


                                        },
                                        child: Container(
                                          width: Dimens
                                              .d65,
                                          margin: EdgeInsets.only(
                                              bottom:
                                              Dimens
                                                  .d20
                                                  .h),
                                          decoration:
                                          BoxDecoration(
                                            color: ColorConstant
                                                .deleteRed,
                                            borderRadius:
                                            Dimens.d16
                                                .radiusAll,
                                          ),
                                          alignment:
                                          Alignment
                                              .center,
                                          child:
                                          SvgPicture
                                              .asset(
                                            ImageConstant
                                                .icDeleteWhite,
                                            width: Dimens
                                                .d24,
                                            height: Dimens
                                                .d24,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: () {

                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return AddNotesPage(isFromMyNotes: true,folderId: widget.id,
                                          folderTitle: widget.title,);
                                      },)).then((value) {
                                        if (value != null &&
                                            value is bool) {
                                          filterNotes(notesList);
                                          _refreshNotes(value);
                                        }
                                        setState(() {

                                        });
                                      },);
                                    },
                                    child:
                                    JournalListTileNotesLayout(
                                      type: widget.title??"",
                                      margin:
                                      EdgeInsets.only(
                                          bottom:
                                          Dimens
                                              .d20
                                              .h),
                                      title: data.title ??
                                          '',
                                      image:
                                      data.imageUrl ??
                                          '',
                                      createdDate: data
                                          .updatedAt ??
                                          DateTime.now()
                                              .toString(),
                                      desc:
                                      data.description ??
                                          '',
                                      showTime: DateTime.parse(data
                                          .updatedAt!).day ==
                                          currentDate.day,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          (_isScrollingOrNot)?commonGradiantContainer(
                              color: ColorConstant
                                  .backgroundWhite,
                              h: 30):const SizedBox()
                        ],
                      )
                          /*: Center(
                        child: Center(
                            child:Text("No data Found",style:  Style.mockinacBold(
                                fontSize: Dimens.d16,
                                color: AppColors.black
                            ),)),),*/
                    ),
                  ],
                ),
              )
            ],
          )
      ):Center(
          child: JournalNoDataWidget(
            showBottomHeight: true,
            title: _isSearching
                ? "Notes No Search Data"
                :"Notes No Data Message",
            onClick: () =>
                _onAddClick(context),
          ))
    );
  }

  void _onAddClick(BuildContext context) {
    final subscriptionStatus = "SUBSCRIBED";


    /// to check if item counts are not more then the config count in case of no subscription
    if (!(subscriptionStatus == "SUBSCRIBED" || subscriptionStatus == "SUBSCRIBED")){
  /*      (totalItemCountOfNotes) >=
            (subscriptionConfigData?.notepadCount ?? 1)) {
      Navigator.pushNamed(context, SubscriptionPage.subscription, arguments: {
        AppConstants.isInitialUser: AppConstants.noSubscription,
        AppConstants.subscriptionMessage: i10n.journalNoSubscriptionMessage,
      });*/
    } else {

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AddNotesPage(isFromMyNotes: true,folderId: widget.id,
          folderTitle: widget.title,);
      },)).then((value) {
        if (value != null &&
            value is bool) {
          filterNotes(notesList);
          _refreshNotes(value);
        }
        setState(() {

        });
      },);
    }
  }

  void _refreshNotes(bool value) {
    pageNumber = 1;
    notesList.clear();

    pageNumberDrafts = 1;
    notesDraftList.clear();

  }

  void _refreshApiCall(bool value) {
    pageNumber = 1;
    notesList.clear();

  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // do something with query
      _isSearching = true;
      pageNumber = 1;
      query.trim();
      if (query.isNotEmpty) {
        if (!RegExp(r'[^\w\s]').hasMatch(query)) {

        }
      } else {

      }
    });
  }
}
