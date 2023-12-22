import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'movies_providers.dart';


  // Hasta que no este todo cargado no retornara false 
final initialLoadingProvider = Provider<bool>((ref) {

    final step1 = ref.watch(nowPlayingMoviesProvider).isEmpty;
    final step2 = ref.watch(polularMoviesProvider).isEmpty;
    final step3 = ref.watch(topRatedMoviesProvider).isEmpty;
    final step4 = ref.watch(upCommingMoviesProvider).isEmpty;

    if(step1 ||step2 ||step3 ||step4) return true; // Esta cargando


    return false; // terminamos de cargar
});