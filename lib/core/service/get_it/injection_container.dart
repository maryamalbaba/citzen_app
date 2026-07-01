import 'package:citzenapp/core/service/Token/secureTokenstorage.dart';
import 'package:citzenapp/core/service/Token/tokenStorage.dart';
import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:citzenapp/core/service/dioClient.dart';
import 'package:citzenapp/core/service/dioCunsumer.dart';
import 'package:citzenapp/feature/auth/login/data/data_source/LoginRemoteDataSource.dart';
import 'package:citzenapp/feature/auth/login/domain/repo/LoginRepository.dart';
import 'package:citzenapp/feature/auth/login/domain/usecase/usecase.dart';
import 'package:citzenapp/feature/auth/login/presentation/bloc/login_bloc.dart';
import 'package:citzenapp/feature/auth/logout/data/repo/repoImp.dart';
import 'package:citzenapp/feature/auth/logout/data/source/remote.dart';
import 'package:citzenapp/feature/auth/logout/domain/repo/repo.dart';
import 'package:citzenapp/feature/auth/logout/domain/usecase/usecase.dart';
import 'package:citzenapp/feature/auth/logout/presentation/bloc/logout_bloc.dart';
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
import 'package:citzenapp/feature/prossesFeature/myprocess/data/repo/transaction_repository_impl.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/data/source/transaction_remote_datasource.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/domain/repo/transaction_repository.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/domain/usecase/get_transactions_usecase.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/presentation/bloc/process_state_bloc.dart';
import 'package:citzenapp/feature/prossesFeature/process_type/data/repo/repoimp.dart';
import 'package:citzenapp/feature/prossesFeature/process_type/data/source/remote_source.dart';
import 'package:citzenapp/feature/prossesFeature/process_type/domain/repo/repo_type.dart';
import 'package:citzenapp/feature/prossesFeature/process_type/domain/usecase/usecase_typeprocess.dart';
import 'package:citzenapp/feature/prossesFeature/process_type/presentation/bloc/type_process_bloc.dart';
import 'package:citzenapp/feature/prossesFeature/processes/data/repo/auth_process_repository_impl.dart';
import 'package:citzenapp/feature/prossesFeature/processes/data/source/auth_process_remote_data_source.dart';
import 'package:citzenapp/feature/prossesFeature/processes/domain/repo/auth_process_repository.dart';
import 'package:citzenapp/feature/prossesFeature/processes/domain/usecase/get_auth_processes_use_case.dart';
import 'package:citzenapp/feature/prossesFeature/processes/presentation/bloc/process_bloc.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/data/datasources/file_upload_remote_datasource.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/data/datasources/stage_config_remote_datasource.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/data/datasources/stage_config_remote_datasource_impl.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/data/datasources/submit_form_remote_datasource.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/data/repo/file_upload_repository_impl.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/data/repo/stage_config_repository_impl.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/data/repo/submit_form_repository_impl.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/repositories/file_upload_repository.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/repositories/stage_config_repository.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/repositories/submit_form_repository.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/usecase/get_stage_config_usecase.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/usecase/submit_form_usecase.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/usecase/upload_file_usecase.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/bloc/file_bloc.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/bloc/stage_config_bloc.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/submitBloc/bloc/submit_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance; // sl stands for Service Locator

Future<void> init() async {
  /// ==========================================
  /// 1. BLOC (Presentation Layer)
  
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


// Bloc
  sl.registerFactory(() => LoginBloc(sl()));

// Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

// Repositories
  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(sl()));

// Data sources
  sl.registerLazySingleton<LoginRemoteDataSource>(
      () => LoginRemoteDataSourceImpl(sl()));

// ============================================================================
//  1. تسجيل اعتمادات الـ OTP الأساسي (التحقق)


// Blocs (نستخدم registerFactory لأن الـ Bloc يتم تدميره وإنشاؤه مع كل شاشة)
  sl.registerFactory(() => OtpBloc(sl()));

// Use cases
  sl.registerLazySingleton(() => OTpUseCase(sl()));

//  التعديل الأول: تحديد النوع الصريح لـ remotOtpImpl المتوقع داخل الـ Repository
  sl.registerLazySingleton<remotOtpImpl>(() => remotOtpImpl(api: sl()));

//  التعديل الثاني: تمرير الـ sl() بشكل صحيح ليتوافق مع الـ DataSource الذي سجلناه بالأعلى
  sl.registerLazySingleton<OtpRepo>(
      () => OtpStepRepositoryImpl(sl<remotOtpImpl>(), sl()));
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
  sl.registerLazySingleton<ResendOtpRepository>(() => ResendOtpRepositoryImpl(
      remoteDataSource: sl<ResendOtpRemoteDataSourceImpl>()));

// Data sources
  sl.registerLazySingleton<ResendOtpRemoteDataSourceImpl>(
      () => ResendOtpRemoteDataSourceImpl(api: sl<DioConsumer>()));

// ============================================================================

//  Auth Processes Feature

// Use cases
  sl.registerLazySingleton(() => GetAuthProcessesUseCase(sl()));

// Repositories
  sl.registerLazySingleton<AuthProcessRepository>(
    () => AuthProcessRepositoryImpl(remoteDataSource: sl()),
  );

// Data sources
  sl.registerLazySingleton<AuthProcessRemoteDataSource>(
    () => AuthProcessRemoteDataSourceImpl(api: sl<DioConsumer>()),
  );

  // Blocs
sl.registerFactory(() => AuthProcessBloc(sl()));

// ===================================================
// Stage Config Feature
// ===================================================

// Bloc
sl.registerFactory(() => StageConfigBloc(sl()));

// UseCase
sl.registerLazySingleton(() => GetStageConfigUseCase(sl()));

// Repository
sl.registerLazySingleton<StageConfigRepository>(
  () => StageConfigRepositoryImpl(remoteDataSource: sl()),
);

// DataSource
sl.registerLazySingleton<StageConfigRemoteDataSource>(
  () => StageConfigRemoteDataSourceImpl(sl<DioConsumer>()),
);

//

// ===================================================
// File Upload Feature
// ===================================================

// Bloc - factory لأنه يُنشأ مع كل صفحة استمارة
sl.registerFactory(() => FileUploadBloc(sl()));

// UseCase
sl.registerLazySingleton(() => UploadFileUseCase(sl()));

// Repository
sl.registerLazySingleton<FileUploadRepository>(
  () => FileUploadRepositoryImpl(remoteDataSource: sl()),
);

// DataSource - نمرر Dio مباشرة لأن الـ multipart يحتاجه
sl.registerLazySingleton<FileUploadRemoteDataSource>(
  () => FileUploadRemoteDataSourceImpl(sl<DioClient>().dio),
);


// ===================================================
// Submit Form Feature
// ===================================================

// Bloc
sl.registerFactory(() => SubmitFormBloc(sl()));

// UseCase
sl.registerLazySingleton(() => SubmitFormUseCase(sl()));

// Repository
sl.registerLazySingleton<SubmitFormRepository>(
  () => SubmitFormRepositoryImpl(remoteDataSource: sl()),
);

// DataSource
sl.registerLazySingleton<SubmitFormRemoteDataSource>(
  () => SubmitFormRemoteDataSourceImpl(sl<DioConsumer>()),
);

////
sl.registerFactory(
  () => TransactionBloc(sl()),
);

sl.registerLazySingleton<TransactionRemoteDataSource>(
  () => TransactionRemoteDataSourceImpl(api: sl<DioConsumer>()),
);

sl.registerLazySingleton<TransactionRepository>(
  () => TransactionRepositoryImpl(remote:sl()),
);

sl.registerLazySingleton(
  () => GetTransactionsUseCase(sl()),
);

sl.registerFactory(() => LogoutBloc(logoutUseCase: sl()));
sl.registerLazySingleton(() => LogoutUseCase(sl()));
sl.registerLazySingleton<LogoutRepository>(
    () => LogoutRepositoryImp(
      remoteDataSource: sl(),
      tokenStorage: sl(),
    ),
  );
  sl.registerLazySingleton<LogoutRemoteDataSourceImpl>(
    () => LogoutRemoteDataSourceImpl(sl()),
  );
}


