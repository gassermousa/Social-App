import 'package:social_app/models/post_model.dart';

abstract class SocialStates {}

class SocialInitialStates extends SocialStates {}

class SocialGetUserLoadingStates extends SocialStates {}

class SocialGetUserSuccessStates extends SocialStates {}

class SocialGetUserErrorStates extends SocialStates {
  final String error;
  SocialGetUserErrorStates(this.error);
}

class SocialGetAllUserLoadingStates extends SocialStates {}

class SocialGetAllUserSuccessStates extends SocialStates {}

class SocialGetAllUserErrorStates extends SocialStates {
  final String error;
  SocialGetAllUserErrorStates(this.error);
}

class ChangeBottomNavBarState extends SocialStates {}

class SocialPostState extends SocialStates {}

class SocialChangeMode extends SocialStates {}

class SocialProfileImagePickedSuccess extends SocialStates {}

class SocialProfileImagePickedErorr extends SocialStates {}

class SocialCoverImagePickedSuccess extends SocialStates {}

class SocialCoverImagePickedErorr extends SocialStates {}

class SocialUploadProfileImageSuccess extends SocialStates {}

class SocialUploadProfileImageErorr extends SocialStates {}

class SocialUploadCoverImageSuccess extends SocialStates {}

class SocialUploadCoverImageErorr extends SocialStates {}

class SocialUpdateUserLoading extends SocialStates {}

class SocialUpdateUserErorr extends SocialStates {}

class SocialCreatePostLoading extends SocialStates {}

class SocialCreatePostSuccsess extends SocialStates {}

class SocialCreatePostError extends SocialStates {}

class SocialPostImagePickedSuccess extends SocialStates {}

class SocialPostImagePickedErorr extends SocialStates {}

class SocialPostImageRemovedState extends SocialStates {}

class SocialGetPostsLoadingStates extends SocialStates {}

class SocialGetPostsSuccessStates extends SocialStates {}

class SocialGetPostsErrorStates extends SocialStates {
  final String error;
  SocialGetPostsErrorStates(this.error);
}

class SocialLikePostsSuccessStates extends SocialStates {}

class SocialLikePostsErrorStates extends SocialStates {
  final String error;
  SocialLikePostsErrorStates(this.error);
}

class SocialGetLikespostSuccessState extends SocialStates {}

class SocialSendMessageSuccessState extends SocialStates {}

class SocialSendMessageErrorState extends SocialStates {}

class SocialGetMessagesSuccessState extends SocialStates {}

class SocialGetMessagesErrorState extends SocialStates {}

class DisLikeSuccessState extends SocialStates {}

class DisLikeErrorState extends SocialStates {}

class GetLikesSuccessState extends SocialStates {}

class SendCommentSuccessState extends SocialStates {}

class SendCommentErrorState extends SocialStates {}

class SocialCommentImagePickedSuccess extends SocialStates {}

class SocialCommentImagePickedErorr extends SocialStates {}

class SocialUploadCommentImageSuccess extends SocialStates {}

class SocialUploadCommentImageErorr extends SocialStates {}

class GetCommentsSuccessState extends SocialStates {}

class SocialCommentImageRemovedState extends SocialStates {}

class SendMessageSuccessState extends SocialStates {}

class SetUSerTokenLoadingState extends SocialStates {}

class SetUSerTokenSuccessState extends SocialStates {}

class GettokenSuccessState extends SocialStates {}

class SendInAppNotificationLoadingState extends SocialStates {}

class SendInAppNotificationSuccessState extends SocialStates {}

class SendInAppNotificationErrorState extends SocialStates {}

class ReadNotificationSuccessState extends SocialStates {}

class GetInAppNotificationLoadingState extends SocialStates {}

class GetInAppNotificationSuccessState extends SocialStates {}

class GetPostLoadingState extends SocialStates {}

class GetSinglePostSuccessState extends SocialStates {
  final PostModel post;
  GetSinglePostSuccessState(this.post);
}

class GetPostErrorState extends SocialStates {}

class SetNotificationIdSuccessState extends SocialStates {}

class DeletePostSuccessState extends SocialStates {}

class SociaMessageImagePickedSuccess extends SocialStates {}

class SocialMessageImagePickedErorr extends SocialStates {}

class SocialUploadMessageImageSuccess extends SocialStates {}

class SocialUploadMessageImageErorr extends SocialStates {}

class SocialMessageImageRemovedState extends SocialStates {}

class SignOutLoadingState extends SocialStates {}

class SignOutSuccessState extends SocialStates {}

class SignOutErrorState extends SocialStates {}
