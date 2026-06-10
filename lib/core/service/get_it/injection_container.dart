import 'package:citzenapp/core/service/Token/secureTokenstorage.dart';
import 'package:citzenapp/core/service/Token/tokenStorage.dart';
import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:citzenapp/core/service/dioClient.dart';
import 'package:citzenapp/core/service/dioCunsumer.dart';
import 'package:citzenapp/feature/auth/login/data/data_source/LoginRemoteDataSource.dart';
import 'package:citzenapp/feature/auth/login/domain/repo/LoginRepository.dart';
import 'package:citzenapp/feature/auth/login/domain/usecase/usecase.dart';
import 'package:citzenapp/feature/auth/login/presentation/bloc/login_bloc.dart';
import 'package:citzenapp/feature/auth/otp/data/repo/repoImp.dart';
import 'package:citzenapp/feature/auth/otp/data/source/remotImpl.dart';
import 'package:citzenapp/feature/auth/otp/data/source/remotedata.dart';
import 'package:citzenapp/feature/auth/otp/domain/repo/repootp.dart';
import 'package:citzenapp/feature/auth/otp/domain/usecase/otpUsecase.dart';
import 'package:citzenapp/feature/auth/otp/presentation/bloc/otp_bloc.dart';
import 'package:citzenapp/feature/auth/resendotp/data/repo/reporesend.dart';
import 'package:citzenapp/feature/auth/resendotp/data/source/remote.dart';
import 'package:citzenapp/feature/auth/resendotp/domain/usecase/resendusecase.dart';
import 'package:citzenapp/feature/auth/resendotp/presentation/bloc/resend_otp_bloc.dart';
import 'package:citzenapp/feature/process/data/repo/repoimp.dart';
import 'package:citzenapp/feature/process/data/source/remote_source.dart';
import 'package:citzenapp/feature/process/domain/repo/repo_type.dart';
import 'package:citzenapp/feature/process/domain/usecase/usecase_typeprocess.dart';
import 'package:citzenapp/feature/process/presentation/bloc/type_process_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';


final sl = GetIt.instance; // sl stands for Service Locator

Future<void> init() async {
  /// ==========================================
  /// 1. BLOC (Presentation Layer)
  /// ==========================================
  // We use registerFactory for Blocs so it creates a fresh instance when needed
  sl.registerFactory(() => TypeProcessBloc(sl()));

  /// ==========================================
  /// 2. USE CASES (Domain Layer)
  /// ==========================================
  // LazySingleton means it's created once and kept in memory
  sl.registerLazySingleton(() => GetTypeProcessUseCase(sl()));

  /// ==========================================
  /// 3. REPOSITORIES (Data Layer)
  /// ==========================================
  sl.registerLazySingleton<GEtTypeProcess>(
    () => TypeProcessImpl(remote: sl()),
  );


  /// 4. DATA SOURCES (Data Layer)
  /// ==========================================
  // Note: I'm injecting GetTypeProcSourceImpl exactly as your code expects
  sl.registerLazySingleton<GetTypeProcSourceImpl>(
    () => GetTypeProcSourceImpl(sl()),
  );

 
  /// 5. CORE / EXTERNAL (API Consumer)
  /// ==========================================
  // Make sure your ApiConsumer is also registered here!
  // sl.registerLazySingleton<ApiConsumer>(() => ApiConsumerImpl());
// 1. Register TokenStorage
  sl.registerLazySingleton<TokenStorage>(
    () => SecureTokenStorage(const FlutterSecureStorage()),
  );

  // 2. Register DioClient
  sl.registerLazySingleton<DioClient>(
    () => DioClient(sl()),
  );

  // 🔥 التعديل الجوهري هنا: نسجل الـ DioConsumer بنوعه الصريح أولاً
  sl.registerLazySingleton<DioConsumer>(
    () => DioConsumer(sl()),
  );

  // ثم نربط الـ ApiConsumer بنفس النسخة لكي لا تنهار الكلاسات القديمة مثل الـ OTP العادي
  sl.registerLazySingleton<ApiConsumer>(
    () => sl<DioConsumer>(),
  );

//!
// اضفي هذه الأسطر داخل دالة init() في ملف الـ injection_container.dart

// Bloc
  sl.registerFactory(() => LoginBloc(sl()));

// Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

// Repositories
  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(sl()));

// Data sources
  sl.registerLazySingleton<LoginRemoteDataSource>(
      () => LoginRemoteDataSourceImpl(sl()));

// inside injection_container.dart -> init() function

// ============================================================================
//  1. تسجيل اعتمادات الـ OTP الأساسي (التحقق)
// ============================================================================

// Blocs (نستخدم registerFactory لأن الـ Bloc يتم تدميره وإنشاؤه مع كل شاشة)
  sl.registerFactory(() => OtpBloc(sl()));

// Use cases
  sl.registerLazySingleton(() => OTpUseCase(sl()));

// 🚀 التعديل الأول: تحديد النوع الصريح لـ remotOtpImpl المتوقع داخل الـ Repository
sl.registerLazySingleton<remotOtpImpl>(() => remotOtpImpl(api: sl()));

// 🚀 التعديل الثاني: تمرير الـ sl() بشكل صحيح ليتوافق مع الـ DataSource الذي سجلناه بالأعلى
sl.registerLazySingleton<OtpRepo>(() => OtpStepRepositoryImpl(sl<remotOtpImpl>(), sl()));
// ============================================================================
//  2. تسجيل اعتمادات الـ Resend OTP الجديدة


// Blocs
sl.registerFactory(() => ResendOtpBloc(sl()));

// Use cases
sl.registerLazySingleton(() => ResendOtpUseCase(
      sl<ResendOtpRepository>(), 
      repository: sl<ResendOtpRepository>(),
    ));

// Repositories
sl.registerLazySingleton<ResendOtpRepository>(
    () => ResendOtpRepositoryImpl(remoteDataSource: sl<ResendOtpRemoteDataSourceImpl>()));

// Data sources
sl.registerLazySingleton<ResendOtpRemoteDataSourceImpl>(
    () => ResendOtpRemoteDataSourceImpl(api: sl<DioConsumer>()));
    }