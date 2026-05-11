import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/content.dart';
import '../repositories/content_repository.dart';
import 'region_provider.dart';

final contentRepositoryProvider = Provider((ref) => ContentRepository());

// 每日推荐内容
final dailyContentProvider = FutureProvider<Content?>((ref) async {
	final repo = ref.read(contentRepositoryProvider);
	return repo.getDailyContent();
});

// 内容列表
final contentListProvider = FutureProvider<List<Content>>((ref) async {
	final repo = ref.read(contentRepositoryProvider);
	final region = ref.watch(currentRegionProvider);
	return repo.getContents(regionId: region?.id);
});
