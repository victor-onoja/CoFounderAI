import 'package:cofounder_ai/blocs/project/project_bloc.dart';
import 'package:cofounder_ai/blocs/project/project_state.dart';
import 'package:cofounder_ai/screens/project_details.dart';
import 'package:cofounder_ai/screens/widgets/floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cofounder_ai/blocs/idea_edit/idea_edit_bloc.dart';
import 'package:cofounder_ai/blocs/idea_edit/idea_edit_event.dart';
import 'package:cofounder_ai/blocs/idea_edit/idea_edit_state.dart';
import 'package:cofounder_ai/models/idea.dart';

class IdeaDetailScreen extends StatefulWidget {
  final Idea idea;

  const IdeaDetailScreen({super.key, required this.idea});

  @override
  _IdeaDetailScreenState createState() => _IdeaDetailScreenState();
}

class _IdeaDetailScreenState extends State<IdeaDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isConvertingToProject = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.idea.originalIdea);
    _descriptionController =
        TextEditingController(text: widget.idea.expandedIdea);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IdeaEditBloc(),
      child: Builder(
        builder: (context) {
          return Stack(children: [
            Scaffold(
              appBar: AppBar(
                title: const Text('Edit Idea'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: () {
                      context.read<IdeaEditBloc>().add(SaveIdea(
                            id: widget.idea.id,
                            originalIdea: _titleController.text,
                            expandedIdea: _descriptionController.text,
                          ));
                    },
                  ),
                ],
              ),
              body: MultiBlocListener(
                listeners: [
                  BlocListener<IdeaEditBloc, IdeaEditState>(
                    listener: (context, state) {
                      if (state is IdeaEditSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Idea saved successfully')),
                        );
                        Navigator.pop(context);
                      } else if (state is IdeaEditFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: //${state.error}')),
                        );
                      }
                    },
                  ),
                  BlocListener<ProjectBloc, ProjectState>(
                    listener: (context, state) {
                      setState(() {
                        _isConvertingToProject = state is ProjectLoading;
                      });

                      if (state is ProjectLoaded) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProjectDetailsScreen(
                                    project: state.project)));
                      } else if (state is ProjectError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                        print(state.message);
                      }
                    },
                  ),
                ],
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _descriptionController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: PulsingFAB(
                onPressed: () {
                  context
                      .read<ProjectBloc>()
                      .convertToProject(_descriptionController.text);
                },
                project: true,
              ),
            ),
            if (_isConvertingToProject)
              const Positioned.fill(
                child: ColoredBox(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Converting Idea to Project...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ]);
        },
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
