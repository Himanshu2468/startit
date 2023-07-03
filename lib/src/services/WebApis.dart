class WebApis {
  static String ROOT_URL = "http://164.52.192.76:8080/";
  static String BASE_URL = ROOT_URL + "startit/frontapi/";

  static String SIGNUP = BASE_URL + "User/createAccount";
  static String SECURITY_QUESTION = BASE_URL + "User/getSecurityQueston";
  static String VERIFY_OTP = BASE_URL + "User/verifyMobileOtp";
  static String RESEND_OTP = BASE_URL + "User/resendOtp";
  static String SET_PASSWORD = BASE_URL + "User/setPassword";
  static String GET_USER_ROLE = BASE_URL + "Master/getRoleList";
  static String UPDATE_USER_ROLE = BASE_URL + "User_role/UpdateRole";
  static String ADD_TOKEN_ID = BASE_URL + "User/addDeviceToken";

  static String COUNTRY = BASE_URL + "Master/getCountryList";
  static String STATE = BASE_URL + "Master/getStateListByCtrId";
  static String CITY = BASE_URL + "Master/getCityListByStateId";
  static String CATEGORY = BASE_URL + "Master/getCategoryList";
  static String SUB_CATEGORY = BASE_URL + "Master/get_all_subcat_by_cid";
  static String FALL_SUB_CATEGORY =
      BASE_URL + "Master/get_all_fallsubcat_by_scid";
  static String TRADE = BASE_URL + "Master/getAllTrade";
  static String EMPLOYMENT_TYPE = BASE_URL + "Master/getAllEmplayeementType";
  static String SELECT_NATURE_WORK = BASE_URL + "Master/getNatureOfWork";
  static String BUSINESS = BASE_URL + "Master/occupationBusiness";

  static String ADD_BIP = BASE_URL + "Bip/AddBip";
  static String EDIT_BIP = BASE_URL + "Bip/BipSecondStep";
  static String ADD_BIP_FINAL = BASE_URL + "Bip/BipFinalStep";
  static String ADD_BIP_IDEA = BASE_URL + "Bip/addBipIdea";
  static String ADD_BIP_IDEA_SECOND = BASE_URL + "Bip/addBipIdeaStepSecond";
  static String ADD_BIP_IDEA_THIRD = BASE_URL + "Bip/addBipIdeaStepThird";
  static String ADD_BIP_IDEA_MEDIA = BASE_URL + "Bip/addBipIdeaMedia";
  static String ADD_BIP_IDEA_MEDIA_PRIVACY =
      BASE_URL + "Bip/addBipIdeaMediaPrivacy";
  static String RESOURCES = BASE_URL + "Master/getResources";
  static String ADD_BIP_RESOURCES = BASE_URL + "Bip/addBipIdeaResource";
  static String ADD_BIP_IDEA_STAGE = BASE_URL + "Bip/addBipIdeaStage";
  static String BIP_INVITE_FRIEND = BASE_URL + "Bip/inviteFriend";
  static String BIP_ADD_FRIEND = BASE_URL + "Bip/addFreind";

  static String ADD_INVESTOR = BASE_URL + "ins/addIns";
  static String INVESTOR_LOCATION = BASE_URL + "Ins/InsSecondStep";
  static String INS_SUB_CATEGORY = BASE_URL + "Master/get_all_subcat_by_cat_in";
  static String INS_FALL_SUB_CATEGORY =
      BASE_URL + "Master/get_all_functional_cat_by_subcat_ids";
  static String ADD_EDIT_INVESTOR_IDEA = BASE_URL + "Ins/addInsInterestIdea";
  static String ADD_EDIT_INVESTOR_IDEA_MEDIA =
      BASE_URL + "Ins/addInsInterestMedia";
  static String ADD_EDIT_INVESTOR_CAPABILITIES =
      BASE_URL + "Ins/addInsCapabilities";
  static String ADD_INS_CAPABILITIES_MEDIA =
      BASE_URL + "Ins/addInsCapabilitiesMedia";
  static String INVESTOR_BUSINESS_CATEGORY = BASE_URL + "Master/getBusinessCat";

  static String ADD_PRODUCT_PROVIDER = BASE_URL + "Pp/addPp";
  static String PRODUCT_PROVIDER_LOCATION = BASE_URL + "Pp/PpSecondStep";
  static String ADD_PRODUCT_CATEGORIES = BASE_URL + "Pp/addProduct";
  static String ADD_PRODUCT_SKILLS = BASE_URL + "Pp/addProductThirdStep";
  static String ADD_PRODUCT_MEDIA = BASE_URL + "Pp/addProductFourStep";
  static String BUSINESS_DETAILS = BASE_URL + "Pp/addProductSecondStep";
  static String DEL_CATEGORY = BASE_URL + "Master/getdeliverablecategory";
  static String DEL_SUBCATEGORY = BASE_URL + "Master/getdeliverableSubcategory";
  static String DEL_FUNCTIONAL_CATEGORY =
      BASE_URL + "Master/getdeliverableFunctionalcategory";
  static String GET_SUGGESTED_IDEAS_PP_LIST = BASE_URL + "Pp/suggestedIdea";

  static String ADD_SP = BASE_URL + "Sp/AddSp";
  static String EDIT_SP = BASE_URL + "Sp/SpSecondStep";
  static String APP_SP_FINAL = BASE_URL + "Sp/SpFinalStep";
  static String SERVICE_MEDIA = BASE_URL + "Sp/spServiceMedia";
  static String ADD_SERVICE_SKILLS = BASE_URL + "Sp/serviceSkills";
  static String SERVICE_CATEGORY = BASE_URL + "Sp/addServiceCategory";
  static String GET_DOMAIN = BASE_URL + "Master/serviceDomain";
  static String ADD_DOMAIN = BASE_URL + "Sp/spDomain";
  static String GET_MYSERVICES = BASE_URL + "Sp/myservice";
  static String VIEW_SERVICE = BASE_URL + "Sp/singleService";
  static String GET_SUGGESTED_IDEAS_SP_LIST = BASE_URL + "Sp/suggestedIdea";

  static String USER_LOGIN = BASE_URL + "User/login";
  static String GOOGLE_LOGIN = BASE_URL + "User/googlelogin";
  static String FACEBOOK_LOGIN = BASE_URL + "User/fblogin";
  static String PROFILE_IMAGE = BASE_URL + "User/addProfileImage";

  static String IDEA_LIST = BASE_URL + "Bip/myIdeaList";
  static String VIEW_IDEA = BASE_URL + "Bip/ideaDetails";
  static String VIEW_PROFILE = BASE_URL + "User/viewProfile";
  static String MANAGE_INVESTORS = BASE_URL + "Bip/manageInvestor";
  static String VIEW_INVESTOR_PROFILE = BASE_URL + "Ins/getInsIdeaDetails";
  static String ACCEPT_REQUEST = BASE_URL + "Bip/acceptIdeaRequest";
  static String DECLINE_REQUEST = BASE_URL + "Bip/declineIdeaRequest";
  static String ADD_CUSTOM_IDEA_PRIVACY =
      BASE_URL + "Bip/addManageInsIdeaPrivacy";
  static String ADD_CUSTOM_MEDIA_PRIVACY =
      BASE_URL + "Bip/addManageInsIdeaMediaPrivacy";
  static String ADD_SUCCESS_STORY = BASE_URL + "Bip/successStory";
  // static String GET_PRODUCT_PROVIDERS = BASE_URL + "Pp/productProviderList";
  // static String GET_SERVICE_PROVIDERS = BASE_URL + "Sp/serviceProviderList";

  static String GET_PRODUCT_PROVIDERS = BASE_URL + "Pp/getPp";
  static String GET_SERVICE_PROVIDERS = BASE_URL + "Sp/getSp";

  static String GET_LIKERS_LIST = BASE_URL + "Bip/likeUserList";
  static String GET_VISITORS_LIST = BASE_URL + "Bip/viewIdeaUserList";

  static String ALL_IDEA = BASE_URL + "Bip/allIdea";
  static String MANAGE_IDEA_PERSON = BASE_URL + "Ins/manageBip";
  static String MY_CAPABILITIES = BASE_URL + "Ins/Inscapabilities";
  static String MY_INTERESTS = BASE_URL + "Ins/getInsIdea";
  static String I_M_INTERESTED = BASE_URL + "Ins/IMinterested";
  static String CREATE_MEETING = BASE_URL + "Ins/createMeeting";
  static String LEAVE_MEETING = BASE_URL + "Ins/LeaveMeeting";
  static String GET_INTERESTED_IDEAS_LIST =
      BASE_URL + "Ins/getInsInterestedIdeaList";
  static String GET_SUGGESTED_IDEAS_LIST = BASE_URL + "Ins/suggestedIdea";

  static String MY_PRODUCT = BASE_URL + "Pp/myproduct";
  static String VIEW_SINGLE_PRODUCT = BASE_URL + "Pp/singleProduct";
  static String FORGOT_USER_ID = BASE_URL + "User/fogotUserId";
  static String FORGOT_PASSWORD = BASE_URL + "User/forgotPassword";
  static String DELETE_BIP_MEDIA = BASE_URL + "Bip/removeMedia";
  static String DELETE_INS_CAP_MEDIA = BASE_URL + "Ins/removeInsCapMedia";
  static String DELETE_QUESTIONAIR_INS = BASE_URL + "Ins/removeInsIdeaMedia";
  static String DELETE_PP_UPPER_MEDIA = BASE_URL + "Pp/removePpServiceMedia";
  static String DELETE_PP_LOWER_MEDIA = BASE_URL + "Pp/removePpBrochureMedia";
  static String DELETE_SP_UPPER_MEDIA = BASE_URL + "Sp/removeSpServiceMedia";
  static String DELETE_SP_LOWER_MEDIA = BASE_URL + "Sp/removeSpBrochureMedia";

  static String IDEA_VISITS = BASE_URL + "Bip/bipVisitors";
  static String IDEA_LIKES = BASE_URL + "Bip/bipLikes";
  static String IS_IDEA_ALREADY_LIKED = BASE_URL + "Bip/bipLikesByUser";
  static String CHANGE_PASSWORD = BASE_URL + "User/changePassword";

  static String GET_NOTIFICATIONS = BASE_URL + "User/getNotificationByUserId";
  static String NOTIFICATIONS_Y_N =
      BASE_URL + "User/updateNotificationViewersId";

  static String SKILLS = BASE_URL + "Master/getResourcesByids";
  static String GET_SUGGESTED_IDEAS = BASE_URL + "User/suggestedIdea";
  static String GET_TOKEN_SENDER_RECEIVER =
      BASE_URL + "User/getSenderReceiverToken";
  static String GET_SUGGESTIONS = BASE_URL + "User/searchResult";
  static String GET_SERVICE_LIST = BASE_URL + "Sp/getSpServiceList";
  static String GET_SPSINGLE_LIST = BASE_URL + "Sp/singleService";
  static String GET_PPSINGLE_LIST = BASE_URL + "Pp/singleProduct";
  static String GET_CHAT_GROUP = BASE_URL + "User/getChatGroup";
  static String GET_INTERESTED_INS_LIST =
      BASE_URL + "User/getInterestedInsList";
  static String ADD_MEMBER_GROUP = BASE_URL + "User/addMemberInGroup";
  static String EMAIL_SEARCH_USER = BASE_URL + "User/searchUserByEmail";
  static String DELETE_MEMBER_GROUP = BASE_URL + "User/deleteMember";
  static String BIP_DASHBOARD = BASE_URL + "Bip/bipdashboard";
  static String INS_DASHBOARD_SUGGESTED_IDEAS = BASE_URL + "Ins/insDashboard";
  static String SHARE_SP_PROFILE = BASE_URL + "sp/spProfileByuserId";
  static String SHARE_PP_PROFILE = BASE_URL + "pp/ppProfileByuserId";
  static String GET_SUCCESS_PATH = BASE_URL + "Bip/getBipIdeaSuccessPath";
  static String GET_RESOURCE_PROVIDER_SKILL_ID =
      BASE_URL + "bip/getRpsBySkillId";
  static String GET_REPORT_REASON = BASE_URL + "user/spamReasionMaster";
  static String REPORT_PERSON = BASE_URL + "user/spamReport";
  static String CHECK_REPORTED = BASE_URL + "User/checkSpamData";
  static String GET_USERNAME_BY_USERID = BASE_URL + "User/getfullNameByUserId";
  static String RECONNECT_USER = BASE_URL + "User/reconnect";
}
