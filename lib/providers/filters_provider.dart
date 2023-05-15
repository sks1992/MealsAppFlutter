import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/meals_provider.dart';

enum Filters { glutenFree, lactoseFree, vegetarian, vegan }

class FilterNotifier extends StateNotifier<Map<Filters, bool>> {
  FilterNotifier()
      : super({
          Filters.glutenFree: false,
          Filters.lactoseFree: false,
          Filters.vegetarian: false,
          Filters.vegan: false,
        });

  void setFilters(Map<Filters, bool> chosenFilters) {
    state = chosenFilters;
  }

  void setFilter(Filters filters, bool isActive) {
    state = {
      ...state,
      filters: isActive,
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FilterNotifier, Map<Filters, bool>>(
  (ref) => FilterNotifier(),
);

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilter = ref.watch(filtersProvider);

  return meals.where((meal) {
    if (activeFilter[Filters.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilter[Filters.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilter[Filters.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilter[Filters.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
