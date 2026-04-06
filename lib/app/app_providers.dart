import 'package:provider/provider.dart';

import '../features/main_feature/dashboard/providers/dashboard_provider.dart';
import '../features/main_feature/riwayat/data/riwayat_repository.dart';
import '../features/main_feature/riwayat/providers/riwayat_provider.dart';
import '../../features/main_feature/profile/providers/profile_provider.dart';
import '../features/main_feature/form/providers/form_provider.dart';

class AppProviders {
  static final providers = [
    ChangeNotifierProvider<RiwayatProvider>(
      create: (_) => RiwayatProvider(
        repository: RiwayatRepository(),
      ),
    ),
    ChangeNotifierProvider<DashboardProvider>(
      create: (_) => DashboardProvider(),
    ),
    ChangeNotifierProvider<ProfileProvider>(
      create: (_) => ProfileProvider()..loadProfile(),
    ),
    ChangeNotifierProvider<FormProvider>(
      create: (_) => FormProvider()..initialize(),
    ),
  ];
}