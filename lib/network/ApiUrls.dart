const String baseUrl = 'https://apilive.voicee.co/';
const String termsUrl = 'https://voicee.co/terms.html';

// ****************** login Api **************** //
const String loginGoogle = 'auth/login/gmail';
const String loginTwitter = 'auth/login/android-twitter';
const String loginFacebook = 'auth/login/android-facebook';
const String loginApple = 'auth/login/apple';

// ****************** User Country, State, Ac, Pc Api **************** //
const String userCountry = 'user/country';
const String userState = 'user/country-state/';
const String userDistrictAcPc = 'user/state-districts/';
const String userAcPc = 'user/district-ac-pc/';

// ****************** POST Related Api **************** //
const String allUserPosts = 'user/post';
const String upVotePostsApi = 'user/like-post/';
const String downVotePostsApi = 'user/dislike-post/';
const String uploadAudio = 'user/upload';
const String savePost = 'user/post';
const String replyPost = 'user/comment-post';
const String commentPosts = 'user/users-commented-post';
const String replyPostUpVote = 'user/like-comment/';
const String replyPostDownVote = 'user/dislike-comment/';

// ****************** REACTIONS Related Api **************** //
const String getPostLikedBy = 'user/users-liked-post/';
const String getPostCommentBy = 'user/users-commented-post/';
const String getPostDisLikedBy = 'user/users-disliked-post/';
const String getPostSharedBy = 'user/users-shared-post/';

// ****************** Profile Related Api **************** //
const String userProfile = 'user/profile';
const String userChannel = 'user/channel-details/';
const String userProfileInfo = 'user/update-profile';
const String uploadGeneral = 'user/upload-general';
const String sharePost = 'user/share-post/';
const String shareComment = 'user/share-comment/';
const String reportPost = 'user/report-post/';
const String updateFcmToken = 'user/firebase';
const String publicProfile = 'user/fetch-public-profile';
const String searchResults = 'user/search-user';
const String reportUsers = 'user/report-user';

// ****************** Channel Related Api **************** //
const String channelDetail = 'user/channel-details/';
const String channelPosts = 'user/post?channelId=';

// ****************** Topics Related Api **************** //
const String topics = 'user/topic';
const String saveTopics = 'user/choose-topics';
const String removeTopics = 'user/remove-topic';
const String sendOTP = 'user/send-otp';
const String verifyOTP = 'user/verify-otp';
const String resendOTP = 'user/resend-otp';
const String channelList = 'user/channel';
const String userFollowers = 'user/followers';
const String userFollowings = 'user/followings';
const String userFollow = 'user/follow-user';
const String userNotifications = 'user/fetch-notifications';
