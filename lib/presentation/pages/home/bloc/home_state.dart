class HomeState {
  final bool loading;
  final List<String> classSchedules;
  final List<String> assignments;
  final Map<String, List<String>> subjectNotes;
  final List<String> todos;

  HomeState({
    this.loading = false,
    this.classSchedules = const [],
    this.assignments = const [],
    this.subjectNotes = const {},
    this.todos = const [],
  });

  HomeState copyWith({
    bool? loading,
    List<String>? classSchedules,
    List<String>? assignments,
    Map<String, List<String>>? subjectNotes,
    List<String>? todos,
  }) {
    return HomeState(
      loading: loading ?? this.loading,
      classSchedules: classSchedules ?? this.classSchedules,
      assignments: assignments ?? this.assignments,
      subjectNotes: subjectNotes ?? this.subjectNotes,
      todos: todos ?? this.todos,
    );
  }
}
