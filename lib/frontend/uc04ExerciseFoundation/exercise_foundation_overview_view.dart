import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_provider.dart';
import 'package:trainingplaner/frontend/uc04ExerciseFoundation/exercise_foundation_paginated_list.dart';

class ExerciseFoundationOverviewView extends StatefulWidget {
  const ExerciseFoundationOverviewView({super.key});

  @override
  State<ExerciseFoundationOverviewView> createState() => _ExerciseFoundationOverviewViewState();
}

class _ExerciseFoundationOverviewViewState extends State<ExerciseFoundationOverviewView> {
  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExerciseFoundationProvider>(context, listen: false)
        .loadMoreFoundations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Foundations'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<ExerciseFoundationProvider>(
              builder: (context, provider, _) {
                return TextField(
                  decoration: InputDecoration(
                    hintText: 'Search exercises...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: provider.isSearching 
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            provider.clearSearch();
                          },
                        )
                      : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) => provider.updateSearchQuery(value),
                );
              },
            ),
          ),
          const Expanded(
            child: ExerciseFoundationPaginatedList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Your existing add foundation logic
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
