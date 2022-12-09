// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:spaces_application/business_logic/data_retrieval_status.dart';
// import 'package:spaces_application/data/models/userData.dart';
// import 'package:spaces_application/data/repositories/userData_repository.dart';

// part 'home_event.dart';
// part 'home_state.dart';

// class HomeBloc extends Bloc<HomeEvent, HomeState> {
//   final UserDataRepository userRepo;
//   HomeBloc({required this.userRepo}) : super((HomeState())) {
//     on<currentUserUpdated>((event, emit) async {
//       _onCurrentUserUpdated(emit);
//       // TODO: implement event handler
//     });
//   }

//   Future<void> _onCurrentUserUpdated(Emitter<HomeState> emit) async {
//     emit(DataRetrieving());
//     try {
//       UserData currentUser = await userRepo.getCurrentUser();
//       emit(state.copyWith(
//           retrievalStatus: RetrievalSuccess(), currentUser = currentUser));
//     } catch (e) {
//       emit(state.copyWith(retrievalStatus: RetrievalFailed(Exception(e))));
//     }
//   }
// }
