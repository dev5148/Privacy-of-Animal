import 'package:privacy_of_animal/bloc_helpers/bloc_event_state.dart';
import 'package:privacy_of_animal/logics/current_user.dart';
import 'package:privacy_of_animal/logics/photo/photo.dart';
import 'package:privacy_of_animal/utils/service_locator.dart';

class PhotoBloc extends BlocEventStateBase<PhotoEvent,PhotoState>
{
  static final PhotoAPI _api = PhotoAPI();

  @override
  PhotoState get initialState => PhotoState.noTake();

  @override
  Stream<PhotoState> eventHandler(PhotoEvent event, PhotoState currentState) async*{
    
    if (event is PhotoEventTaking) {
      String path = await _api.getImage();
      yield PhotoState.take(path);
    }
    if (event is PhotoEventGotoAnalysis){
      yield PhotoState.loading();
      ANALYZE_RESULT analyzeResultKakao = await _api.analyzeFaceKakao(event.photoPath);
      if(analyzeResultKakao==ANALYZE_RESULT.FAILURE){
        yield PhotoState.failed();
      }else{
        ANALYZE_RESULT analyzeResultNaver = await _api.analyzeFaceNaver(event.photoPath);
        if(analyzeResultNaver==ANALYZE_RESULT.FAILURE){
          yield PhotoState.failed();
        }else{
          await _api.detectAnimal(sl.get<CurrentUser>().kakaoMLModel);
          ANALYZE_RESULT storeResult = await _api.storeProfile();
          if(storeResult==ANALYZE_RESULT.FAILURE){
            yield PhotoState.failed();
          }else{
            yield PhotoState.succeeded();
          }
        }
      }
    }
  }
}