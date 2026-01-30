# Déploiement Applicatif & Observabilité (Ansible)

Nous utilisons une approche modulaire basée sur les **Rôles Ansible** pour orchestrer le cluster.

## Modularité & Dépendances

### Rôles utilisés :

1. **geerlingguy.docker** : Provisionnement des nœuds (App et ELK).
2. **app** : Déploiement du conteneur configuré avec le driver de logs GELF.
3. **haproxy** : Installation du LB avec support `option forwardfor` pour préserver l'IP client.
4. **elk** : Déploiement de la stack Elastic (Elasticsearch, Logstash, Kibana) avec parsing Grok.

## Flux de déploiement

Le playbook suit un ordre strict pour garantir la connectivité des logs :

1. **Initialisation Infrastructure** : Configuration du noyau (`vm.max_map_count`) et installation de Docker sur l'ensemble du parc.
2. **Provisionnement ELK** : Lancement de la stack Elasticsearch/Logstash en priorité pour être prêt à recevoir les flux de logs.
3. **Déploiement App** : Lancement du conteneur Olympic Tracker sur les serveurs `app_servers`. Le driver GELF pointe dynamiquement vers l'IP privée de l'ELK.
4. **Configuration LB** : Installation de HAProxy, génération dynamique du fichier `haproxy.cfg` (listant les IPs privées des Apps) et activation du forwarding d'IP réelle.
5. **Validation & Observabilité** : Vérification de l'ingestion des logs dans Kibana et création des index patterns `access-logs-*`.

## Pipeline de Logs (Logstash)

Les logs Nginx sont transformés en données structurées :

- **Input GELF** : Réception des logs Docker sur le port 12201/UDP.
- **Filter Grok** : Parsing du format `COMBINEDAPACHELOG` et enrichissement GeoIP.
- **Indexation** : Stockage dans Elasticsearch avec rotation journalière (`access-logs-%{+YYYY.MM.dd}`).

## Visualisation (Kibana)

Le dashboard centralise :

- **Volume de données** : Histogramme de trafic (Sum of bytes) par tranche de 12h.
- **Répartition des verbes HTTP** : Diagramme Donut (GET, POST, etc.).
- **Top Requêtes** : Histogramme cumulé du Top 5 des endpoints les plus sollicités.
