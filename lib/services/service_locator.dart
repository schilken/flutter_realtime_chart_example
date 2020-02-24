import 'package:get_it/get_it.dart';

import 'realtime_data_service.dart';
import 'realtime_data_service_impl.dart';

GetIt locator = GetIt.instance;

setupServiceLocator() {
  locator.registerLazySingleton<RealtimeDataService>(() => RealtimeDataServiceImpl());
}