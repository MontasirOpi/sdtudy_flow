import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    // Simulate loading from local DB or Supabase
    await Future.delayed(const Duration(seconds: 1));

    emit(
      state.copyWith(
        loading: false,
        classSchedules: [
          'Math - 10 AM (Monday)',
          'Physics - 11 AM (Tuesday)',
          'English - 9 AM (Wednesday)',
        ],
        assignments: [
          'Submit Physics Lab Report',
          'Math Assignment due Friday',
        ],
        subjectNotes: {
          'Math': ['Integration basics', 'Trigonometric formulas'],
          'Physics': ['Newton’s Laws summary'],
        },
        todos: ['Read chapter 3', 'Prepare for quiz'],
      ),
    );
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    add(LoadHomeData());
  }
}
