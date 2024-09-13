import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cofounder_ai/blocs/idea_list/idea_list_bloc.dart';
import 'package:cofounder_ai/blocs/idea_list/idea_list_event.dart';
import 'package:cofounder_ai/blocs/idea_list/idea_list_state.dart';

import 'idea_details.dart';

class IdeaScreen extends StatelessWidget {
  const IdeaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IdeaListBloc()..add(FetchIdeas()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Ideas'),
          elevation: 0,
        ),
        body: BlocBuilder<IdeaListBloc, IdeaListState>(
          builder: (context, state) {
            if (state is IdeaListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is IdeaListLoaded) {
              return AnimatedList(
                initialItemCount: state.ideas.length,
                itemBuilder: (context, index, animation) {
                  final idea = state.ideas[index];
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    IdeaDetailScreen(idea: idea),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  idea.originalIdea,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  idea.expandedIdea,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is IdeaListError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('No ideas yet'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/idea-capture');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
