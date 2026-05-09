import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/festival.dart';
import '../repositories/festival_repository.dart';
import 'region_provider.dart';

final festivalRepositoryProvider = Provider((ref) => FestivalRepository());

// 即将到来的节日
final upcomingFestivalsProvider = FutureProvider<List<Festival>>((ref) async {
	final repo = ref.read(festivalRepositoryProvider);
	final region = ref.watch(currentRegionProvider);
	return repo.getUpcomingFestivals(regionId: region?.id);
});

// 热门节日
final hotFestivalsProvider = FutureProvider<List<Festival>>((ref) async {
	final repo = ref.read(festivalRepositoryProvider);
	return repo.getHotFestivals();
});

// 推荐节日
final recommendFestivalsProvider = FutureProvider<List<Festival>>((ref) async {
	final repo = ref.read(festivalRepositoryProvider);
	final region = ref.watch(currentRegionProvider);
	return repo.getRecommendFestivals(regionId: region?.id);
});
