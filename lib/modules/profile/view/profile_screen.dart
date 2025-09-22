// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_back_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_images.dart';
import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/model/user_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool _isEditing = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isSaving = false;
  bool _isImageLoading = false;
  String? _base64Image;

  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  String? userUid;
  Future<void> _getUserIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.getString("userUID");

    if (mounted) {
      setState(() {
        userUid = result;
      });
    }

    debugPrint("==================================> UID => ($result)");
  }

  @override
  void initState() {
    super.initState();

    _getUserIdFromPrefs();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();

    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _mobileController = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Widget _buildProfileImage(UserModel userModel) {
    if (_isImageLoading) {
      return Center(child: appLoader());
    }

    if (_imageFile != null) {
      return Image.file(
        _imageFile!,
        width: 140.w,
        height: 140.w,
        fit: BoxFit.cover,
      );
    }

    // Add safety check for userModel.username
    // final safeUserName =
    //     userModel.username.isNotEmpty ? userModel.username : 'User';

    if (userModel.image.isNotEmpty) {
      if (_isBase64Image(userModel.image)) {
        try {
          return Image.memory(
            base64Decode(userModel.image),
            width: 140.w,
            height: 140.w,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildInitialsAvatar(userModel),
          );
        } catch (e) {
          return _buildInitialsAvatar(userModel);
        }
      } else if (userModel.image.startsWith('http')) {
        return Image.network(
          userModel.image,
          width: 140.w,
          height: 140.w,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                color: Color(AppColors.primaryColor),
              ),
            );
          },
          errorBuilder: (_, __, ___) => _buildInitialsAvatar(userModel),
        );
      } else if (userModel.image.startsWith('assets/')) {
        return Image.asset(
          userModel.image,
          width: 140.w,
          height: 140.w,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildInitialsAvatar(userModel),
        );
      }
    }

    return _buildInitialsAvatar(userModel);
  }

  Widget _buildInitialsAvatar(UserModel userModel) {
    final initials = _getInitials(userModel.username);

    // Additional safety check
    final displayInitials = initials.isEmpty ? '?' : initials;

    return Container(
      width: 140.w,
      height: 140.w,
      decoration: BoxDecoration(
        color: Color(AppColors.primaryColor).withOpacity(0.7),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        displayInitials,
        style: TextStyle(
          fontSize: 40.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';

    // Trim the name to remove any leading/trailing spaces
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return '?';

    final parts =
        trimmedName.split(' ').where((part) => part.isNotEmpty).toList();

    if (parts.isEmpty) return '?';

    // Safely get first character of first part
    final firstPart = parts[0];
    if (firstPart.isEmpty) return '?';
    final firstInitial = firstPart[0];

    // If there's only one part, return its first character
    if (parts.length == 1) {
      return firstInitial.toUpperCase();
    }

    // Safely get first character of last part
    final lastPart = parts.last;
    if (lastPart.isEmpty) return firstInitial.toUpperCase();
    final lastInitial = lastPart[0];

    return '$firstInitial$lastInitial'.toUpperCase();
  }

  bool _isBase64Image(String image) {
    return image.length > 100 &&
        !image.startsWith('http') &&
        !image.startsWith('assets/');
  }

  // Future<void> _pickImage() async {
  //   try {
  //     setState(() => _isImageLoading = true);
  //     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //     if (pickedFile != null) {
  //       final bytes = await File(pickedFile.path).readAsBytes();
  //       setState(() {
  //         _imageFile = File(pickedFile.path);
  //         _base64Image = base64Encode(bytes);
  //       });
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       mySnackBar(
  //         context,
  //         'Failed to pick image: $e',
  //         Color(AppColors.errorColor),
  //       );
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() => _isImageLoading = false);
  //     }
  //   }
  // }
  Future<void> _pickImage() async {
    try {
      setState(() => _isImageLoading = true);
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final file = File(pickedFile.path);

        // ✅ Compress image to reduce size before encoding
        final compressedBytes = await FlutterImageCompress.compressWithFile(
          file.absolute.path,
          minWidth: 600, // adjust size as needed
          minHeight: 600,
          quality: 70, // 0-100 (lower = more compression)
        );

        if (compressedBytes == null) {
          if (mounted) {
            mySnackBar(
              context,
              'Image compression failed',
              Color(AppColors.errorColor),
            );
          }
          return;
        }

        // ✅ Check size after compression
        final compressedSize = compressedBytes.length;
        final maxSize = 1024 * 1024; // 1 MB

        if (compressedSize > maxSize) {
          if (mounted) {
            mySnackBar(
              context,
              'Image is still too large even after compression (>${(compressedSize / 1024).toStringAsFixed(1)} KB).',
              Color(AppColors.errorColor),
            );
          }
          return;
        }

        setState(() {
          _imageFile = file;
          _base64Image = base64Encode(compressedBytes);
        });
      }
    } catch (e) {
      if (mounted) {
        mySnackBar(
          context,
          'Failed to pick image: $e',
          Color(AppColors.errorColor),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isImageLoading = false);
      }
    }
  }

  void _toggleEditMode(UserModel user) {
    if (_isEditing) {
      _saveProfileChanges(user);
    } else {
      _usernameController.text = user.username;
      _emailController.text = user.email;
      _mobileController.text = user.mobile;
    }
    setState(() => _isEditing = !_isEditing);
  }

  Future<void> _saveProfileChanges(UserModel user) async {
    if (_usernameController.text.trim().isEmpty) {
      mySnackBar(
        context,
        'Username cannot be empty',
        Color(AppColors.errorColor),
      );
      return;
    }

    // ✅ Add image size validation before saving
    if (_base64Image != null && _base64Image!.length > 1000000) {
      mySnackBar(
        context,
        "Image is too large! Please choose one under 1 MB.",
        Color(AppColors.errorColor),
      );
      return; // stop saving
    }

    setState(() => _isSaving = true);

    final updatedUser = user.copyWith(
      uid: userUid ?? user.uid,
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      mobile: _mobileController.text.trim(),
      image: _base64Image ?? user.image,
    );

    if (userUid == null || userUid == '') {
      mySnackBar(context, "User ID not found", Color(AppColors.errorColor));
      return;
    }

    try {
      final success = await ref
          .read(authControllerProvider)
          .saveUserToFirestore(updatedUser);
      final localSuccess = await ref
          .read(authControllerProvider)
          .saveUserToLocal(updatedUser);

      if (mounted) {
        if (success && localSuccess) {
          ref.invalidate(userModelProvider);
          mySnackBar(
            context,
            'Profile updated successfully!',
            Color(AppColors.successColor),
          );
        } else {
          throw Exception('Failed to save profile');
        }
      }
    } catch (e) {
      if (mounted) {
        mySnackBar(
          context,
          'Failed to update profile: ${e.toString()}',
          Color(AppColors.errorColor),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userModelAsync = ref.watch(userModelProvider);

    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient()),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(197, 0, 43, 53),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 90,
          leading: const AppBackButton(),
          title: AppText(
            text: AppLocalizations.of(context)!.yourProfile,
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            textColor: Color(AppColors.lightText),
          ),
          actions: [
            IconButton(
              icon: Image.asset(AppImages.barIcon, width: 25.w),
              onPressed: () {},
            ),
            IconButton(
              icon: Image.asset(AppImages.settingIcon, width: 25.w),
              onPressed: () {},
            ),
            SizedBox(width: 12.w),
          ],
        ),
        body: userModelAsync.when(
          data: (userModel) {
            if (userModel == null) {
              return Center(
                child: AppText(
                  text: "No user data available",
                  textColor: Colors.white,
                ),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.sp),
                child: SlideTransition(
                  position: _offsetAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 160.w,
                              height: 160.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(
                                      AppColors.primaryColor,
                                    ).withOpacity(0.6),
                                    Color(AppColors.blueLight).withOpacity(0.4),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 25,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: _isEditing ? _pickImage : null,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: _buildProfileImage(userModel),
                              ),
                            ),
                            if (_isEditing)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _isEditing ? _pickImage : null,
                                  child: Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: Color(AppColors.primaryColor),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 20.w,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      AnimatedOpacity(
                        opacity: 1,
                        duration: const Duration(milliseconds: 800),
                        child: Column(
                          children: [
                            AppText(
                              text:
                                  "${AppLocalizations.of(context)!.hey}, ${_isEditing ? _usernameController.text : userModel.username} 👋",
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              textColor: Colors.white,
                            ),
                            const SizedBox(height: 6),
                            AppText(
                              text:
                                  _isEditing
                                      ? _emailController.text
                                      : userModel.email,
                              textColor: Colors.white70,
                              fontSize: 15.sp,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white.withOpacity(0.05),
                              border: Border.all(
                                color: Colors.white12,
                                width: 1.2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(
                                      text:
                                          AppLocalizations.of(
                                            context,
                                          )!.profileDetails,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      textColor: Colors.white,
                                    ),
                                    _isSaving
                                        ? Padding(
                                          padding: EdgeInsets.all(8.w),
                                          child: SizedBox(
                                            width: 24.w,
                                            height: 24.w,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                        : IconButton(
                                          icon: Icon(
                                            _isEditing
                                                ? Icons.save
                                                : Icons.edit,
                                            color: Colors.white,
                                          ),
                                          onPressed:
                                              () => _toggleEditMode(userModel),
                                        ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _isEditing
                                    ? _buildEditableInfoTile(
                                      AppLocalizations.of(context)!.userName,
                                      _usernameController,
                                    )
                                    : _buildInfoTile(
                                      AppLocalizations.of(context)!.userName,
                                      userModel.username,
                                    ),
                                const SizedBox(height: 10),
                                _isEditing
                                    ? _buildEditableInfoTile(
                                      AppLocalizations.of(context)!.email,
                                      _emailController,
                                      enabled: false,
                                    )
                                    : _buildInfoTile(
                                      AppLocalizations.of(context)!.email,
                                      userModel.email,
                                    ),
                                const SizedBox(height: 10),
                                _isEditing
                                    ? _buildEditableInfoTile(
                                      AppLocalizations.of(context)!.mobile,
                                      _mobileController,
                                      keyboardType: TextInputType.phone,
                                    )
                                    : _buildInfoTile(
                                      AppLocalizations.of(context)!.mobile,
                                      userModel.mobile,
                                    ),
                                const SizedBox(height: 10),
                                _buildInfoTile(
                                  AppLocalizations.of(context)!.uid,
                                  userModel.uid,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (_isEditing) ...[
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                _isSaving
                                    ? null
                                    : () => _toggleEditMode(userModel),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(AppColors.primaryColor),
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child:
                                _isSaving
                                    ? appLoader()
                                    : AppText(
                                      text: "Save Changes",
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      textColor: Colors.white,
                                    ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => Center(child: appLoader()),
          error:
              (e, _) => Center(
                child: AppText(
                  text: "Error loading profile: $e",
                  textColor: Colors.redAccent,
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: title,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          textColor: Colors.white70,
        ),
        const SizedBox(height: 4),
        AppText(
          text: value.isNotEmpty ? value : "N/A",
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          textColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buildEditableInfoTile(
    String title,
    TextEditingController controller, {
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: title,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          textColor: Colors.white70,
        ),
        const SizedBox(height: 4),
        CustomTextField(
          controller: controller,
          hintText: "Enter $title",
          enabled: enabled,
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool enabled;
  final TextInputType keyboardType;
  final TextStyle? style;
  final InputDecoration? decoration;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.style,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      style:
          style ??
          TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
      decoration:
          decoration ??
          InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              vertical: 8.h,
              horizontal: 12.w,
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.white54,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white30),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white30),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
          ),
    );
  }
}
