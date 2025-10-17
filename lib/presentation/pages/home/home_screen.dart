import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(LoadHomeData()),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'StudyMate Dashboard',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          elevation: 0,
          backgroundColor: Colors.blueAccent,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                // TODO: Navigate to notifications
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              onPressed: () {
                // TODO: Navigate to profile
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(RefreshHomeData());
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state.loading) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blueAccent,
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeCard(context),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildQuickStats(state),

                          const SizedBox(height: 24),
                          _sectionHeader('🗓 Class Schedule', 'Today'),
                          const SizedBox(height: 12),
                          _buildClassScheduleCard(state.classSchedules),

                          const SizedBox(height: 24),
                          _sectionHeader('📚 Assignments & Exams', 'Upcoming'),
                          const SizedBox(height: 12),
                          _buildAssignmentsCard(state.assignments),

                          const SizedBox(height: 24),
                          _sectionHeader('📝 Subject Notes', null),
                          const SizedBox(height: 12),
                          _buildNotesCard(state.subjectNotes),

                          const SizedBox(height: 24),
                          _sectionHeader(
                            '✅ To-Do List',
                            '${state.todos.length} tasks',
                          ),
                          const SizedBox(height: 12),
                          _buildTodoCard(state.todos),

                          const SizedBox(height: 32),
                          _buildMotivationalQuote(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // TODO: Quick add dialog
          },
          backgroundColor: Colors.blueAccent,
          icon: const Icon(Icons.add),
          label: const Text('Quick Add'),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting = 'Good Morning';
    if (hour >= 12 && hour < 17) {
      greeting = 'Good Afternoon';
    } else if (hour >= 17) {
      greeting = 'Good Evening';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.blue.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ready to learn today?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateTime.now().toString().split(' ')[0],
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(HomeState state) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.book_outlined,
            label: 'Classes',
            value: state.classSchedules.length.toString(),
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.assignment_outlined,
            label: 'Assignments',
            value: state.assignments.length.toString(),
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle_outline,
            label: 'Tasks',
            value: state.todos.length.toString(),
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, String? subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        if (subtitle != null)
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
      ],
    );
  }

  Widget _buildClassScheduleCard(List<String> items) {
    if (items.isEmpty) {
      return _buildEmptyState(
        icon: Icons.event_available,
        message: 'No classes scheduled today',
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade50,
              child: Icon(
                Icons.school_outlined,
                color: Colors.blueAccent,
                size: 20,
              ),
            ),
            title: Text(
              items[index],
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
            onTap: () {
              // TODO: Navigate to class details
            },
          );
        },
      ),
    );
  }

  Widget _buildAssignmentsCard(List<String> items) {
    if (items.isEmpty) {
      return _buildEmptyState(
        icon: Icons.assignment_turned_in,
        message: 'No pending assignments',
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length > 3 ? 3 : items.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange.shade50,
              child: Icon(
                Icons.assignment_outlined,
                color: Colors.orange,
                size: 20,
              ),
            ),
            title: Text(
              items[index],
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Due soon',
              style: TextStyle(color: Colors.orange[700], fontSize: 12),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
            onTap: () {
              // TODO: Navigate to assignment details
            },
          );
        },
      ),
    );
  }

  Widget _buildTodoCard(List<String> items) {
    if (items.isEmpty) {
      return _buildEmptyState(
        icon: Icons.task_alt,
        message: 'All caught up! 🎉',
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length > 5 ? 5 : items.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return CheckboxListTile(
            value: false,
            onChanged: (value) {
              // TODO: Handle checkbox toggle
            },
            title: Text(
              items[index],
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Colors.green,
          );
        },
      ),
    );
  }

  Widget _buildNotesCard(Map<String, List<String>> notes) {
    if (notes.isEmpty) {
      return _buildEmptyState(
        icon: Icons.note_add,
        message: 'Start taking notes',
      );
    }

    return Column(
      children: notes.entries.map((entry) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple.shade50,
              child: Icon(Icons.subject, color: Colors.purple, size: 20),
            ),
            title: Text(
              entry.key,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            subtitle: Text(
              '${entry.value.length} notes',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            children: entry.value
                .map(
                  (note) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    leading: Icon(
                      Icons.note_alt_outlined,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                    title: Text(note),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey[400],
                    ),
                    onTap: () {
                      // TODO: Open note detail
                    },
                  ),
                )
                .toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationalQuote() {
    final quotes = [
      'Stay consistent and focused 💪',
      'Small progress is still progress 🌟',
      'Keep learning, keep growing 🚀',
      'You are doing great! 🎯',
      'Every day is a new opportunity 🌅',
    ];
    final randomQuote = quotes[DateTime.now().day % quotes.length];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade50, Colors.blue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.format_quote, color: Colors.purple[300], size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              randomQuote,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
