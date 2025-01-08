import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_list_tile.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_provider.dart';

class ExerciseFoundationPaginatedList extends StatefulWidget {
  const ExerciseFoundationPaginatedList({super.key});

  @override
  State<ExerciseFoundationPaginatedList> createState() => _ExerciseFoundationPaginatedListState();
}

class _ExerciseFoundationPaginatedListState extends State<ExerciseFoundationPaginatedList> {
  final ScrollController _scrollController = ScrollController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      // Schedule the loading for after the build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Provider.of<ExerciseFoundationProvider>(context, listen: false)
            .loadMoreFoundations();
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    final provider = Provider.of<ExerciseFoundationProvider>(context, listen: false);
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      provider.loadMoreFoundations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseFoundationProvider>(
      builder: (context, provider, _) {
        // Show loading indicator
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle search results
        if (provider.isSearching) {
          if (provider.searchResults.isEmpty) {
            return const Center(child: Text('No matching exercises found'));
          }

          return ListView.builder(
            itemCount: provider.searchResults.length,
            itemBuilder: (context, index) {
              return ExerciseFoundationListTile(
                exerciseFoundation: provider.searchResults[index],
              );
            },
          );
        }

        // Handle normal paginated view
        if (provider.loadedFoundations.isEmpty && !provider.isLoading) {
          return const Center(child: Text('No exercise foundations available'));
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: provider.loadedFoundations.length + (provider.hasMoreData ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == provider.loadedFoundations.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return ExerciseFoundationListTile(
              exerciseFoundation: provider.loadedFoundations[index],
            );
          },
        );
      },
    );
  }
}
