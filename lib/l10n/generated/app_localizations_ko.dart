// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '다이어터 AI';

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
  String get currentWeight => '현재 체중';

  @override
  String get goalWeight => '목표 체중';

  @override
  String get enterYourWeight => '체중을 입력하세요';

  @override
  String get enterGoalWeight => '목표 체중을 입력하세요';

  @override
  String get lbs => 'lb';

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
  String get save => '저장';

  @override
  String get cancel => '취소';

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
}
