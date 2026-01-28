# Déploiement Applicatif (Ansible)

Nous utilisons une approche modulaire basée sur les **Rôles Ansible**.

## Modularité & Dépendances

Le rôle principal `app` gère ses propres dépendances via `meta/main.yml`.

### Rôles utilisés :

1. **geerlingguy.pip** : Installe Python PIP et le SDK Docker.
2. **geerlingguy.docker** : Installe et configure le moteur Docker Engine.
3. **app** (Local) : Gère l'authentification GitLab et le cycle de vie du conteneur.

## Flux de déploiement

1. Mise à jour des caches système.
2. Installation de Docker et de ses dépendances via les rôles Galaxy.
3. Connexion au Registry GitLab via **Ansible Vault**.
4. Pull de l'image `olympic-participation-tracker`.
5. Lancement du conteneur avec redémarrage automatique.
