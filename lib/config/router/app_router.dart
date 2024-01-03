import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: [
    GoRoute(
        path: '/home/:page',
        name: HomeScreen.name,
        builder: (context, state) {
          // Guardamos el argumento en una variable
          final pageIndex =  (state.pathParameters['page'] ?? '0').toString();
            return HomeScreen(pageIndex: int.parse(pageIndex));
        },
        // Agregamos rutas hijas para poder ir hacia atras en caso de que ingresemos directamente a la ruta de abajo
        routes: [
          // Ruta para recibir una ID
          GoRoute(
            path: 'movie/:id',
            name: MovieScreen.name,
            builder: (context, state) {
              final movieId = state.pathParameters['id'] ?? 'no-id';
              return MovieScreen(movieId: movieId);
            },
          ),
        ]),

    GoRoute(
      path: '/',
      redirect: (_, __) => '/home/0',
    )
  ],
);
