import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/local_storage.dart';
import '../models/region.dart';
import '../repositories/region_repository.dart';

final regionRepositoryProvider = Provider((ref) => RegionRepository());

// 当前选中的地区
final currentRegionProvider = StateNotifierProvider<CurrentRegionNotifier, Region?>((ref) {
	return CurrentRegionNotifier();
});

class CurrentRegionNotifier extends StateNotifier<Region?> {
	CurrentRegionNotifier() : super(null) {
		_loadSavedRegion();
	}

	Future<void> _loadSavedRegion() async {
		final regionId = await LocalStorage.getRegionId();
		final regionName = await LocalStorage.getRegionName();
		if (regionId != null && regionName != null) {
			state = Region(
				id: regionId,
				name: regionName,
				level: 1,
				code: '',
			);
		}
	}

	Future<void> setRegion(Region region) async {
		state = region;
		await LocalStorage.saveRegion(region.id, region.name);
	}
}

// 省份列表
final provincesProvider = FutureProvider<List<Region>>((ref) async {
	final repo = ref.read(regionRepositoryProvider);
	return repo.getProvinces();
});

// 子地区列表
final childrenProvider = FutureProvider.family<List<Region>, int>((ref, parentId) async {
	final repo = ref.read(regionRepositoryProvider);
	return repo.getChildren(parentId);
});
