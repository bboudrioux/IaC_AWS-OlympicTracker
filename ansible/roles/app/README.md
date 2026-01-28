# Olympic Tracker App Role

Ce rôle déploie l'application **Olympic Participation Tracker** sous forme de conteneur Docker. Il gère l'authentification au registre GitLab, la récupération de l'image (pull) et le cycle de vie du conteneur.

## Requirements

- **Docker** : Le moteur Docker doit être installé sur l'hôte (géré par la dépendance `geerlingguy.docker`).
- **Python SDK for Docker** : Requis pour les modules Ansible `docker_container` et `docker_login` (géré par `geerlingguy.pip`).
- **Accès réseau** : L'instance doit pouvoir contacter `registry.gitlab.com`.

## Role Variables

Les variables suivantes sont définies dans `defaults/main.yml` ou passées via `group_vars` :

| Variable             | Description                                | Par défaut                |
| -------------------- | ------------------------------------------ | ------------------------- |
| `app_image_name`     | Nom complet de l'image sur GitLab Registry | `registry.gitlab.com/...` |
| `app_container_name` | Nom du conteneur Docker sur l'hôte         | `olympic-tracker`         |
| `app_port_host`      | Port exposé sur la machine hôte            | `80`                      |
| `app_port_container` | Port d'écoute interne du conteneur         | `80`                      |

**Variables Secrètes (Ansible Vault) :**

- `gitlab_user` : Identifiant pour la connexion au registre.
- `gitlab_token` : Token d'accès personnel (PAT) GitLab.

## Dependencies

Ce rôle dépend de deux rôles communautaires pour préparer l'environnement :

1. **geerlingguy.pip** : Pour installer le package Python `docker`.
2. **geerlingguy.docker** : Pour installer et configurer Docker Engine.

## Example Playbook

Voici comment intégrer ce rôle dans votre déploiement principal :

    - hosts: all
      become: yes
      roles:
         - role: app
           vars:
             app_port_host: 80

## License

MIT

## Author Information

Brian Boudrioux

Ce rôle a été créé dans le cadre du projet Olympic Tracker pour automatiser le déploiement continu d'applications conteneurisées sur AWS.
