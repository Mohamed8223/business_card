import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinigram_app/core/widgets/visibilty_toggle.dart';
import 'package:clinigram_app/features/admin_manage/admin_manage.dart';
import 'package:clinigram_app/features/admin_manage/data/models/category_model.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:clinigram_app/core/core.dart';

class CategoryAddDialog extends StatefulHookConsumerWidget {
  const CategoryAddDialog(
      {super.key,
      this.categoryModel,
      this.isEdit = false,
      this.isSubCategory = false});
  final CategoryModel? categoryModel;
  final bool isEdit;
  final bool isSubCategory;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoryAddDialogState();
}

class _CategoryAddDialogState extends ConsumerState<CategoryAddDialog>
    with ValidationMixin {
  File? pickedAttatchment;
  late CategoryType categoryType;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    categoryType =
        widget.categoryModel?.categoryType ?? CategoryType.specialist;
  }

  @override
  Widget build(BuildContext context) {
    final nameArCon = useTextEditingController(
        text: widget.isEdit ? widget.categoryModel!.nameAr : '');
    final nameEnCon = useTextEditingController(
        text: widget.isEdit ? widget.categoryModel!.nameEn : '');
    final nameHeCon = useTextEditingController(
        text: widget.isEdit ? widget.categoryModel!.nameHe : '');
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.isSubCategory
                  ? S.of(context).CategoryAddDialog_addSubcategoryTitle
                  : S.of(context).CategoryAddDialog_addCategoryTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            if (!widget.isSubCategory) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: InkWell(
                  onTap: () {
                    pickAttatchment(context);
                  },
                  child: pickedAttatchment != null
                      ? Image.file(pickedAttatchment!)
                      : widget.isEdit
                          ? CachedNetworkImage(
                              imageUrl: widget.categoryModel!.imageUrl,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                            )
                          : DottedBorder(
                              color: const Color(0xFF6799FF),
                              borderType: BorderType.Rect,
                              dashPattern: const [5, 5],
                              radius: const Radius.circular(20),
                              padding: EdgeInsets.zero,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 30),
                                height: 200,
                                color: const Color(0xFF6799FF).withOpacity(0.2),
                                child: Image.asset(
                                  uploadIcon,
                                ),
                              ),
                            ),
                ),
              ),
              VisibiltyToggle(currentValue: widget.categoryModel?.visible),
              const SizedBox(
                height: 10,
              ),
              MainCategoryType(
                isChecked: categoryType == CategoryType.specialist,
                onChanged: (type) {
                  categoryType = type;
                },
              )
            ],
            if (widget.isSubCategory)
              SubCategoryType(
                selectedCategory: categoryType,
                onChanged: (type) {
                  categoryType = type;
                },
              ),
            const SizedBox(
              height: 30,
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  ClinigramTextField(
                    hintText: S.of(context).CategoryAddDialog_nameHintText,
                    validator: (name) => emptyValidation(name, context),
                    controller: nameArCon,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ClinigramTextField(
                    hintText: S.of(context).CategoryAddDialog_nameHintText,
                    validator: (name) => emptyValidation(name, context),
                    controller: nameEnCon,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ClinigramTextField(
                    hintText: S.of(context).CategoryAddDialog_nameHintText,
                    validator: (name) => emptyValidation(name, context),
                    controller: nameHeCon,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ClinigramButton(
              onPressed: () {
                final visible = ref.read(visibiltyToggleProvider);
                if (formKey.currentState!.validate()) {
                  if (widget.isSubCategory) {
                    if (widget.isEdit) {
                      context.pop();
                      ref
                          .read(categoriesProvider.notifier)
                          .updateSubCategory(widget.categoryModel!.copyWith(
                            nameAr: nameArCon.text,
                            nameEn: nameEnCon.text,
                            nameHe: nameHeCon.text,
                            visible: visible,
                            categoryType: categoryType,
                          ));
                      return;
                    }
                    context.pop();
                    ref.read(categoriesProvider.notifier).addNewSubCategory(
                          widget.categoryModel!.id!,
                          CategoryModel(
                              nameAr: nameArCon.text,
                              nameEn: nameEnCon.text,
                              nameHe: nameHeCon.text,
                              categoryType: categoryType,
                              subCategories: []),
                        );
                  } else {
                    if (widget.isEdit) {
                      context.pop();
                      ref.read(categoriesProvider.notifier).updateCategory(
                          widget.categoryModel!.copyWith(
                            nameAr: nameArCon.text,
                            nameEn: nameEnCon.text,
                            nameHe: nameHeCon.text,
                            visible: visible,
                            categoryType: categoryType,
                            imageUrl: pickedAttatchment?.path ??
                                widget.categoryModel!.imageUrl,
                          ),
                          imageUpdated: pickedAttatchment != null);
                    } else {
                      if (pickedAttatchment != null) {
                        context.pop();
                        ref.read(categoriesProvider.notifier).addNewCategory(
                            CategoryModel(
                              nameAr: nameArCon.text,
                              nameEn: nameEnCon.text,
                              nameHe: nameHeCon.text,
                              categoryType: categoryType,
                              subCategories: [],
                            ),
                            pickedAttatchment!);
                      } else {
                        context.showSnackbarError(
                            S.of(context).CategoryAddDialog_pleaseAddImageText);
                      }
                    }
                  }
                }
              },
              child: Text(
                S.of(context).CategoryAddDialog_saveButtonText,
                style: context.textTheme.titleMedium!
                    .copyWith(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  void pickAttatchment(BuildContext context) async {
    const int maxImageSize = 2;
    FilePickerResult? result;
    result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['png', 'jpg', 'jpeg']);

    if (result != null) {
      final file = result.files.single;
      final fileSize = file.size / (1024 * 1024);

      if (fileSize <= maxImageSize) {
        pickedAttatchment = File(result.files.single.path!);
        setState(() {});
      } else {}
    }
  }
}

class SubCategoryType extends StatefulWidget {
  final ValueChanged<CategoryType>? onChanged;
  final CategoryType? selectedCategory;

  const SubCategoryType({Key? key, this.onChanged, this.selectedCategory})
      : super(key: key);

  @override
  State<SubCategoryType> createState() => _SubCategoryTypeState();
}

class _SubCategoryTypeState extends State<SubCategoryType> {
  CategoryType? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RadioListTile<CategoryType>(
            contentPadding: EdgeInsets.zero,
            title: Text(S.of(context).CategoryAddDialog_addSubCategoryText),
            value: CategoryType.specialist,
            groupValue: _selectedCategory,
            onChanged: (CategoryType? value) {
              setState(() {
                _selectedCategory = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(_selectedCategory!);
              }
            },
          ),
        ),
        Expanded(
          child: RadioListTile<CategoryType>(
            contentPadding: EdgeInsets.zero,
            title: Text(S.of(context).CategoryAddDialog_serviceText),
            value: CategoryType.service,
            groupValue: _selectedCategory,
            onChanged: (CategoryType? value) {
              setState(() {
                _selectedCategory = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(_selectedCategory!);
              }
            },
          ),
        ),
      ],
    );
  }
}
