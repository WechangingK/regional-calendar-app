import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/constants/app_colors.dart';
import '../../../data/providers/region_provider.dart';
import '../../../data/models/region.dart';
import '../../../data/repositories/region_repository.dart';

class RegionSelectorPage extends ConsumerStatefulWidget {
	const RegionSelectorPage({super.key});

	@override
	ConsumerState<RegionSelectorPage> createState() => _RegionSelectorPageState();
}

class _RegionSelectorPageState extends ConsumerState<RegionSelectorPage> {
	final _searchController = TextEditingController();
	List<Region> _searchResults = [];
	bool _isSearching = false;

	@override
	void dispose() {
		_searchController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final provinces = ref.watch(provincesProvider);
		final currentRegion = ref.watch(currentRegionProvider);

		return Scaffold(
			appBar: AppBar(
				title: const Text('选择地区'),
				bottom: PreferredSize(
					preferredSize: const Size.fromHeight(56),
					child: Padding(
						padding: const EdgeInsets.all(8),
						child: TextField(
							controller: _searchController,
							decoration: InputDecoration(
								hintText: '搜索地区...',
								prefixIcon: const Icon(Icons.search),
								suffixIcon: _searchController.text.isNotEmpty
									? IconButton(
										icon: const Icon(Icons.clear),
										onPressed: () {
											_searchController.clear();
											setState(() {
												_searchResults = [];
												_isSearching = false;
											});
										},
									)
									: null,
								filled: true,
								fillColor: Colors.white,
								border: OutlineInputBorder(
									borderRadius: BorderRadius.circular(12),
									borderSide: BorderSide.none,
								),
							),
							onChanged: _onSearch,
						),
					),
				),
			),
			body: _isSearching
				? _buildSearchResults()
				: _buildProvinceList(provinces, currentRegion),
		);
	}

	Future<void> _onSearch(String keyword) async {
		if (keyword.isEmpty) {
			setState(() {
				_searchResults = [];
				_isSearching = false;
			});
			return;
		}

		setState(() => _isSearching = true);
		final repo = RegionRepository();
		final results = await repo.searchRegions(keyword);
		setState(() => _searchResults = results);
	}

	Widget _buildSearchResults() {
		if (_searchResults.isEmpty) {
			return const Center(child: Text('未找到相关地区'));
		}

		return ListView.builder(
			itemCount: _searchResults.length,
			itemBuilder: (context, index) {
				final region = _searchResults[index];
				return ListTile(
					leading: const Icon(Icons.location_on, color: AppColors.primary),
					title: Text(region.name),
					onTap: () => _selectRegion(region),
				);
			},
		);
	}

	Widget _buildProvinceList(AsyncValue<List<Region>> provinces, Region? currentRegion) {
		return provinces.when(
			data: (list) {
				return ListView.builder(
					itemCount: list.length,
					itemBuilder: (context, index) {
						final province = list[index];
						final isSelected = currentRegion?.id == province.id;
						return ListTile(
							leading: Icon(
								Icons.location_on,
								color: isSelected ? AppColors.primary : AppColors.textHint,
							),
							title: Text(
								province.name,
								style: TextStyle(
									fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
									color: isSelected ? AppColors.primary : null,
								),
							),
							trailing: isSelected
								? const Icon(Icons.check, color: AppColors.primary)
								: const Icon(Icons.chevron_right),
							onTap: () => _selectRegion(province),
						);
					},
				);
			},
			loading: () => const Center(child: CircularProgressIndicator()),
			error: (error, _) => Center(child: Text('加载失败：$error')),
		);
	}

	void _selectRegion(Region region) {
		ref.read(currentRegionProvider.notifier).setRegion(region);
		context.pop();
		ScaffoldMessenger.of(context).showSnackBar(
			SnackBar(content: Text('已切换到${region.name}')),
		);
	}
}
