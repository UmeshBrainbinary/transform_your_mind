
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/lottie_icon_button.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/my_folders_note.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:transform_your_mind/widgets/custom_view_controller.dart';


class AddNotesPage extends StatefulWidget {
  String? folderTitle;
  String? folderId;
  AddNotesPage({
    Key? key,
    required this.isFromMyNotes,
    this.folderTitle,
    this.folderId,
  }) : super(key: key);
  static const addNotes = '/addNotes';
  final bool isFromMyNotes;

  @override
  State<AddNotesPage> createState() => _AddNotesPageState();
}

class _AddNotesPageState extends State<AddNotesPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController titleController = TextEditingController();
  ValueNotifier<int> currentLength = ValueNotifier(0);

  final TextEditingController descController = TextEditingController();
  final TextEditingController folderLocationController =
  TextEditingController();

  final FocusNode titleFocus = FocusNode();
  final FocusNode descFocus = FocusNode();
  final FocusNode folderFocus = FocusNode();

  int maxLength = Dimens.d50.toInt();
  int maxLengthDesc = 2000;


  final bool _isImageRemoved = false;
  String folderName = "";
  String folderId = "";
  List? getFolderData = [];
  @override
  void initState() {
    super.initState();

    setState(() {
      folderName = widget.folderTitle!;
      folderId = widget.folderId!;
    });


  }


  bool getListOpen = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBack: true,
        // title: widget.notesData != null ? i10n.editNotes : i10n.addNotes,
          title: "New Note",
          action:LottieIconButton(
            icon: ImageConstant.lottieDeleteAccount,
            onTap: () {

            },
          ))
             ,
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: CustomScrollViewWidget(
                      child: LayoutContainer(
                        child: Stack(alignment: Alignment.bottomCenter,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Dimens.d10.spaceHeight,
                                CommonTextField(
                                  hintText: "Enter Title",
                                  labelText: "Title",
                                  controller: titleController,
                                  focusNode: titleFocus,
                                  prefixLottieIcon:
                                  ImageConstant.lottieTitle,
                                  maxLength: maxLength,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(
                                        maxLength),
                                  ],
                                ),
                                Dimens.d16.h.spaceHeight,
                                CommonTextField(
                                  hintText: "Enter Description",
                                  labelText: "Description",
                                  controller: descController,
                                  focusNode: descFocus,
                                  transform: Matrix4.translationValues(
                                      0, -132.h, 0),
                                  prefixLottieIcon:
                                  ImageConstant.lottieDescription,
                                  maxLines: 18,
                                  maxLength: maxLengthDesc,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(
                                        maxLengthDesc),
                                  ],
                                  onChanged: (value) => currentLength
                                      .value = descController.text.length,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                ),
                                Dimens.d20.h.spaceHeight,
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      getListOpen = true;
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
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
                              ],
                            ),
                            getListOpen==true?
                            Container(height:180,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: getFolderData?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return GestureDetector(onTap: () {
                                    setState(() {
                                      folderName = getFolderData![index].name!;
                                      folderId =getFolderData![index].folderId!;
                                      getListOpen = false;

                                    });
                                  },
                                    child: ListTile(
                                      title: Text(
                                        getFolderData![index].name!,
                                        style: Style.montserratMedium(
                                            color: Colors.black),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ):
                            const SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ),
                  LayoutContainer(
                    child: Row(
                      children: [
                        Expanded(
                          child: CommonElevatedButton(
                            title: "Draft",
                            outLined: true,
                            textStyle: Style.montserratMedium(
                                color: ColorConstant.textDarkBlue),
                            onTap: () => _callSubmitApi(false),
                          ),
                        ),
                        Dimens.d20.spaceWidth,
                        Expanded(
                          child: CommonElevatedButton(
                            title: "Save",
                            onTap: () => _callSubmitApi(true),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Dimens.d10.spaceHeight,
                ],
              );
            },
          ),
       /*   if (state is NotesLoadingState)
            Container(
              color: Colors.transparent,
              child: Center(
                child: InkDropLoader(
                    size: Dimens.d50, color: themeManager.colorThemed5),
              ),
            )*/
        ],
      )
    );
  }

  void _callSubmitApi(bool isSaved) {
    if (titleController.text.trim().isEmpty) {
      showSnackBarError(context, "Title cannot be empty.");
    } else if (descController.text.trim().isEmpty) {
      showSnackBarError(context, "Description cannot be empty.");
    } else {
      if(isSaved){
        notesListToday.add({
          "title":titleController.text,
          "des":descController.text,
          "image":"",
        });
      }else{
        notesDraftList.add({
          "title":titleController.text,
          "des":descController.text,
          "image":"",
        });
      }

      setState(() {
      debugPrint("notes List Today $notesListToday");
      debugPrint("notes List Today $notesDraftList");
      });
      Get.back();
    }
  }


}
