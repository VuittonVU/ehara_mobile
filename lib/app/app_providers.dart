import 'package:provider/provider.dart';

import '../features/main_feature/riwayat/data/riwayat_repository.dart';
import '../features/main_feature/riwayat/providers/riwayat_provider.dart';
import '../../features/main_feature/profile/providers/profile_provider.dart';
import '../features/main_feature/form/providers/form_provider.dart';
import '../features/main_feature/pembayaran/providers/pembayaran_provider.dart';

class AppProviders {
  static final providers = [
    ChangeNotifierProvider<RiwayatProvider>(
      create: (_) => RiwayatProvider(
        repository: RiwayatRepository(),
      ),
    ),
    ChangeNotifierProvider<ProfileProvider>(
      create: (_) => ProfileProvider()..loadProfile(),
    ),
    ChangeNotifierProvider<FormProvider>(
      create: (_) => FormProvider()..initialize(),
    ),
    ChangeNotifierProvider<PembayaranProvider>(
      create: (_) => PembayaranProvider(),
    ),
  ];
}