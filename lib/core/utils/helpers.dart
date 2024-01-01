import 'dart:io' show File;

import 'package:clinigram_app/features/admin_manage/data/models/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show GeoPoint, Timestamp;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../features/admin_manage/data/models/category_model.dart';
import '../core.dart';

bool isImage(String filePath) {
  const imagesExtetions = ['png', 'jpg', 'jpeg', 'gif'];
  final fileExtention = filePath.split('.').last;
  return imagesExtetions.contains(fileExtention);
}

AccontType? stringToAccountType(String? accontType) {
  switch (accontType) {
    case 'user':
      return AccontType.user;
    case 'doctor':
      return AccontType.doctor;
    case 'admin':
      return AccontType.admin;
    case 'marketer':
      return AccontType.marketer;
    case null:
      return null;
    default:
      throw Exception("type $accontType not found");
  }
}

ChatMessageType stringToChatMessageType(String chatMessageType) {
  switch (chatMessageType) {
    case 'text':
      return ChatMessageType.text;
    case 'image':
      return ChatMessageType.image;
    case 'pdf':
      return ChatMessageType.pdf;
    default:
      throw Exception("type not found");
  }
}

AttatchmentType stringToAttatchmentType(String attatchmentType) {
  switch (attatchmentType) {
    case 'pdf':
      return AttatchmentType.pdf;
    case 'image':
      return AttatchmentType.image;
    case 'none':
      return AttatchmentType.none;
    default:
      throw Exception("type $attatchmentType not found");
  }
}

Future<String> uploadFileToFirebase(File file, String bucketName) async {
  if (kIsWeb) {
    XFile xfile = XFile(file.path);
    return await uploadXFileToFirebaseWeb(xfile, bucketName);
  } else {
    return uploadFileToFirebaseMobile(file, bucketName);
  }
}

Future<String> uploadXFileToFirebase(XFile xfile, String bucketName) async {
  if (kIsWeb) {
    return await uploadXFileToFirebaseWeb(xfile, bucketName);
  } else {
    // Uploading XFile and File is the same in mobile
    return await uploadFileToFirebase(File(xfile.path), bucketName);
  }
}

Future<String> uploadFileToFirebaseMobile(File file, String bucketName) async {
  String uploadedImageUrl = await FirebaseStorage.instance
      .ref()
      .child('$bucketName/${Uri.file(file.path).pathSegments.last}')
      .putFile(file)
      .then((result) {
    return result.ref.getDownloadURL();
  });
  return uploadedImageUrl;
}

Future<String> uploadXFileToFirebaseWeb(XFile file, String bucketName) async {
  Reference reference = FirebaseStorage.instance
      .ref()
      .child('$bucketName/${Uri.file(file.path).pathSegments.last}');

  Uint8List fileData = await file.readAsBytes();

  await reference.putData(
      fileData, SettableMetadata(contentType: 'image/jpeg'));

  // Get the download URL
  String uploadedImageUrl = await reference.getDownloadURL();
  return uploadedImageUrl;
}

String generateChatId(String senderId, String reciverId) {
  final result = senderId.compareTo(reciverId);
  if (result < 0) {
    return reciverId + senderId;
  } else if (result > 0) {
    return senderId + reciverId;
  }
  return '';
}

String formatMessageDate(DateTime messageDate, String locale) {
  final now = DateTime.now();
  final difference = now.difference(messageDate);

  if (messageDate.day == now.day) {
    return DateFormat('jm', locale).format(messageDate);
  } else if (difference.inDays < 7) {
    return DateFormat('EEEE', locale).format(messageDate);
  } else {
    return DateFormat('d/m/y').format(messageDate);
  }
}

String? getFileNameFromUrl(String url) {
  Uri uri = Uri.parse(url);
  String path = uri.path;
  List<String> pathSegments = path.split('/');

  // Find the segment that contains the encoded file name
  String encodedFileNameSegment = pathSegments
      .lastWhere((segment) => segment.contains('%2F'), orElse: () => '');

  if (encodedFileNameSegment.isNotEmpty) {
    String decodedFileName = Uri.decodeComponent(encodedFileNameSegment);
    return decodedFileName.replaceAll('%2F', '/').split('/').last;
  }
  return null;
}

DateTime timestampToDate(dynamic timestamp) {
  return timestamp.toDate();
}

Timestamp dateTimeToTimestamp(DateTime date) => Timestamp.fromDate(date);

GeoPoint getGeopointFrommText(String location) {
  String formateLocation = location.replaceAll('(', '').replaceAll(')', '');
  double lat =
      double.parse(formateLocation.split(',').first.replaceAll(' ', ''));
  double lang =
      double.parse(formateLocation.split(',').last.replaceAll(' ', ''));
  return GeoPoint(lat, lang);
}

bool isFirebaseStorageUrlRegex(String url) {
  final regex = RegExp(
      r'https://firebasestorage\.googleapis\.com/.*\?alt=media&token=.*');
  return regex.hasMatch(url);
}

String extraxtDoctorSpecialists(
    List<CategoryModel> specialists, WidgetRef ref) {
  List<String> extraxtedSpecialists = [];
  for (var mainSpecialist in specialists) {
    for (var specialist in mainSpecialist.subCategories) {
      extraxtedSpecialists.add(specialist.getLocalizedName(ref));
    }
  }

  return extraxtedSpecialists.join(',');
}

List<CategoryModel> filterCategoryByType(
    CategoryType categoryType, List<CategoryModel> list) {
  final List<CategoryModel> filterdList = [];

  for (var subCategory in list) {
    if (subCategory.categoryType == categoryType) {
      filterdList.add(subCategory);
    }
  }
  return filterdList;
}
