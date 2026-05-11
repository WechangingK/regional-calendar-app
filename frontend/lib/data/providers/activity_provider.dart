import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity.dart';
import '../repositories/activity_repository.dart';
import 'region_provider.dart';

final activityRepositoryProvider = Provider((ref) => ActivityRepository());

// 即将到来的活动
final upcomingActivitiesProvider = FutureProvider<List<Activity>>((ref) async {
	final repo = ref.read(activityRepositoryProvider);
	final region = ref.watch(currentRegionProvider);
	return repo.getUpcomingActivities(regionId: region?.id);
});

// 热门活动
final hotActivitiesProvider = FutureProvider<List<Activity>>((ref) async {
	final repo = ref.read(activityRepositoryProvider);
	return repo.getHotActivities();
});

// 推荐活动
final recommendActivitiesProvider = FutureProvider<List<Activity>>((ref) async {
	final repo = ref.read(activityRepositoryProvider);
	final region = ref.watch(currentRegionProvider);
	return repo.getRecommendActivities(regionId: region?.id);
});
