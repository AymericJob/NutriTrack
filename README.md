# MyFitnessPal

MyFitnessPal est une application Flutter conçue pour aider les utilisateurs à gérer leur alimentation et leur santé de manière simple et efficace.

## 🔍 Aperçu de notre application

L'application MyFitnessPal permet aux utilisateurs de suivre leur consommation alimentaire.

## 📲 Applications similaires

Il existe de nombreuses applications de suivi de l'alimentation sur le marché, chacune offrant différentes fonctionnalités. Voici quelques exemples :

- **MyFitnessPal**
    - iOS: [MyFitnessPal sur l'App Store](https://apps.apple.com/us/app/myfitnesspal/id568832228)
    - Android: [MyFitnessPal sur Google Play](https://play.google.com/store/apps/details?id=com.myfitnesspal.android)

- **Lose It!**
    - iOS: [Lose It! sur l'App Store](https://apps.apple.com/us/app/lose-it/id297368587)
    - Android: [Lose It! sur Google Play](https://play.google.com/store/apps/details?id=com.loseit)

- **Cronometer**
    - iOS: [Cronometer sur l'App Store](https://apps.apple.com/us/app/cronometer/id1049223637)
    - Android: [Cronometer sur Google Play](https://play.google.com/store/apps/details?id=com.cronometer.android)

## 🤔 MoodBoard

![MyfitnessPal](https://mir-s3-cdn-cf.behance.net/projects/404/436b24196708837.Y3JvcCw5ODM5LDc2OTYsODAzLDA.png)
![MyfitnessPal](https://cdn.dribbble.com/userupload/2957372/file/original-f46379cab48c97180d43d0b8db289672.png?resize=400x0)

## 📍 Site Map

TODO

## 👀 Design de l'application

TODO

## ⚙️ Fonctionnalités de l'application

- **Ajout d'aliments** : Les utilisateurs peuvent ajouter des aliments manuellement ou les scanner via un code-barres.
- **Recherche d'aliments** : Permet aux utilisateurs de rechercher des aliments en utilisant des mots-clés pour trouver des informations nutritionnelles.
- **Statistiques nutritionnelles** : Affiche un résumé des calories, glucides, lipides et protéines consommés.
- **Sauvegarde des aliments** : Les utilisateurs peuvent sauvegarder leurs aliments favoris pour un accès rapide.
- **Interface utilisateur intuitive** : Conçue pour être facile à utiliser sur des écrans de différentes tailles.

## 📁 Les différents fichiers

Tous les fichiers se trouvent dans le dossier `lib`.

- **Pages** :
    - **Home** :
        - **Profile** :
            - `activity_page.dart` : Affiche les activités de l'utilisateur.
            - `dashboard_page.dart` : Page de tableau de bord de l'utilisateur, résumant les informations importantes.
            - `main_page.dart` : Page principale du profil de l'utilisateur.
        - **Logs** :
            - `home_page.dart` : Page d'accueil de l'application.
            - `login_page.dart` : Page de connexion de l'utilisateur.
            - `register_page.dart` : Page d'inscription pour les nouveaux utilisateurs.

- **Models** :
    - `add_food_page.dart` : Page permettant d'ajouter un nouvel aliment via des formulaires.
    - `food.dart` : Modèle de données pour les aliments, définissant les attributs nutritionnels.

- **Routes** :
    - `app_routes.dart` : Contient les routes de navigation de l'application.

- **firebase_options.dart** : Configuration pour l'intégration de Firebase.
- **main.dart** : Point d'entrée de l'application Flutter.
- **TODO.txt** : Liste des tâches à accomplir et améliorations à apporter.

## ⏳ État d'avancement
- [ ] Voir dans la TODO page.

### Bugs à corriger
- [ ] Optimiser la recherche d'aliments pour de meilleures performances.
- [ ] Gérer les erreurs de connexion avec Firestore.

### Améliorations
- [ ] Ajouter un système de notifications pour les utilisateurs concernant des objectifs de santé.
- [ ] Intégrer des fonctionnalités de suivi des exercices physiques.
- [ ] Permettre aux utilisateurs de définir des objectifs de nutrition personnalisés.
- [ ] Voir avec le fichier TODO

## 💻 Technologies utilisées

- Flutter
- Dart
- Firebase (Firestore et Auth)
- HTTP (pour les requêtes API)
