import 'package:citzenapp/core/service/Token/secureTokenstorage.dart';
import 'package:citzenapp/core/service/Token/tokenStorage.dart';
import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:citzenapp/core/service/dioClient.dart';
import 'package:citzenapp/core/service/dioCunsumer.dart';
import 'package:citzenapp/feature/auth/login/data/data_source/LoginRemoteDataSource.dart';
import 'package:citzenapp/feature/auth/login/domain/repo/LoginRepository.dart';
import 'package:citzenapp/feature/auth/login/domain/usecase/usecase.dart';
import 'package:citzenapp/feature/auth/login/presentation/bloc/login_bloc.dart';
import 'package:citzenapp/feature/process/data/repo/repoimp.dart';
import 'package:citzenapp/feature/process/data/source/remote_source.dart';
import 'package:citzenapp/feature/process/domain/repo/repo_type.dart';
import 'package:citzenapp/feature/process/domain/usecase/usecase_typeprocess.dart';
import 'package:citzenapp/feature/process/presentation/bloc/type_process_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

// Import all your files here...
// import 'type_process_bloc.dart';
// import 'get_type_process_usecase.dart';
// import 'type_process_impl.dart';
// import 'get_type_proc_source_impl.dart';

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

  /// ==========================================
  /// 4. DATA SOURCES (Data Layer)
  /// ==========================================
  // Note: I'm injecting GetTypeProcSourceImpl exactly as your code expects
  sl.registerLazySingleton<GetTypeProcSourceImpl>(
    () => GetTypeProcSourceImpl(sl()),
  );

  /// ==========================================
  /// 5. CORE / EXTERNAL (API Consumer)
  /// ==========================================
  // Make sure your ApiConsumer is also registered here!
  // sl.registerLazySingleton<ApiConsumer>(() => ApiConsumerImpl()); 




// 1. Register TokenStorage

  sl.registerLazySingleton<TokenStorage>(
    () => SecureTokenStorage( const FlutterSecureStorage()), 
  );

  // 2. Register DioClient (It will automatically grab TokenStorage from sl)
  sl.registerLazySingleton<DioClient>(
    () => DioClient(sl()),
  );

  // 3. Register ApiConsumer (Using your DioConsumer implementation)
  // It will automatically grab the DioClient from sl!
  sl.registerLazySingleton<ApiConsumer>(
    () => DioConsumer(sl()),
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
sl.registerLazySingleton<LoginRemoteDataSource>(() => LoginRemoteDataSourceImpl(sl()));


}

