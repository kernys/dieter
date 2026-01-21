// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '다이어트 AI';

  @override
  String get welcomeBack => '다시 오셨군요';

  @override
  String get signInToContinue => '영양 추적을 계속하려면 로그인하세요';

  @override
  String get createAccount => '계정 만들기';

  @override
  String get startYourJourney => '건강한 삶을 향한 여정을 시작하세요';

  @override
  String get email => '이메일';

  @override
  String get enterYourEmail => '이메일을 입력하세요';

  @override
  String get pleaseEnterEmail => '이메일을 입력해주세요';

  @override
  String get pleaseEnterValidEmail => '유효한 이메일을 입력해주세요';

  @override
  String get password => '비밀번호';

  @override
  String get enterYourPassword => '비밀번호를 입력하세요';

  @override
  String get createAPassword => '비밀번호를 만드세요';

  @override
  String get pleaseEnterPassword => '비밀번호를 입력해주세요';

  @override
  String get passwordMinLength => '비밀번호는 최소 6자 이상이어야 합니다';

  @override
  String get confirmPassword => '비밀번호 확인';

  @override
  String get reenterPassword => '비밀번호를 다시 입력하세요';

  @override
  String get pleaseConfirmPassword => '비밀번호를 확인해주세요';

  @override
  String get passwordsDoNotMatch => '비밀번호가 일치하지 않습니다';

  @override
  String get fullName => '이름';

  @override
  String get enterYourName => '이름을 입력하세요';

  @override
  String get pleaseEnterName => '이름을 입력해주세요';

  @override
  String get forgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get signIn => '로그인';

  @override
  String get signUp => '회원가입';

  @override
  String get signOut => '로그아웃';

  @override
  String get or => '또는';

  @override
  String get continueWithGoogle => 'Google로 계속하기';

  @override
  String get dontHaveAccount => '계정이 없으신가요? ';

  @override
  String get alreadyHaveAccount => '이미 계정이 있으신가요? ';

  @override
  String get skipForNow => '나중에 하기';

  @override
  String get termsOfService => '가입하시면 서비스 이용약관 및 개인정보 처리방침에 동의하게 됩니다';

  @override
  String loginFailed(String error) {
    return '로그인 실패: $error';
  }

  @override
  String signupFailed(String error) {
    return '회원가입 실패: $error';
  }

  @override
  String get trackCaloriesWithAI => 'AI로 칼로리 추적하기';

  @override
  String get trackCaloriesDescription => '음식 사진을 찍으면 AI가 즉시 영양 정보를 분석합니다';

  @override
  String get setYourDailyGoals => '일일 목표 설정하기';

  @override
  String get adjustAnytime => '설정에서 언제든지 조정할 수 있습니다';

  @override
  String get trackYourWeight => '체중 추적하기';

  @override
  String get optionalWeightGoals => '선택 사항: 체중 목표를 설정하세요';

  @override
  String get dailyCalories => '일일 칼로리';

  @override
  String get protein => '단백질';

  @override
  String get carbohydrates => '탄수화물';

  @override
  String get carbs => '탄수화물';

  @override
  String get fat => '지방';

  @override
  String get fats => '지방';

  @override
  String get calories => '칼로리';

  @override
  String get fiber => '식이섬유';

  @override
  String get sugar => '당류';

  @override
  String get sodium => '나트륨';

  @override
  String get healthScore => '건강 점수';

  @override
  String get currentWeight => '현재 체중';

  @override
  String get goalWeight => '목표 체중';

  @override
  String get changeGoal => '목표 변경';

  @override
  String get enterYourWeight => '체중을 입력하세요';

  @override
  String get enterGoalWeight => '목표 체중을 입력하세요';

  @override
  String get dateOfBirth => '생년월일';

  @override
  String get gender => '성별';

  @override
  String get male => '남성';

  @override
  String get female => '여성';

  @override
  String get other => '기타';

  @override
  String get dailyStepGoal => '일일 걸음 목표';

  @override
  String get steps => '걸음';

  @override
  String get notSet => '미설정';

  @override
  String get lbs => 'lb';

  @override
  String get kg => 'kg';

  @override
  String get weightKg => '체중 (kg)';

  @override
  String goalKg(int weight) {
    return '목표 $weight kg';
  }

  @override
  String get back => '뒤로';

  @override
  String get continue_ => '계속';

  @override
  String get getStarted => '시작하기';

  @override
  String get caloriesEaten => '섭취 칼로리';

  @override
  String get proteinEaten => '섭취 단백질';

  @override
  String get carbsEaten => '섭취 탄수화물';

  @override
  String get fatEaten => '섭취 지방';

  @override
  String get recentlyUploaded => '최근 기록';

  @override
  String get noMealsLoggedYet => '아직 기록된 식사가 없습니다';

  @override
  String get tapToAddFirstMeal => '+를 눌러 첫 식사를 추가하세요';

  @override
  String errorLoadingData(String error) {
    return '데이터 로딩 오류: $error';
  }

  @override
  String get home => '홈';

  @override
  String get progress => '진행 상황';

  @override
  String get groups => '그룹';

  @override
  String get groupsComingSoon => '그룹 기능이 곧 출시됩니다!';

  @override
  String get profile => '프로필';

  @override
  String get yourWeight => '현재 체중';

  @override
  String goal(int weight) {
    return '목표 $weight lb';
  }

  @override
  String get logWeight => '체중 기록';

  @override
  String get dayStreak => '연속 기록';

  @override
  String get weightProgress => '체중 변화';

  @override
  String percentOfGoal(int percent) {
    return '목표의 $percent%';
  }

  @override
  String get errorLoadingDataSimple => '데이터 로딩 오류';

  @override
  String get greatJobConsistency => '잘하고 있어요! 꾸준함이 핵심이고, 당신은 잘 해내고 있습니다!';

  @override
  String get dailyAverageCalories => '일일 평균 칼로리';

  @override
  String get cal => 'kcal';

  @override
  String get noWeightData => '체중 데이터 없음';

  @override
  String get weightLbs => '체중 (lb)';

  @override
  String get weightLogged => '체중이 기록되었습니다!';

  @override
  String get goalWeightUpdated => '목표 체중이 업데이트되었습니다!';

  @override
  String get height => '키';

  @override
  String get enterYourHeight => '키를 입력하세요';

  @override
  String get heightUpdated => '키가 업데이트되었습니다!';

  @override
  String get save => '저장';

  @override
  String get cancel => '취소';

  @override
  String get weeklyEnergy => '주간 에너지';

  @override
  String get burned => '소모';

  @override
  String get consumed => '섭취';

  @override
  String get energy => '에너지';

  @override
  String get yourBMI => '나의 BMI';

  @override
  String get bmiUnderweight => '저체중';

  @override
  String get bmiNormal => '정상';

  @override
  String get bmiOverweight => '과체중';

  @override
  String get bmiObese => '비만';

  @override
  String get heightNotSet => '프로필에서 키를 설정하세요';

  @override
  String get range90d => '90일';

  @override
  String get range6m => '6개월';

  @override
  String get range1y => '1년';

  @override
  String get rangeAll => '전체';

  @override
  String get edit => '편집';

  @override
  String get dailyGoals => '일일 목표';

  @override
  String get settings => '설정';

  @override
  String get notifications => '알림';

  @override
  String get language => '언어';

  @override
  String get english => '영어';

  @override
  String get korean => '한국어';

  @override
  String get units => '단위';

  @override
  String get imperial => '야드파운드법';

  @override
  String get metric => '미터법';

  @override
  String get darkMode => '다크 모드';

  @override
  String get off => '끔';

  @override
  String get on => '켬';

  @override
  String get privacy => '개인정보';

  @override
  String get helpAndSupport => '도움말 및 지원';

  @override
  String get goalsAndTracking => '목표 및 추적';

  @override
  String get personalDetails => '개인 정보';

  @override
  String get weightHistory => '체중 기록';

  @override
  String get app => '앱';

  @override
  String get rateApp => '앱 평가하기';

  @override
  String get shareApp => '앱 공유하기';

  @override
  String get about => '정보';

  @override
  String get signOutConfirmTitle => '로그아웃';

  @override
  String get signOutConfirmMessage => '정말 로그아웃하시겠습니까?';

  @override
  String get share => '공유';

  @override
  String get delete => '삭제';

  @override
  String get deleteEntry => '항목 삭제';

  @override
  String get deleteEntryConfirm => '이 음식 기록을 삭제하시겠습니까?';

  @override
  String get sharedFromDieterAI => 'Diet AI에서 공유됨 🍎';

  @override
  String get entryDeleted => '항목이 삭제되었습니다';

  @override
  String get savePhotoToGallery => '사진을 갤러리에 저장';

  @override
  String get photoSaved => '사진이 갤러리에 저장되었습니다';

  @override
  String get failedToSavePhoto => '사진 저장에 실패했습니다';

  @override
  String get cameraNotAvailable => '카메라를 사용할 수 없습니다';

  @override
  String cameraError(String error) {
    return '카메라 오류: $error';
  }

  @override
  String get pickFromGallery => '갤러리에서 선택';

  @override
  String get scanFood => '음식 스캔';

  @override
  String get barcode => '바코드';

  @override
  String get foodLabel => '영양 성분표';

  @override
  String get zoomHalf => '.5x';

  @override
  String get zoomOne => '1x';

  @override
  String get analyzingFood => '음식 분석 중...';

  @override
  String get failedToCaptureImage => '이미지 캡처 실패';

  @override
  String analysisFailed(String error) {
    return '분석 실패: $error';
  }

  @override
  String get howToUse => '사용 방법';

  @override
  String get howToUseStep1 => '1. 카메라를 음식에 맞추세요';

  @override
  String get howToUseStep2 => '2. 음식이 잘 보이는지 확인하세요';

  @override
  String get howToUseStep3 => '3. 카메라 버튼을 눌러 분석하세요';

  @override
  String get howToUseStep4 => '4. 결과를 검토하고 필요시 수정하세요';

  @override
  String get gotIt => '확인';

  @override
  String get nutrition => '영양 정보';

  @override
  String get unknownFood => '알 수 없는 음식';

  @override
  String get ingredients => '재료';

  @override
  String get addMore => '추가';

  @override
  String get noIngredientsDetected => '감지된 재료 없음';

  @override
  String get fixResults => '결과 수정';

  @override
  String get done => '완료';

  @override
  String get addIngredient => '재료 추가';

  @override
  String get name => '이름';

  @override
  String get amountOptional => '양 (선택 사항)';

  @override
  String get add => '추가';

  @override
  String get foodName => '음식 이름';

  @override
  String get proteinG => '단백질 (g)';

  @override
  String get carbsG => '탄수화물 (g)';

  @override
  String get fatG => '지방 (g)';

  @override
  String get foodEntrySaved => '음식 기록이 저장되었습니다!';

  @override
  String failedToSave(String error) {
    return '저장 실패: $error';
  }

  @override
  String get defaultUserName => '사용자';

  @override
  String get defaultUserEmail => 'user@example.com';

  @override
  String get mealReminders => '식사 알림';

  @override
  String get mealRemindersDescription => '식사 기록 알림을 받습니다';

  @override
  String get weightReminders => '체중 알림';

  @override
  String get weightRemindersDescription => '체중 기록 알림을 받습니다';

  @override
  String get weeklyReports => '주간 리포트';

  @override
  String get weeklyReportsDescription => '주간 진행 상황 요약을 받습니다';

  @override
  String get savedToFavorites => '즐겨찾기에 저장됨';

  @override
  String get removedFromSaved => '저장된 음식에서 삭제됨';

  @override
  String get savedFoods => '저장된 음식';

  @override
  String get noSavedFoods => '저장된 음식이 없습니다';

  @override
  String get logThisFood => '이 음식 기록하기';

  @override
  String get party => '파티';

  @override
  String get partyComingSoon => '곧 오픈합니다! 🎉';

  @override
  String get partyDescription =>
      '친구들과 함께 다이어트 목표를 달성하고 서로 응원하며 건강한 습관을 만들어보세요.';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get exercise => '운동';

  @override
  String get logExercise => '운동 기록';

  @override
  String get run => '러닝';

  @override
  String get runDescription => '달리기, 조깅, 스프린트 등';

  @override
  String get weightLifting => '웨이트 트레이닝';

  @override
  String get weightLiftingDescription => '기구, 프리웨이트 등';

  @override
  String get describe => '설명';

  @override
  String get describeDescription => '운동을 글로 설명하세요';

  @override
  String get manual => '직접 입력';

  @override
  String get manualDescription => '소모한 칼로리를 직접 입력하세요';

  @override
  String get intensity => '강도';

  @override
  String get low => '낮음';

  @override
  String get medium => '중간';

  @override
  String get high => '높음';

  @override
  String get durationMinutes => '시간 (분)';

  @override
  String get enterDuration => '시간 입력';

  @override
  String runLogged(int duration, String intensity) {
    return '러닝 기록됨: $duration분 ($intensity 강도)';
  }

  @override
  String exerciseLogged(String type, int duration) {
    return '$type 기록됨: $duration분';
  }

  @override
  String get describeYourWorkout => '운동을 설명하세요';

  @override
  String get describeHint => '예: \"30분 요가와 팔굽혀펴기 20회\"';

  @override
  String get exerciseLoggedSuccess => '운동이 기록되었습니다!';

  @override
  String get caloriesBurned => '소모 칼로리';

  @override
  String get enterCaloriesBurned => '소모 칼로리 입력';

  @override
  String caloriesBurnedLogged(int calories) {
    return '$calories칼로리 소모 기록됨!';
  }

  @override
  String get lightWeights => '가벼움';

  @override
  String get moderateWeights => '보통';

  @override
  String get heavyWeights => '무거움';

  @override
  String weightLiftingLogged(int duration, String intensity) {
    return '웨이트 트레이닝 기록됨: $duration분 ($intensity 강도)';
  }

  @override
  String get analyzingExercise => '운동 분석 중...';

  @override
  String get exerciseAnalysisFailed => '운동 분석에 실패했습니다';

  @override
  String get logFood => '음식 기록';

  @override
  String get all => '전체';

  @override
  String get myFoods => '내 음식';

  @override
  String get myMeals => '내 식사';

  @override
  String get describeWhatYouAte => '먹은 음식을 설명하세요';

  @override
  String get suggestions => '추천';

  @override
  String get manualAdd => '직접 추가';

  @override
  String get voiceLog => '음성 기록';

  @override
  String get noCustomFoodsYet => '저장된 음식이 없습니다';

  @override
  String get foodsYouCreateWillAppearHere => '생성한 음식이 여기에 표시됩니다.';

  @override
  String get noSavedMealsYet => '저장된 식사가 없습니다';

  @override
  String get combineFoodsIntoMeals => '음식을 조합하여 빠르게 기록하세요.';

  @override
  String get tapToSaveHere => '음식에서 북마크를 눌러 저장하세요.';

  @override
  String get pleaseSignInToLogFood => '음식을 기록하려면 로그인하세요';

  @override
  String failedToLogFood(String error) {
    return '음식 기록 실패: $error';
  }

  @override
  String addedFood(String name) {
    return '$name 추가됨';
  }

  @override
  String get voiceLoggingComingSoon => '음성 기록 기능이 곧 출시됩니다';

  @override
  String get addFoodManually => '직접 음식 추가';

  @override
  String get addFood => '음식 추가';

  @override
  String get weightChanges => '체중 변화';

  @override
  String get day3 => '3일';

  @override
  String get day7 => '7일';

  @override
  String get day14 => '14일';

  @override
  String get day30 => '30일';

  @override
  String get day90 => '90일';

  @override
  String get allTime => '전체';

  @override
  String get noChange => '변화 없음';

  @override
  String get increase => '증가';

  @override
  String get decrease => '감소';

  @override
  String get barcodeScanner => '바코드 스캐너';

  @override
  String get barcodeScannerDescription =>
      '식품 포장의 바코드에 카메라를 맞추면 즉시 영양 정보를 확인할 수 있습니다.';

  @override
  String get barcodeTip1 => '바코드에 조명이 잘 비치도록 하세요';

  @override
  String get barcodeTip2 => '바코드를 프레임 중앙에 맞추세요';

  @override
  String get barcodeTip3 => '휴대폰을 흔들리지 않게 잡으세요';

  @override
  String get nutritionLabelScanner => '영양 성분표 스캐너';

  @override
  String get nutritionLabelDescription => '영양 성분표에서 정확한 정보를 가져와 섭취량을 추적하세요.';

  @override
  String get quote1 => '오늘 하루도 건강하게 시작해요! 💪';

  @override
  String get quote2 => '작은 변화가 큰 결과를 만듭니다.';

  @override
  String get quote3 => '꾸준함이 최고의 무기입니다.';

  @override
  String get quote4 => '건강한 식단이 행복한 삶을 만듭니다.';

  @override
  String get quote5 => '오늘의 노력이 내일의 나를 만듭니다.';

  @override
  String get quote6 => '포기하지 마세요, 당신은 할 수 있어요!';

  @override
  String get quote7 => '한 걸음씩, 목표를 향해 나아가요.';

  @override
  String get quote8 => '건강은 가장 소중한 재산입니다.';

  @override
  String get quote9 => '오늘도 멋진 선택을 하셨네요! ✨';

  @override
  String get quote10 => '당신의 노력은 배신하지 않습니다.';

  @override
  String get quote11 => '매일 조금씩, 더 나은 내가 되어가요.';

  @override
  String get quote12 => '건강한 몸에 건강한 마음이 깃듭니다.';

  @override
  String get quote13 => '작심삼일? 오늘부터 다시 시작하면 됩니다!';

  @override
  String get quote14 => '스스로를 믿으세요, 당신은 대단해요.';

  @override
  String get quote15 => '좋은 습관이 좋은 인생을 만듭니다.';

  @override
  String get roleModel => '롤모델';

  @override
  String get addRoleModel => '자극 사진 추가하기';

  @override
  String get roleModelMotivation => '이게 바로 내 목표!';

  @override
  String get chooseFromGallery => '갤러리에서 선택';

  @override
  String get takePhoto => '사진 찍기';

  @override
  String get removePhoto => '사진 삭제';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get privacyIntroTitle => '소개';

  @override
  String get privacyIntroContent =>
      'Diet AI(이하 \"당사\")는 귀하의 개인정보 보호를 중요하게 생각합니다. 본 개인정보 처리방침은 모바일 애플리케이션 사용 시 귀하의 정보를 어떻게 수집, 사용 및 보호하는지 설명합니다.';

  @override
  String get privacyDataCollectionTitle => '수집하는 정보';

  @override
  String get privacyDataCollectionContent =>
      '당사는 귀하가 직접 제공하는 정보를 수집합니다:\n\n• 계정 정보 (이메일, 이름)\n• 건강 데이터 (체중, 식사 기록, 운동 기록)\n• AI 분석을 위한 음식 사진\n• 기기 정보 및 사용 데이터\n\n당사는 귀하의 개인정보를 제3자에게 판매하지 않습니다.';

  @override
  String get privacyDataUseTitle => '정보 사용 방법';

  @override
  String get privacyDataUseContent =>
      '당사는 귀하의 정보를 다음 목적으로 사용합니다:\n\n• 서비스 제공 및 개선\n• AI 기술을 사용한 음식 사진 분석\n• 영양 및 피트니스 진행 상황 추적\n• 알림 및 리마인더 전송 (활성화된 경우)\n• 서비스 관련 커뮤니케이션';

  @override
  String get privacyDataProtectionTitle => '데이터 보안';

  @override
  String get privacyDataProtectionContent =>
      '당사는 귀하의 개인정보를 보호하기 위해 적절한 보안 조치를 시행합니다. 귀하의 데이터는 전송 중 암호화되며 안전하게 저장됩니다. 다만, 인터넷을 통한 전송 방법은 100% 안전하지 않습니다.';

  @override
  String get privacyUserRightsTitle => '귀하의 권리';

  @override
  String get privacyUserRightsContent =>
      '귀하는 다음과 같은 권리가 있습니다:\n\n• 개인 데이터에 대한 접근\n• 데이터 수정 요청\n• 계정 및 데이터 삭제 요청\n• 마케팅 커뮤니케이션 수신 거부\n\n이러한 권리를 행사하려면 당사에 문의해 주세요.';

  @override
  String get privacyContactTitle => '문의하기';

  @override
  String get privacyContactContent =>
      '본 개인정보 처리방침에 대해 질문이 있으시면 다음으로 연락해 주세요:\n\nkernys01@gmail.com';

  @override
  String get privacyLastUpdated => '최종 업데이트: 2025년 1월';

  @override
  String get customerSupport => '고객 지원';

  @override
  String get contactUs => '문의하기';

  @override
  String get sendEmail => '이메일 보내기';

  @override
  String get deleteWeightLog => '체중 기록 삭제';

  @override
  String get deleteWeightLogConfirm => '이 체중 기록을 삭제하시겠습니까?';

  @override
  String get weightLogDeleted => '체중 기록이 삭제되었습니다';

  @override
  String get errorDeletingWeightLog => '체중 기록 삭제 중 오류가 발생했습니다';

  @override
  String get tapToName => '이름 입력';

  @override
  String get ingredientsHidden => '재료 숨김';

  @override
  String get learnWhy => '자세히 알아보기';

  @override
  String get log => '기록';

  @override
  String get servings => '인분';

  @override
  String get pleaseEnterFoodName => '음식 이름을 입력해주세요';

  @override
  String get foodLogged => '음식이 기록되었습니다';

  @override
  String get errorLoggingFood => '음식 기록 중 오류가 발생했습니다';

  @override
  String get voiceRecording => '음성 기록';

  @override
  String get tapToRecord => '탭하여 녹음';

  @override
  String get recording => '녹음 중...';

  @override
  String get analyzing => '분석 중...';

  @override
  String get speakNow => '먹은 음식을 말씀해주세요';

  @override
  String get searchResults => '검색 결과';

  @override
  String get noSearchResults => '검색 결과가 없습니다';
}
